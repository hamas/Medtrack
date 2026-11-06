import '../entities/dose.dart';

abstract class DashboardRepository {
  /// Fetches all scheduled doses for the current user on a specific date.
  Future<List<Dose>> getDailyTimeline(String userId, DateTime date);

  /// Records a check-off event for a specific dose.
  Future<void> recordIntake(
    Dose dose,
    DateTime intakeTime, {
    String? notes,
    bool isSkipped = false,
  });

  /// Records a clinical observation (vitals, side effects) tied to a dose without mutating dose intake status.
  Future<void> recordObservation(Dose dose, String notes);
}
