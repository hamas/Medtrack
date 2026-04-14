// Developed by Hamas — Medtrack Project [100% Dart Implementation].
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/adherence_log.dart';

// An in-memory cache/mock repository for now, later connected to Firestore
class AdherenceRepository {
  final List<AdherenceLog> _logs = [];

  Future<void> saveLog(AdherenceLog log) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _logs.indexWhere((l) => l.id == log.id);
    if (index >= 0) {
      _logs[index] = log;
    } else {
      _logs.add(log);
    }
  }

  Future<List<AdherenceLog>> getLogsForMedicine(String medicineId) async {
    return _logs.where((l) => l.medicineId == medicineId).toList();
  }
}

final adherenceRepositoryProvider = Provider<AdherenceRepository>((ref) {
  return AdherenceRepository();
});

// The State Notifier handling the check-off actions dynamically
class CheckoffNotifier extends FamilyAsyncNotifier<List<AdherenceLog>, String> {

  @override
  Future<List<AdherenceLog>> build(String arg) async {
    // arg is the medicineId
    final repo = ref.read(adherenceRepositoryProvider);
    return repo.getLogsForMedicine(arg);
  }

  Future<void> checkOffMedicine({
    required DateTime scheduledTime,
    required AdherenceStatus status,
    String? mealNotes,
  }) async {
    final newLog = AdherenceLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineId: arg, // arg is accessible and holds medicineId
      scheduledTime: scheduledTime,
      takenTime: status == AdherenceStatus.taken ? DateTime.now() : null,
      status: status,
      mealNotes: mealNotes,
    );

    // Optimistically update the UI
    final previousState = state.valueOrNull ?? [];
    state = AsyncValue.data([...previousState, newLog]);

    try {
      await ref.read(adherenceRepositoryProvider).saveLog(newLog);
    } catch (e, st) {
      // Revert if failed
      state = AsyncValue.error(e, st);
    }
  }
}

// A family provider taking the medicineId to scope the state appropriately
final checkoffNotifierProvider = AsyncNotifierProviderFamily<CheckoffNotifier, List<AdherenceLog>, String>(
  () => CheckoffNotifier(),
);
