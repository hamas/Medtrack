import '../entities/dose.dart';

abstract class DashboardRepository {
  /// Fetches all scheduled doses for the current user on a specific date.
  Future<List<Dose>> getDailyTimeline(String userId, DateTime date);
  
  /// Records a check-off event for a specific dose.
  Future<void> recordIntake(Dose dose, DateTime intakeTime);
}
