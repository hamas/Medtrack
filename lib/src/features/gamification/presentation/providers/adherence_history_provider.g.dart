// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adherence_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adherenceHistory)
final adherenceHistoryProvider = AdherenceHistoryProvider._();

final class AdherenceHistoryProvider extends $FunctionalProvider<
        AsyncValue<Map<DateTime, int>>,
        Map<DateTime, int>,
        FutureOr<Map<DateTime, int>>>
    with
        $FutureModifier<Map<DateTime, int>>,
        $FutureProvider<Map<DateTime, int>> {
  AdherenceHistoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'adherenceHistoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$adherenceHistoryHash();

  @$internal
  @override
  $FutureProviderElement<Map<DateTime, int>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<DateTime, int>> create(Ref ref) {
    return adherenceHistory(ref);
  }
}

String _$adherenceHistoryHash() => r'0fffaa164d30702fa78f59bc4567e12314629fb6';
