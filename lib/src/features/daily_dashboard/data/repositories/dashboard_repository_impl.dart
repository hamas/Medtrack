import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../medication_management/domain/entities/adherence_log.dart';
import '../../../medication_management/domain/entities/medicine.dart';
import '../../../medication_management/domain/usecases/dose_scheduler.dart';
import '../../domain/entities/dose.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Dose>> getDailyTimeline(String userId, DateTime date) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('medicines')
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .get();

    final List<Dose> todayDoses = <Dose>[];
    final DateTime startOfDay = DateTime(date.year, date.month, date.day);
    final DateTime endOfDay = startOfDay.add(
      const Duration(hours: 23, minutes: 59, seconds: 59),
    );

    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in snapshot.docs) {
      final Medicine medicine = Medicine.fromJson(doc.data());

      final List<Dose> doses = DoseScheduler.calculateNextDoses(
        medicine,
        startAfter: startOfDay.subtract(const Duration(seconds: 1)),
      );

      for (final Dose dose in doses) {
        if (dose.scheduledTime.isAfter(endOfDay)) {
          break;
        }
        todayDoses.add(dose);
      }
    }

    todayDoses.sort(
      (Dose a, Dose b) => a.scheduledTime.compareTo(b.scheduledTime),
    );
    return todayDoses;
  }

  @override
  Future<void> recordIntake(Dose dose, DateTime intakeTime) async {
    final String logId =
        '${dose.medicine.id}_${dose.scheduledTime.millisecondsSinceEpoch}';

    final AdherenceLog log = AdherenceLog(
      id: logId,
      medicineId: dose.medicine.id,
      scheduledTime: dose.scheduledTime,
      takenTime: intakeTime,
      status: AdherenceStatus.taken,
      mealNotes: 'Recorded via Daily Dashboard',
    );

    await _firestore.collection('adherence_logs').doc(logId).set(log.toJson());
  }
}
