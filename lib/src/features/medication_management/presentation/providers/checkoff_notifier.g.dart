// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkoff_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CheckoffNotifier)
final checkoffProvider = CheckoffNotifierFamily._();

final class CheckoffNotifierProvider
    extends $AsyncNotifierProvider<CheckoffNotifier, List<AdherenceLog>> {
  CheckoffNotifierProvider._({
    required CheckoffNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'checkoffProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$checkoffNotifierHash();

  @override
  String toString() {
    return r'checkoffProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CheckoffNotifier create() => CheckoffNotifier();

  @override
  bool operator ==(Object other) {
    return other is CheckoffNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$checkoffNotifierHash() => r'c6db44ae2fa0ee593c2db7deee24c770042a48c7';

final class CheckoffNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CheckoffNotifier,
          AsyncValue<List<AdherenceLog>>,
          List<AdherenceLog>,
          FutureOr<List<AdherenceLog>>,
          String
        > {
  CheckoffNotifierFamily._()
    : super(
        retry: null,
        name: r'checkoffProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CheckoffNotifierProvider call(String medicineId) =>
      CheckoffNotifierProvider._(argument: medicineId, from: this);

  @override
  String toString() => r'checkoffProvider';
}

abstract class _$CheckoffNotifier extends $AsyncNotifier<List<AdherenceLog>> {
  late final _$args = ref.$arg as String;
  String get medicineId => _$args;

  FutureOr<List<AdherenceLog>> build(String medicineId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<AdherenceLog>>, List<AdherenceLog>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AdherenceLog>>, List<AdherenceLog>>,
              AsyncValue<List<AdherenceLog>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
