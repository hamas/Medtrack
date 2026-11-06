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
    List<Medicine> medicines = await _localDb.getMedicines();

    if (userId != 'guest_user') {
      try {
        final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('medicines')
            .where('userId', isEqualTo: userId)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final List<Medicine> remoteMeds = snapshot.docs
              .map(
                (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                    Medicine.fromJson(doc.data()),
              )
              .toList();

          for (final Medicine m in remoteMeds) {
            await _localDb.insertMedicine(m);
          }
          medicines = await _localDb.getMedicines();
        }
      } catch (e) {
        // Fallback to local DB when offline
      }
    }

    // Only active, scheduled (non-PRN) medications generate daily timeline slots
    final List<Medicine> activeScheduledMeds = medicines
        .where((Medicine m) => m.isActive && !m.isPrn)
        .toList();

    // Retrieve today's recorded adherence logs to reconcile taken and skipped states
    List<AdherenceLog> existingLogs = await _localDb.getAllAdherenceLogs();

    if (userId != 'guest_user') {
      try {
        final QuerySnapshot<Map<String, dynamic>> snap = await _firestore
            .collection('adherence_logs')
            .where('userId', isEqualTo: userId)
            .get();

        for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
            in snap.docs) {
          final AdherenceLog l = AdherenceLog.fromJson(doc.data());
          await _localDb.insertAdherenceLog(l);
        }
        existingLogs = await _localDb.getAllAdherenceLogs();
      } catch (e) {
        // Fallback to local logs when offline
      }
    }

    final Map<String, AdherenceLog> logMap = <String, AdherenceLog>{
      for (final AdherenceLog l in existingLogs)
        '${l.medicineId}_${l.scheduledTime.millisecondsSinceEpoch}': l,
    };

    final List<Dose> todayDoses = <Dose>[];
    final DateTime startOfDay = DateTime(date.year, date.month, date.day);
    final DateTime endOfDay = startOfDay.add(
      const Duration(hours: 23, minutes: 59, seconds: 59),
    );

    for (final Medicine medicine in activeScheduledMeds) {
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
        final AdherenceLog? matchLog = logMap[doseLogKey];
        final bool isHandled =
            matchLog != null &&
            (matchLog.status == AdherenceStatus.taken ||
                matchLog.status == AdherenceStatus.skipped);

        todayDoses.add(
          isHandled
              ? dose.copyWith(isTaken: true, takenTime: matchLog.takenTime)
              : dose,
        );
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
