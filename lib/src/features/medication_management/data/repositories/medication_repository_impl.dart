// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/medication_repository.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/entities/adherence_log.dart';
import '../../../../services/local_db_service.dart';
import '../../../../services/alarm_service.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalDbService _localDb;
  final AlarmService _alarmService = AlarmService();

  MedicationRepositoryImpl(this._localDb);

  @override
  Future<List<Medicine>> getMedicines(String userId) async {
    // Return local data immediately for Google Task speed
    final localMeds = await _localDb.getMedicines();

    // Background sync from Firestore (last writer wins on local)
    _syncMedicinesFromFirestore(userId);

    return localMeds;
  }

  Future<void> _syncMedicinesFromFirestore(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('medicines')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        final medicine = Medicine.fromJson(doc.data());
        await _localDb.insertMedicine(medicine);
        // Refresh alarm for each synced medicine
        await _alarmService.scheduleNextAlarm(medicine);
      }
    } catch (e) {
      // Sync failed; fallback to existing local data
    }
  }

  @override
  Future<void> saveMedicine(Medicine medicine) async {
    // 1. Save locally immediately
    await _localDb.insertMedicine(medicine);

    // 2. Schedule the system alarm
    await _alarmService.scheduleNextAlarm(medicine);

    // 3. Sync to cloud (Background/Offline-First)
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
    await _firestore.collection('medicines').doc(medicineId).delete();
    // Local deletion would be implemented in LocalDbService
  }

  @override
  Future<List<AdherenceLog>> getAdherenceLogs(String medicineId) async {
    return await _localDb.getAdherenceLogs(medicineId);
  }

  @override
  Future<void> saveAdherenceLog(AdherenceLog log) async {
    // 1. Save locally
    await _localDb.insertAdherenceLog(log);

    // 2. Sync to cloud
    try {
      await _firestore
          .collection('adherence_logs')
          .doc(log.id)
          .set(log.toJson());
    } catch (e) {
      // Handle offline queue
    }
  }
}
