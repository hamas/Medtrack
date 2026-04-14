import '../../../daily_dashboard/domain/entities/dose.dart';
import '../entities/medicine.dart';

class DoseScheduler {
  DoseScheduler._();

  static List<Dose> calculateNextDoses(
    Medicine medicine, {
    DateTime? startAfter,
  }) {
    final List<Dose> doses = <Dose>[];
    final DateTime start = startAfter ?? DateTime.now();

    final DateTime? effectiveEndDate = medicine.endDate ?? 
        (medicine.durationDays != null 
          ? medicine.startDate.add(Duration(days: medicine.durationDays!)) 
          : null);

    DateTime currentDateCandidate = medicine.startDate.isAfter(start)
        ? medicine.startDate
        : DateTime(start.year, start.month, start.day);

    while (doses.length < 10) {
      if (effectiveEndDate != null && currentDateCandidate.isAfter(effectiveEndDate)) {
        break;
      }

      if (_isDoseDay(medicine, currentDateCandidate)) {
        for (final String timeStr in medicine.scheduleTimes) {
          final List<String> parts = timeStr.split(':');
          final int hour = int.parse(parts[0]);
          final int minute = int.parse(parts[1]);

          final DateTime doseDateTime = DateTime(
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
                id: '${medicine.id}_${doseDateTime.millisecondsSinceEpoch}',
                medicine: medicine,
                scheduledTime: doseDateTime,
              ),
            );
          }
          if (doses.length >= 10) {
            break;
          }
        }
      }
      currentDateCandidate = currentDateCandidate.add(const Duration(days: 1));

      if (currentDateCandidate.isAfter(start.add(const Duration(days: 365)))) {
        break;
      }
    }

    return doses;
  }

  static bool _isDoseDay(Medicine medicine, DateTime date) {
    final DateTime startDay = DateTime(
      medicine.startDate.year,
      medicine.startDate.month,
      medicine.startDate.day,
    );
    final DateTime currentDay = DateTime(date.year, date.month, date.day);
    final int diffDays = currentDay.difference(startDay).inDays;

    if (diffDays < 0) {
      return false;
    }

    switch (medicine.intervalType) {
      case IntervalType.daily:
        return diffDays % medicine.intervalCount == 0;
      case IntervalType.weekly:
        return diffDays % (7 * medicine.intervalCount) == 0;
      case IntervalType.monthly:
        if (medicine.intervalCount == 1) {
          return date.day == startDay.day;
        } else {
          final int monthDiff = (date.year - startDay.year) * 12 + date.month - startDay.month;
          return monthDiff % medicine.intervalCount == 0 && date.day == startDay.day;
        }
      case IntervalType.custom:
        switch (medicine.intervalUnit) {
          case IntervalUnit.days:
            return diffDays % medicine.intervalCount == 0;
          case IntervalUnit.weeks:
            return diffDays % (7 * medicine.intervalCount) == 0;
          case IntervalUnit.months:
            final int monthDiff = (date.year - startDay.year) * 12 + date.month - startDay.month;
            return monthDiff % medicine.intervalCount == 0 && date.day == startDay.day;
        }
    }
  }
}
