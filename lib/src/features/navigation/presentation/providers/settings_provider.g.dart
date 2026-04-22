// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsState)
final settingsStateProvider = SettingsStateProvider._();

final class SettingsStateProvider
    extends $AsyncNotifierProvider<SettingsState, Map<String, dynamic>> {
  SettingsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsStateHash();

  @$internal
  @override
  SettingsState create() => SettingsState();
}

String _$settingsStateHash() => r'e86f9b74028a1cb5a49055c34e30ca7fda995df8';

abstract class _$SettingsState extends $AsyncNotifier<Map<String, dynamic>> {
  FutureOr<Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>>,
                Map<String, dynamic>
              >,
              AsyncValue<Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
