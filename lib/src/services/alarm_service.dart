// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import '../features/medication_management/domain/entities/medicine.dart';
import '../features/medication_management/domain/usecases/dose_scheduler.dart';
import 'notification_manager.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final NotificationManager _notificationManager = NotificationManager();

  /// Calculates and schedules the absolute next alert for a given medicine.
  Future<void> scheduleNextAlarm(Medicine medicine) async {
    if (!medicine.isActive) return;

    final nextDoses = DoseScheduler.calculateNextDoses(medicine);
    if (nextDoses.isEmpty) return;

    final nextDose = nextDoses.first;

    // Create highly contextual body text
    final body = _buildContextualBody(medicine);

    await _notificationManager.scheduleNotification(
      id: medicine.id.hashCode, // Unique ID per medication for overriding
      title: 'Time for ${medicine.name} (${medicine.dosage})',
      body: body,
      scheduledDate: nextDose.scheduledTime,
    );
  }

  Future<void> cancelAlarm(Medicine medicine) async {
    // We would add a cancel method to NotificationManager
  }

  String _buildContextualBody(Medicine medicine) {
    final method = medicine.deliveryMethod.name.toUpperCase();
    final meal = _getMealInstruction(medicine.mealContext);

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
