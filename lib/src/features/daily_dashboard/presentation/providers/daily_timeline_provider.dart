import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../../gamification/domain/entities/achievement.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dose.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../medication_management/domain/entities/medicine.dart';
import '../../../medication_management/domain/repositories/medication_repository.dart';
import '../../../medication_management/presentation/providers/all_medicines_provider.dart';
import 'package:flutter/services.dart';

part 'daily_timeline_provider.g.dart';

@riverpod
DashboardRepository dashboardRepo(Ref ref) {
  return DashboardRepositoryImpl();
}

@riverpod
class SelectedDateNotifier extends _$SelectedDateNotifier {
  @override
  DateTime build() => DateTime.now();

  void set(DateTime date) => state = date;
}

@riverpod
class DailyTimeline extends _$DailyTimeline {
  @override
  FutureOr<List<Dose>> build() async {
    final String? userId = ref.watch(currentUidProvider);
    if (userId == null) return <Dose>[];

    final DateTime date = ref.watch(selectedDateProvider);
    final DashboardRepository repository = ref.watch(dashboardRepoProvider);
    return repository.getDailyTimeline(userId, date);
  }

  Future<void> checkOffDose(Dose dose) async {
    if (state.hasValue) {
      final List<Dose> updatedList = state.value!.map((Dose d) {
        if (d.id == dose.id) {
          return d.copyWith(isTaken: true, takenTime: DateTime.now());
        }
        return d;
      }).toList();
      state = AsyncValue<List<Dose>>.data(updatedList);

      // --- Inventory Management ---
      final Medicine medicine = dose.medicine;
      if (medicine.remainingQuantity > 0) {
        final Medicine updatedMedicine = medicine.copyWith(
          remainingQuantity: medicine.remainingQuantity - 1,
        );

        final MedicationRepository medRepo = ref.read(
          medicationRepositoryProvider,
        );
        await medRepo.saveMedicine(updatedMedicine);
      }

      // --- Streak Engine Integration ---
      final bool allTaken = updatedList.every((Dose d) => d.isTaken);
      if (allTaken) {
        // Trigger Haptic Feedback
        await HapticFeedback.heavyImpact();

        await _updateStreakAndBadges();
      }

      final DashboardRepository repository = ref.read(dashboardRepoProvider);
      await repository.recordIntake(dose, DateTime.now());
    }
  }

  bool isDayComplete() {
    if (!state.hasValue) return false;
    final List<Dose> doses = state.value!;
    if (doses.isEmpty) return false;
    return doses.every((Dose d) => d.isTaken);
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
    if (newStreak == 1) newBadgeType = AchievementType.day1;
    if (newStreak == 7) newBadgeType = AchievementType.streak7;
    if (newStreak == 14) newBadgeType = AchievementType.streak14;
    if (newStreak == 30) newBadgeType = AchievementType.streak30;
    if (newStreak == 90) newBadgeType = AchievementType.day90;

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
