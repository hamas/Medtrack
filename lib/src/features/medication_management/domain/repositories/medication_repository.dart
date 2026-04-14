import '../entities/medicine.dart';
import '../entities/adherence_log.dart';

abstract class MedicationRepository {
  /// Fetches all medicines for the current user.
  Future<List<Medicine>> getMedicines(String userId);

  /// Saves a new medicine or updates an existing one.
  Future<void> saveMedicine(Medicine medicine);

  /// Deletes a medicine by ID.
  Future<void> deleteMedicine(String medicineId);

  /// Fetches logs for a specific medicine.
  Future<List<AdherenceLog>> getAdherenceLogs(String medicineId);

  /// Saves or updates an adherence log (Check-off).
  Future<void> saveAdherenceLog(AdherenceLog log);
}
