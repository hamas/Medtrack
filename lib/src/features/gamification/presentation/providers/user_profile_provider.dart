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
    final String? userId = ref.watch(currentUidProvider);
    if (userId == null) {
      // Return a dummy stream or handle unauthenticated state
      return const Stream<UserProfile>.empty();
    }
    return ref.watch(userProfileRepoProvider).streamUserProfile(userId);
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
}
