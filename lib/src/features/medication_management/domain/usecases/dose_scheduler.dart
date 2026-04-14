import '../entities/medicine.dart';

class DoseScheduler {
  /// Calculates the next 10 dose times for a given medicine.
  static List<DateTime> calculateNextDoses(Medicine medicine, {DateTime? startAfter}) {
    final List<DateTime> doses = [];
    final DateTime start = startAfter ?? DateTime.now();
    
    // We iterate forward day by day until we have 10 doses
    DateTime currentDate = DateTime(start.year, start.month, start.day);
    
    while (doses.length < 10) {
      if (_isDoseDay(medicine, currentDate)) {
        for (final timeStr in medicine.scheduleTimes) {
          final parts = timeStr.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          
          final doseDateTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            hour,
            minute,
          );
          
          if (doseDateTime.isAfter(start)) {
            doses.add(doseDateTime);
          }
          if (doses.length >= 10) break;
        }
      }
      currentDate = currentDate.add(const Duration(days: 1));
      
      // Safety limit to prevent infinite loops (e.g., 2 years)
      if (currentDate.isAfter(start.add(const Duration(days: 730)))) break;
    }
    
    return doses;
  }

  static bool _isDoseDay(Medicine medicine, DateTime date) {
    if (medicine.createdAt == null) return true; // Fallback
    
    final created = medicine.createdAt!;
    final createdDay = DateTime(created.year, created.month, created.day);
    final diffDays = date.difference(createdDay).inDays;
    
    if (diffDays < 0) return false;

    switch (medicine.intervalType) {
      case IntervalType.daily:
        return true;
      case IntervalType.weekly:
        return diffDays % 7 == 0;
      case IntervalType.customDays:
        final interval = medicine.customDayInterval ?? 1;
        return diffDays % interval == 0;
      case IntervalType.monthly:
        // Simplified: same day of the month
        return date.day == createdDay.day;
      case IntervalType.quarterly:
        // Simplified: every 3 months on the same day
        final monthDiff = (date.year - createdDay.year) * 12 + date.month - createdDay.month;
        return monthDiff % 3 == 0 && date.day == createdDay.day;
    }
  }
}
