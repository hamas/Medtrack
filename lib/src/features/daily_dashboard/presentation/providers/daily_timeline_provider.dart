import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../gamification/domain/entities/achievement.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dose.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'daily_timeline_provider.g.dart';

@riverpod
DashboardRepository dashboardRepo(Ref ref) {
  return DashboardRepositoryImpl();
}

@riverpod
class DailyTimeline extends _$DailyTimeline {
  @override
  FutureOr<List<Dose>> build() async {
    const String userId = 'hamas_lead_dev';
    final DashboardRepository repository = ref.watch(dashboardRepoProvider);
    return repository.getDailyTimeline(userId, DateTime.now());
  }

  Future<void> checkOffDose(Dose dose) async {
    final AsyncValue<List<Dose>> previousState = state;

    if (state.hasValue) {
      final List<Dose> updatedList = state.value!.map((Dose d) {
        if (d.id == dose.id) {
          return d.copyWith(isTaken: true, takenTime: DateTime.now());
        }
        return d;
      }).toList();
      state = AsyncValue<List<Dose>>.data(updatedList);

      // --- Streak Engine Integration ---
      final bool allTaken = updatedList.every((Dose d) => d.isTaken);
      if (allTaken) {
        await _updateStreakAndBadges();
      }
    }

    try {
      final DashboardRepository repository = ref.read(dashboardRepoProvider);
      await repository.recordIntake(dose, DateTime.now());
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> _updateStreakAndBadges() async {
    final UserProfile profile = await ref.read(userProfileStateProvider.future);

    // Only increment if not already incremented today
    final DateTime now = DateTime.now();
    final bool alreadyDoneToday =
        profile.lastCheckoffDate != null &&
        profile.lastCheckoffDate!.year == now.year &&
        profile.lastCheckoffDate!.month == now.month &&
        profile.lastCheckoffDate!.day == now.day;

    if (alreadyDoneToday) return;

    final int newStreak = profile.currentStreak + 1;
    await ref.read(userProfileStateProvider.notifier).updateStreak(newStreak);

    // Award Badges
    AchievementType? newBadgeType;
    if (newStreak == 7) newBadgeType = AchievementType.streak7;
    if (newStreak == 14) newBadgeType = AchievementType.streak14;
    if (newStreak == 30) newBadgeType = AchievementType.streak30;

    if (newBadgeType != null) {
      await ref
          .read(userProfileStateProvider.notifier)
          .awardAchievement(
            Achievement(
              id: '${newBadgeType.id}_${now.millisecondsSinceEpoch}',
              type: newBadgeType,
              dateEarned: now,
            ),
          );
    }
  }
}
