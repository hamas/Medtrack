// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/dose.dart';
import '../../domain/usecases/dose_scheduler.dart';
import '../../data/repositories/medication_repository_impl.dart';
import '../../../../services/local_db_service.dart';

part 'timeline_provider.g.dart';

@riverpod
Future<List<Dose>> dailyTimeline(ref) async {
  // In a real app, userId would come from an auth provider
  const userId = 'hamas_lead_dev';
  
  final localDb = LocalDbService();
  final repository = MedicationRepositoryImpl(localDb);
  
  final medicines = await repository.getMedicines(userId);
  final List<Dose> todayDoses = [];
  
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(hours: 23, minutes: 59, seconds: 59));

  for (final medicine in medicines) {
    if (!medicine.isActive) continue;
    
    // Calculate next doses starting from beginning of today
    final nextDoses = DoseScheduler.calculateNextDoses(
      medicine, 
      startAfter: startOfDay.subtract(const Duration(seconds: 1)),
    );
    
    // Filter for only today's doses
    for (final dose in nextDoses) {
      if (dose.scheduledTime.isAfter(endOfDay)) break;
      todayDoses.add(dose);
    }
  }

  // Sort chronologically
  todayDoses.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  
  return todayDoses;
}
