import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

part 'user_profile_provider.g.dart';

@riverpod
UserProfileRepository userProfileRepo(Ref ref) {
  return UserProfileRepositoryImpl();
}

@riverpod
class UserProfileState extends _$UserProfileState {
  @override
  Stream<UserProfile> build() {
    final AsyncValue<User?> authState = ref.watch(authStateProvider);

    return authState.when(
      data: (User? user) {
        if (user == null) {
          return Stream<UserProfile>.value(
            const UserProfile(uid: 'guest', name: 'Guest User'),
          );
        }
        return ref.watch(userProfileRepoProvider).streamUserProfile(user.uid);
      },
      loading: () => Stream<UserProfile>.value(
        const UserProfile(uid: 'loading', name: 'Loading...'),
      ),
      error: (Object e, StackTrace? s) => Stream<UserProfile>.value(
        const UserProfile(uid: 'error', name: 'Error'),
      ),
    );
  }

  Future<void> updateStreak(int newStreak) async {
    final UserProfile profile = await future;
    final UserProfile updated = profile.copyWith(
      currentStreak: newStreak,
      lastCheckoffDate: DateTime.now(),
      longestStreak: newStreak > profile.longestStreak
          ? newStreak
          : profile.longestStreak,
    );
    await ref.read(userProfileRepoProvider).saveUserProfile(updated);
  }

  Future<void> awardAchievement(Achievement achievement) async {
    final UserProfile profile = await future;
    if (profile.earnedBadges.any(
      (Achievement a) => a.type == achievement.type,
    )) {
      return;
    }
    final UserProfile updated = profile.copyWith(
      earnedBadges: <Achievement>[...profile.earnedBadges, achievement],
    );
    await ref.read(userProfileRepoProvider).saveUserProfile(updated);
  }

  Future<void> equipBadge(String? badgeId) async {
    final UserProfile profile = await future;
    final UserProfile updated = profile.copyWith(equippedBadgeId: badgeId);
    await ref.read(userProfileRepoProvider).saveUserProfile(updated);
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    await ref.read(userProfileRepoProvider).saveUserProfile(updatedProfile);
  }
}
