// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/medication_repository.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/entities/adherence_log.dart';
import '../../../../services/local_db_service.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalDbService _localDb;

  MedicationRepositoryImpl(this._localDb);

  @override
  Future<List<Medicine>> getMedicines(String userId) async {
    // 1. Return local data immediately for Google Task speed
    final localMeds = await _localDb.getMedicines();
    
    // 2. Background sync from Firestore
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
      }
    } catch (e) {
      // Log error silently, fallback to local data is already active
    }
  }

  @override
  Future<void> saveMedicine(Medicine medicine) async {
    // Last Writer Wins strategy
    // 1. Save locally
    await _localDb.insertMedicine(medicine);
    
    // 2. Sync to cloud
    await _firestore
        .collection('medicines')
        .doc(medicine.id)
        .set(medicine.toJson());
  }

  @override
  Future<void> deleteMedicine(String medicineId) async {
    // Delete from both sources
    await _firestore.collection('medicines').doc(medicineId).delete();
    // For sqflite, we would implement a delete method in localDbService
  }

  @override
  Future<List<AdherenceLog>> getAdherenceLogs(String medicineId) async {
    final localLogs = await _localDb.getAdherenceLogs(medicineId);
    
    // Background sync
    _syncLogsFromFirestore(medicineId);
    
    return localLogs;
  }

  Future<void> _syncLogsFromFirestore(String medicineId) async {
    try {
      final snapshot = await _firestore
          .collection('adherence_logs')
          .where('medicineId', isEqualTo: medicineId)
          .get();
          
      for (var doc in snapshot.docs) {
        final log = AdherenceLog.fromJson(doc.data());
        await _localDb.insertAdherenceLog(log);
      }
    } catch (e) {}
  }

  @override
  Future<void> saveAdherenceLog(AdherenceLog log) async {
    await _localDb.insertAdherenceLog(log);
    await _firestore
        .collection('adherence_logs')
        .doc(log.id)
        .set(log.toJson());
  }
}
