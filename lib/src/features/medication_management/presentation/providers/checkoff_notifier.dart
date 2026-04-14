// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/adherence_log.dart';
import '../../data/repositories/medication_repository_impl.dart';
import '../../../../services/local_db_service.dart';

part 'checkoff_notifier.g.dart';

@riverpod
class CheckoffNotifier extends _$CheckoffNotifier {
  @override
  Future<List<AdherenceLog>> build(String medicineId) async {
    // In a real app, Repository would be its own provider
    final localDb = LocalDbService();
    final repository = MedicationRepositoryImpl(localDb);
    return repository.getAdherenceLogs(medicineId);
  }

  Future<void> checkOffMedicine({
    required DateTime scheduledTime,
    required AdherenceStatus status,
    String? mealNotes,
  }) async {
    final newLog = AdherenceLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineId: medicineId, // Fixed: use medicineId from build()
      scheduledTime: scheduledTime,
      takenTime: status == AdherenceStatus.taken ? DateTime.now() : null,
      status: status,
      mealNotes: mealNotes,
    );

    // Optimistically update the UI
    final currentData = state.asData?.value ?? [];
    state = AsyncValue.data([...currentData, newLog]);

    try {
      final localDb = LocalDbService();
      final repository = MedicationRepositoryImpl(localDb);
      await repository.saveAdherenceLog(newLog);
    } catch (e, st) {
      // Revert or show error
      state = AsyncValue.error(e, st);
    }
  }
}
