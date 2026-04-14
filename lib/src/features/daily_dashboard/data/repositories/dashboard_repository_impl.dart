import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/dose.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../medication_management/domain/entities/medicine.dart';
import '../../../medication_management/domain/usecases/dose_scheduler.dart';
import '../../../medication_management/domain/entities/adherence_log.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Dose>> getDailyTimeline(String userId, DateTime date) async {
    // 1. Fetch medicines from Firestore
    final snapshot = await _firestore
        .collection('medicines')
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .get();

    final List<Dose> todayDoses = [];
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(hours: 23, minutes: 59, seconds: 59));

    // 2. Generate doses and filter for specific date
    for (var doc in snapshot.docs) {
      final medicine = Medicine.fromJson(doc.data());
      
      // Calculate doses starting from the target date's beginning
      final doses = DoseScheduler.calculateNextDoses(
        medicine,
        startAfter: startOfDay.subtract(const Duration(seconds: 1)),
      );

      for (final dose in doses) {
        if (dose.scheduledTime.isAfter(endOfDay)) break;
        todayDoses.add(dose);
      }
    }

    // 3. Sort chronologically
    todayDoses.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return todayDoses;
  }

  @override
  Future<void> recordIntake(Dose dose, DateTime intakeTime) async {
    final logId = '${dose.medicine.id}_${dose.scheduledTime.millisecondsSinceEpoch}';
    
    final log = AdherenceLog(
      id: logId,
      medicineId: dose.medicine.id,
      scheduledTime: dose.scheduledTime,
      takenTime: intakeTime,
      status: AdherenceStatus.taken,
      mealNotes: 'Recorded via Daily Dashboard',
    );

    await _firestore
        .collection('adherence_logs')
        .doc(logId)
        .set(log.toJson());
  }
}
