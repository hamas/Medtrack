// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailyTimeline)
final dailyTimelineProvider = DailyTimelineProvider._();

final class DailyTimelineProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Dose>>,
          List<Dose>,
          FutureOr<List<Dose>>
        >
    with $FutureModifier<List<Dose>>, $FutureProvider<List<Dose>> {
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
  $FutureProviderElement<List<Dose>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Dose>> create(Ref ref) {
    return dailyTimeline(ref);
  }
}

String _$dailyTimelineHash() => r'7953d8aab5e4ff85cbc66008c514085753778def';
