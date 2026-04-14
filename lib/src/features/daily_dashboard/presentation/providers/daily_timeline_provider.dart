import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dose.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'daily_timeline_provider.g.dart';

@riverpod
DashboardRepository dashboardRepo(Ref ref) {
  return DashboardRepositoryImpl();
}

@riverpod
class DailyTimeline extends _$DailyTimeline {
  @override
  FutureOr<List<Dose>> build() async {
    const String userId = 'hamas_lead_dev';
    final DashboardRepository repository = ref.watch(dashboardRepoProvider);
    return repository.getDailyTimeline(userId, DateTime.now());
  }

  Future<void> checkOffDose(Dose dose) async {
    final AsyncValue<List<Dose>> previousState = state;
    
    if (state.hasValue) {
      final List<Dose> updatedList = state.value!.map((Dose d) {
        if (d.id == dose.id) {
          return d.copyWith(isTaken: true, takenTime: DateTime.now());
        }
        return d;
      }).toList();
      state = AsyncValue<List<Dose>>.data(updatedList);
    }

    try {
      final DashboardRepository repository = ref.read(dashboardRepoProvider);
      await repository.recordIntake(dose, DateTime.now());
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }
}
