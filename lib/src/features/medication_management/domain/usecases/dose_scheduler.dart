// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:timezone/timezone.dart' as tz;
import '../entities/medicine.dart';
import '../entities/dose.dart';

class DoseScheduler {
  /// Calculates the next 10 dose objects for a given medicine.
  static List<Dose> calculateNextDoses(
    Medicine medicine, {
    DateTime? startAfter,
  }) {
    final List<Dose> doses = [];
    final DateTime start = startAfter ?? DateTime.now();

    // We iterate forward day by day until we have 10 doses
    // Ensuring we start from the medicine's startDate or the current date
    DateTime currentDateCandidate = medicine.startDate.isAfter(start)
        ? medicine.startDate
        : DateTime(start.year, start.month, start.day);

    while (doses.length < 10) {
      // Check if we passed the endDate
      if (medicine.endDate != null &&
          currentDateCandidate.isAfter(medicine.endDate!))
        break;

      if (_isDoseDay(medicine, currentDateCandidate)) {
        for (final timeStr in medicine.scheduleTimes) {
          final parts = timeStr.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);

          final doseDateTime = DateTime(
            currentDateCandidate.year,
            currentDateCandidate.month,
            currentDateCandidate.day,
            hour,
            minute,
          );

          if (doseDateTime.isAfter(start)) {
            // Check endDate again for the specific time
            if (medicine.endDate != null &&
                doseDateTime.isAfter(medicine.endDate!))
              break;

            doses.add(
              Dose(
                id: "${medicine.id}_${doseDateTime.millisecondsSinceEpoch}",
                medicine: medicine,
                scheduledTime: doseDateTime,
              ),
            );
          }
          if (doses.length >= 10) break;
        }
      }
      currentDateCandidate = currentDateCandidate.add(const Duration(days: 1));

      // Safety limit to prevent infinite loops (e.g., 2 years)
      if (currentDateCandidate.isAfter(start.add(const Duration(days: 730))))
        break;
    }

    return doses;
  }

  static bool _isDoseDay(Medicine medicine, DateTime date) {
    final startDay = DateTime(
      medicine.startDate.year,
      medicine.startDate.month,
      medicine.startDate.day,
    );
    final currentDay = DateTime(date.year, date.month, date.day);
    final diffDays = currentDay.difference(startDay).inDays;

    if (diffDays < 0) return false;

    switch (medicine.intervalType) {
      case IntervalType.daily:
        return true;
      case IntervalType.weekly:
        return diffDays % 7 == 0;
      case IntervalType.biWeekly:
        return diffDays % 14 == 0;
      case IntervalType.customDays:
        final interval = medicine.customDayInterval ?? 1;
        return diffDays % interval == 0;
      case IntervalType.monthly:
        return date.day == startDay.day;
      case IntervalType.quarterly:
        final monthDiff =
            (date.year - startDay.year) * 12 + date.month - startDay.month;
        return monthDiff % 3 == 0 && date.day == startDay.day;
    }
  }
}
