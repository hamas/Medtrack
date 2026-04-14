// Developed by Hamas — Medtrack Project [100% Dart Implementation]
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/dose.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

part 'daily_timeline_provider.g.dart';

@riverpod
DashboardRepository dashboardRepository(DashboardRepositoryRef ref) {
  return DashboardRepositoryImpl();
}

@riverpod
class DailyTimeline extends _$DailyTimeline {
  @override
  FutureOr<List<Dose>> build() async {
    const userId = 'hamas_lead_dev'; // In a real app, this comes from an auth provider
    final repository = ref.watch(dashboardRepositoryProvider);
    return repository.getDailyTimeline(userId, DateTime.now());
  }

  Future<void> checkOffDose(Dose dose) async {
    final previousState = state;
    
    // Snappy UI: Optimistically update the list
    if (state.hasValue) {
      final updatedList = state.value!.map((d) {
        if (d.id == dose.id) {
          return d.copyWith(isTaken: true, takenTime: DateTime.now());
        }
        return d;
      }).toList();
      state = AsyncValue.data(updatedList);
    }

    try {
      final repository = ref.read(dashboardRepositoryProvider);
      await repository.recordIntake(dose, DateTime.now());
    } catch (e, st) {
      // Rollback on error
      state = previousState;
      rethrow;
    }
  }
}
