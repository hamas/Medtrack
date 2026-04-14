// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack/src/features/medication_management/domain/entities/medicine.dart';
import 'package:medtrack/src/features/medication_management/domain/usecases/dose_scheduler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();

  group('Scheduling Logic Unit Tests', () {
    final now = DateTime(2026, 4, 14, 10, 0); // Tuesday 10 AM
    final startDate = DateTime(2026, 4, 13, 0, 0); // Monday

    final dailyMedicine = Medicine(
      id: '1',
      userId: 'user1',
      name: 'Aspirin',
      dosage: '100mg',
      intervalType: IntervalType.daily,
      scheduleTimes: ['08:00', '20:00'],
      mealContext: MealContext.withMeal,
      deliveryMethod: DeliveryMethod.water,
      startDate: startDate,
      createdAt: now.subtract(const Duration(days: 1)),
    );

    test('should calculate correct next 10 doses for daily medicine', () {
      final nextDoses = DoseScheduler.calculateNextDoses(
        dailyMedicine,
        startAfter: now,
      );

      expect(nextDoses.length, 10);
      // First dose should be today at 20:00 (since 08:00 already passed)
      expect(nextDoses[0].scheduledTime, DateTime(2026, 4, 14, 20, 0));
      // Second dose should be tomorrow at 08:00
      expect(nextDoses[1].scheduledTime, DateTime(2026, 4, 15, 08, 0));
    });

    test('should calculate correct doses for weekly interval', () {
      final weeklyMedicine = dailyMedicine.copyWith(
        intervalType: IntervalType.weekly,
      );

      final nextDoses = DoseScheduler.calculateNextDoses(
        weeklyMedicine,
        startAfter: now,
      );

      // Since startDate was April 13th (Monday), 
      // the next "weekly" occurrence where diffDays % 7 == 0 is April 20th.
      expect(nextDoses[0].scheduledTime, DateTime(2026, 4, 20, 08, 0));
      expect(nextDoses[1].scheduledTime, DateTime(2026, 4, 20, 20, 0));
    });
  });
}
