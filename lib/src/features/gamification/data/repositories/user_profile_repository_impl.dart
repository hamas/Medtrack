import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserProfile> getUserProfile(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists) {
      // Return a default profile for the lead developer if it doesn't exist
      return UserProfile(uid: uid, name: 'Hamas');
    }

    return UserProfile.fromJson(doc.data()!);
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set(profile.toJson());
  }

  @override
  Stream<UserProfile> streamUserProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((
      DocumentSnapshot<Map<String, dynamic>> doc,
    ) {
      if (!doc.exists) {
        return UserProfile(uid: uid, name: 'Hamas');
      }
      return UserProfile.fromJson(doc.data()!);
    });
  }
}
