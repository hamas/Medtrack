import '../features/medication_management/domain/entities/medicine.dart';
import '../features/medication_management/domain/usecases/dose_scheduler.dart';
import 'notification_manager.dart';
import '../features/daily_dashboard/domain/entities/dose.dart';

class AlarmService {
  factory AlarmService() => _instance;
  AlarmService._internal();
  static final AlarmService _instance = AlarmService._internal();

  final NotificationManager _notificationManager = NotificationManager();

  Future<void> scheduleNextAlarm(Medicine medicine) async {
    if (!medicine.isActive) {
      return;
    }

    final List<Dose> nextDoses = DoseScheduler.calculateNextDoses(medicine);
    if (nextDoses.isEmpty) {
      return;
    }

    final Dose nextDose = nextDoses.first;
    final String body = _buildContextualBody(medicine);

    await _notificationManager.scheduleNotification(
      id: medicine.id.hashCode,
      title: 'Time for ${medicine.name} (${medicine.dosage})',
      body: body,
      scheduledDate: nextDose.scheduledTime,
    );
  }

  Future<void> cancelAlarm(Medicine medicine) async {
    // Placeholder for future cancellation implementation
  }

  String _buildContextualBody(Medicine medicine) {
    final String method = medicine.deliveryMethod.name.toUpperCase();
    final String meal = _getMealInstruction(medicine.mealContext);

    return 'Dose: $method • Instructions: $meal';
  }

  String _getMealInstruction(MealContext mealContext) {
    switch (mealContext) {
      case MealContext.beforeMeal:
        return 'Before Breakfast';
      case MealContext.withMeal:
        return 'With Meal';
      case MealContext.afterMeal:
        return 'After Dinner';
      case MealContext.none:
        return 'No meal requirement';
    }
  }
}
