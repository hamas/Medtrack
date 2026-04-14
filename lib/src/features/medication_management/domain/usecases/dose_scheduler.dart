// Developed by Hamas — Medtrack Project [100% Dart Implementation]
import '../entities/medicine.dart';
import '../../../daily_dashboard/domain/entities/dose.dart';

class DoseScheduler {
  /// Calculates the next 10 dose objects for a given medicine.
  static List<Dose> calculateNextDoses(
    Medicine medicine, {
    DateTime? startAfter,
  }) {
    final List<Dose> doses = [];
    final DateTime start = startAfter ?? DateTime.now();

    // Calculate effective endDate if durationDays is provided
    final effectiveEndDate = medicine.endDate ?? 
        (medicine.durationDays != null 
          ? medicine.startDate.add(Duration(days: medicine.durationDays!)) 
          : null);

    // Use local candiate for consistency
    DateTime currentDateCandidate = medicine.startDate.isAfter(start)
        ? medicine.startDate
        : DateTime(start.year, start.month, start.day);

    while (doses.length < 10) {
      if (effectiveEndDate != null && currentDateCandidate.isAfter(effectiveEndDate)) {
        break;
      }

      if (_isDoseDay(medicine, currentDateCandidate)) {
        for (final timeStr in medicine.scheduleTimes) {
          final parts = timeStr.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);

          // Create dose at local time
          final doseDateTime = DateTime(
            currentDateCandidate.year,
            currentDateCandidate.month,
            currentDateCandidate.day,
            hour,
            minute,
          );

          if (doseDateTime.isAfter(start)) {
            if (effectiveEndDate != null && doseDateTime.isAfter(effectiveEndDate)) {
              break;
            }

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

      // Limit search range to 1 year
      if (currentDateCandidate.isAfter(start.add(const Duration(days: 365)))) break;
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
        return diffDays % medicine.intervalCount == 0;
      case IntervalType.weekly:
        return diffDays % (7 * medicine.intervalCount) == 0;
      case IntervalType.monthly:
        // Match day of month
        if (medicine.intervalCount == 1) {
          return date.day == startDay.day;
        } else {
          // Complex interval like "Every 3 months"
          final monthDiff = (date.year - startDay.year) * 12 + date.month - startDay.month;
          return monthDiff % medicine.intervalCount == 0 && date.day == startDay.day;
        }
      case IntervalType.custom:
        switch (medicine.intervalUnit) {
          case IntervalUnit.days:
            return diffDays % medicine.intervalCount == 0;
          case IntervalUnit.weeks:
            return diffDays % (7 * medicine.intervalCount) == 0;
          case IntervalUnit.months:
            final monthDiff = (date.year - startDay.year) * 12 + date.month - startDay.month;
            return monthDiff % medicine.intervalCount == 0 && date.day == startDay.day;
        }
    }
  }
}
