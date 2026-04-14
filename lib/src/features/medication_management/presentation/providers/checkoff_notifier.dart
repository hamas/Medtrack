import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../services/local_db_service.dart';
import '../../data/repositories/medication_repository_impl.dart';
import '../../domain/entities/adherence_log.dart';

part 'checkoff_notifier.g.dart';

@riverpod
class CheckoffNotifier extends _$CheckoffNotifier {
  @override
  FutureOr<List<AdherenceLog>> build(String medicineId) async {
    final LocalDbService localDb = LocalDbService();
    final MedicationRepositoryImpl repository = MedicationRepositoryImpl(
      localDb,
    );
    return repository.getAdherenceLogs(medicineId);
  }

  Future<void> checkOffMedicine({
    required DateTime scheduledTime,
    required AdherenceStatus status,
    String? mealNotes,
  }) async {
    final AdherenceLog newLog = AdherenceLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineId: medicineId,
      scheduledTime: scheduledTime,
      takenTime: status == AdherenceStatus.taken ? DateTime.now() : null,
      status: status,
      mealNotes: mealNotes,
    );

    final List<AdherenceLog> currentData = state.value ?? <AdherenceLog>[];
    state = AsyncValue<List<AdherenceLog>>.data(<AdherenceLog>[
      ...currentData,
      newLog,
    ]);

    try {
      final LocalDbService localDb = LocalDbService();
      final MedicationRepositoryImpl repository = MedicationRepositoryImpl(
        localDb,
      );
      await repository.saveAdherenceLog(newLog);
    } catch (e, st) {
      state = AsyncValue<List<AdherenceLog>>.error(e, st);
    }
  }
}
