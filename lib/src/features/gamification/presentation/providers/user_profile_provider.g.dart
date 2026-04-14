// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userProfileRepo)
final userProfileRepoProvider = UserProfileRepoProvider._();

final class UserProfileRepoProvider
    extends
        $FunctionalProvider<
          UserProfileRepository,
          UserProfileRepository,
          UserProfileRepository
        >
    with $Provider<UserProfileRepository> {
  UserProfileRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileRepoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileRepoHash();

  @$internal
  @override
  $ProviderElement<UserProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserProfileRepository create(Ref ref) {
    return userProfileRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserProfileRepository>(value),
    );
  }
}

String _$userProfileRepoHash() => r'4a21ce376babfbb1e747f6ff806bc862a5936591';

@ProviderFor(UserProfileState)
final userProfileStateProvider = UserProfileStateProvider._();

final class UserProfileStateProvider
    extends $StreamNotifierProvider<UserProfileState, UserProfile> {
  UserProfileStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileStateHash();

  @$internal
  @override
  UserProfileState create() => UserProfileState();
}

String _$userProfileStateHash() => r'6cc0297d828428a75287d98d0da3ce738ad7193f';

abstract class _$UserProfileState extends $StreamNotifier<UserProfile> {
  Stream<UserProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserProfile>, UserProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile>, UserProfile>,
              AsyncValue<UserProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
