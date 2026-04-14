// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_timeline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardRepo)
final dashboardRepoProvider = DashboardRepoProvider._();

final class DashboardRepoProvider
    extends
        $FunctionalProvider<
          DashboardRepository,
          DashboardRepository,
          DashboardRepository
        >
    with $Provider<DashboardRepository> {
  DashboardRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardRepoHash();

  @$internal
  @override
  $ProviderElement<DashboardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DashboardRepository create(Ref ref) {
    return dashboardRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardRepository>(value),
    );
  }
}

String _$dashboardRepoHash() => r'b5a4c13a15911d2498158d4f0fbc9b524d56033a';

@ProviderFor(DailyTimeline)
final dailyTimelineProvider = DailyTimelineProvider._();

final class DailyTimelineProvider
    extends $AsyncNotifierProvider<DailyTimeline, List<Dose>> {
  DailyTimelineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyTimelineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyTimelineHash();

  @$internal
  @override
  DailyTimeline create() => DailyTimeline();
}

String _$dailyTimelineHash() => r'c9fb2b770d849f342e8a739daf1c31182496e6b1';

abstract class _$DailyTimeline extends $AsyncNotifier<List<Dose>> {
  FutureOr<List<Dose>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Dose>>, List<Dose>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Dose>>, List<Dose>>,
              AsyncValue<List<Dose>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
