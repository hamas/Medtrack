// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_month_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CalendarMonth)
final calendarMonthProvider = CalendarMonthProvider._();

final class CalendarMonthProvider
    extends $NotifierProvider<CalendarMonth, DateTime> {
  CalendarMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarMonthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarMonthHash();

  @$internal
  @override
  CalendarMonth create() => CalendarMonth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$calendarMonthHash() => r'6ea600f7a0a1e66ec511ab559d0a58740b2d05c9';

abstract class _$CalendarMonth extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
