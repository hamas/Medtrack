import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _prefKey = 'cached_user_profile';

  @override
  Future<UserProfile> getUserProfile(String uid) async {
    // 1. Try local cache first for instant offline responsiveness
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedJson = prefs.getString('${_prefKey}_$uid');
    UserProfile? cachedProfile;
    if (cachedJson != null) {
      try {
        cachedProfile = UserProfile.fromJson(
          jsonDecode(cachedJson) as Map<String, dynamic>,
        );
      } catch (_) {}
    }

    if (uid == 'guest' || uid == 'guest_user') {
      return cachedProfile ?? const UserProfile(uid: 'guest', name: 'Hamas');
    }

    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final UserProfile remote = UserProfile.fromJson(doc.data()!);
        await prefs.setString('${_prefKey}_$uid', jsonEncode(remote.toJson()));
        return remote;
      }
    } catch (_) {
      // Offline fallback
    }

    return cachedProfile ?? UserProfile(uid: uid, name: 'Hamas');
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    // 1. Always cache locally
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '${_prefKey}_${profile.uid}',
      jsonEncode(profile.toJson()),
    );

    // 2. Sync to cloud if not in guest mode
    if (profile.uid == 'guest' || profile.uid == 'guest_user') return;
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toJson());
    } catch (_) {
      // Offline fallback
    }
  }

  @override
  Stream<UserProfile> streamUserProfile(String uid) async* {
    // Yield local cached profile immediately
    final UserProfile initial = await getUserProfile(uid);
    yield initial;

    if (uid == 'guest' || uid == 'guest_user') return;

    yield* _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> doc) {
          if (!doc.exists || doc.data() == null) {
            return initial;
          }
          final UserProfile remote = UserProfile.fromJson(doc.data()!);
          SharedPreferences.getInstance().then((SharedPreferences p) {
            p.setString('${_prefKey}_$uid', jsonEncode(remote.toJson()));
          });
          return remote;
        })
        .handleError((_) {});
  }
}
