// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationCount)
final notificationCountProvider = NotificationCountProvider._();

final class NotificationCountProvider
    extends $NotifierProvider<NotificationCount, int> {
  NotificationCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationCountHash();

  @$internal
  @override
  NotificationCount create() => NotificationCount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$notificationCountHash() => r'3457e377474bbc0b0430bee9e7411b93e50a1dae';

abstract class _$NotificationCount extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ProfileSaveTrigger)
final profileSaveTriggerProvider = ProfileSaveTriggerProvider._();

final class ProfileSaveTriggerProvider
    extends $NotifierProvider<ProfileSaveTrigger, int> {
  ProfileSaveTriggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSaveTriggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSaveTriggerHash();

  @$internal
  @override
  ProfileSaveTrigger create() => ProfileSaveTrigger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$profileSaveTriggerHash() =>
    r'76cbf439a3995d8cda455b3b9bae7505b41656aa';

abstract class _$ProfileSaveTrigger extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

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

String _$settingsStateHash() => r'45e0ddaf1329fd92283c14d45e7a911f73391dfa';

abstract class _$SettingsState extends $AsyncNotifier<Map<String, dynamic>> {
  FutureOr<Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
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
    return element.handleCreate(ref, build);
  }
}
