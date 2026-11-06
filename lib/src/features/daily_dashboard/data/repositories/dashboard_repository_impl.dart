import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/local_db_service.dart';

import '../../../medication_management/domain/entities/adherence_log.dart';
import '../../../medication_management/domain/entities/medicine.dart';
import '../../../medication_management/domain/usecases/dose_scheduler.dart';
import '../../domain/entities/dose.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({LocalDbService? localDb})
    : _localDb = localDb ?? LocalDbService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalDbService _localDb;

  @override
  Future<List<Dose>> getDailyTimeline(String userId, DateTime date) async {
    final List<Medicine> medicines = <Medicine>[];

    if (userId == 'guest_user') {
      medicines.addAll(await _localDb.getMedicines());
    } else {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('medicines')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        medicines.add(Medicine.fromJson(doc.data()));
      }
    }

    // Retrieve today's recorded adherence logs to reconcile taken state
    final List<AdherenceLog> existingLogs = userId == 'guest_user'
        ? await _localDb.getAllAdherenceLogs()
        : await _firestore
              .collection('adherence_logs')
              .where('userId', isEqualTo: userId)
              .get()
              .then(
                (QuerySnapshot<Map<String, dynamic>> snap) => snap.docs
                    .map(
                      (QueryDocumentSnapshot<Map<String, dynamic>> d) =>
                          AdherenceLog.fromJson(d.data()),
                    )
                    .toList(),
              );

    final Set<String> takenLogIds = existingLogs
        .where((AdherenceLog l) => l.status == AdherenceStatus.taken)
        .map(
          (AdherenceLog l) =>
              '${l.medicineId}_${l.scheduledTime.millisecondsSinceEpoch}',
        )
        .toSet();

    final List<Dose> todayDoses = <Dose>[];
    final DateTime startOfDay = DateTime(date.year, date.month, date.day);
    final DateTime endOfDay = startOfDay.add(
      const Duration(hours: 23, minutes: 59, seconds: 59),
    );

    for (final Medicine medicine in medicines) {
      final List<Dose> doses = DoseScheduler.calculateNextDoses(
        medicine,
        startAfter: startOfDay.subtract(const Duration(seconds: 1)),
      );

      for (final Dose dose in doses) {
        if (dose.scheduledTime.isAfter(endOfDay)) {
          break;
        }
        final String doseLogKey =
            '${dose.medicine.id}_${dose.scheduledTime.millisecondsSinceEpoch}';
        final bool isAlreadyTaken = takenLogIds.contains(doseLogKey);
        todayDoses.add(isAlreadyTaken ? dose.copyWith(isTaken: true) : dose);
      }
    }

    todayDoses.sort(
      (Dose a, Dose b) => a.scheduledTime.compareTo(b.scheduledTime),
    );
    return todayDoses;
  }

  @override
  Future<void> recordIntake(
    Dose dose,
    DateTime intakeTime, {
    String? notes,
    bool isSkipped = false,
  }) async {
    final String logId =
        '${dose.medicine.id}_${dose.scheduledTime.millisecondsSinceEpoch}';
    final String userId = dose.medicine.userId;

    final AdherenceLog log = AdherenceLog(
      id: logId,
      medicineId: dose.medicine.id,
      userId: userId,
      scheduledTime: dose.scheduledTime,
      takenTime: isSkipped ? null : intakeTime,
      status: isSkipped ? AdherenceStatus.skipped : AdherenceStatus.taken,
      mealNotes:
          notes ??
          (isSkipped ? 'Dose skipped by user' : 'Recorded via Daily Dashboard'),
    );

    await _localDb.insertAdherenceLog(log);

    if (userId != 'guest_user') {
      try {
        await _firestore
            .collection('adherence_logs')
            .doc(logId)
            .set(log.toJson());
      } catch (e) {
        // Fallback for offline sync
      }
    }
  }
}
