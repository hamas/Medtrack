import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../medication_management/domain/entities/adherence_log.dart';
import '../../../medication_management/presentation/providers/all_medicines_provider.dart';
import '../../../medication_management/domain/repositories/medication_repository.dart';

part 'adherence_history_provider.g.dart';

@riverpod
Future<Map<DateTime, int>> adherenceHistory(Ref ref) async {
  final MedicationRepository medRepo = ref.watch(medicationRepositoryProvider);
  final List<AdherenceLog> logs = await medRepo.getAllAdherenceLogs();

  final Map<DateTime, int> history = <DateTime, int>{};

  for (final AdherenceLog log in logs) {
    if (log.status == AdherenceStatus.taken) {
      final DateTime date = DateTime(
        log.scheduledTime.year,
        log.scheduledTime.month,
        log.scheduledTime.day,
      );
      history[date] = (history[date] ?? 0) + 1;
    }
  }

  return history;
}
