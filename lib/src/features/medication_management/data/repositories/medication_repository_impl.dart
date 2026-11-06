import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/alarm_service.dart';
import '../../../../core/services/local_db_service.dart';
import '../../domain/entities/adherence_log.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/repositories/medication_repository.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  MedicationRepositoryImpl(this._localDb);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalDbService _localDb;
  final AlarmService _alarmService = AlarmService();

  @override
  Future<List<Medicine>> getMedicines(String userId) async {
    final List<Medicine> localMeds = await _localDb.getMedicines();
    unawaited(_syncMedicinesFromFirestore(userId));
    return localMeds;
  }

  @override
  Stream<List<Medicine>> streamMedicines(String userId) async* {
    // 1. Yield local data immediately for high-fidelity responsiveness
    final List<Medicine> localMeds = await _localDb.getMedicines();
    yield localMeds;

    // 2. Skip Firestore if we're in guest mode (avoids PERMISSION_DENIED)
    if (userId == 'guest_user') return;

    // 3. Continue with Firestore snapshots for real-time synchronization
    yield* _firestore
        .collection('medicines')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
          final List<Medicine> remoteList = snapshot.docs
              .map(
                (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                    Medicine.fromJson(doc.data()),
              )
              .toList();

          // Sync into local SQLite so cabinet persists offline
          for (final Medicine m in remoteList) {
            _localDb.insertMedicine(m);
          }
          return remoteList;
        })
        .handleError((Object error) {
          // Keep stream alive when offline
        });
  }

  Future<void> _syncMedicinesFromFirestore(String userId) async {
    if (userId == 'guest_user') return;
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('medicines')
          .where('userId', isEqualTo: userId)
          .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        final Medicine medicine = Medicine.fromJson(doc.data());
        await _localDb.insertMedicine(medicine);
        await _alarmService.scheduleNextAlarm(medicine);
      }
    } catch (e) {
      // Sync failed; fallback to existing local data
    }
  }

  @override
  Future<void> saveMedicine(Medicine medicine) async {
    await _localDb.insertMedicine(medicine);
    await _alarmService.scheduleNextAlarm(medicine);

    if (medicine.userId == 'guest_user') return;
    try {
      await _firestore
          .collection('medicines')
          .doc(medicine.id)
          .set(medicine.toJson());
    } catch (e) {
      // Mark for background sync in a real app
    }
  }

  @override
  Future<void> deleteMedicine(String medicineId) async {
    await _localDb.deleteMedicine(medicineId);
    try {
      await _firestore.collection('medicines').doc(medicineId).delete();
    } catch (e) {
      // Ignore if offline
    }
  }

  @override
  Future<List<AdherenceLog>> getAdherenceLogs(String medicineId) async {
    return _localDb.getAdherenceLogs(medicineId);
  }

  @override
  Future<void> saveAdherenceLog(AdherenceLog log) async {
    await _localDb.insertAdherenceLog(log);

    try {
      await _firestore
          .collection('adherence_logs')
          .doc(log.id)
          .set(log.toJson());
    } catch (e) {
      // Handle offline queue
    }
  }

  @override
  Future<List<AdherenceLog>> getAllAdherenceLogs() async {
    return _localDb.getAllAdherenceLogs();
  }
}
