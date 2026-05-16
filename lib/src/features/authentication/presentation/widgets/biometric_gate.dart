import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../navigation/presentation/providers/settings_provider.dart';

import '../../../../core/widgets/ambient_background.dart';

class BiometricGate extends ConsumerStatefulWidget {
  const BiometricGate({required this.child, super.key});
  final Widget child;

  @override
  ConsumerState<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends ConsumerState<BiometricGate>
    with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndAuthenticate();
  }

  Future<void> _checkAndAuthenticate() async {
    if (kIsWeb) {
      if (mounted) {
        setState(() => _isAuthenticated = true);
      }
      return;
    }

    // Wait for settings to load
    final Map<String, dynamic> settings = await ref.read(
      settingsStateProvider.future,
    );
    if (!((settings['biometric_enabled'] as bool?) ?? false)) {
      setState(() => _isAuthenticated = true);
      return;
    }
    await _authenticate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        !_isAuthenticated &&
        !_isAuthenticating) {
      _checkAndAuthenticate();
    } else if (state == AppLifecycleState.paused) {
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  Future<void> _authenticate() async {
    setState(() => _isAuthenticating = true);
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        // No biometric support: grant access automatically as a fallback.
        setState(() {
          _isAuthenticated = true;
          _isAuthenticating = false;
        });
        return;
      }

      // local_auth v3 API: flat named parameters, no AuthenticationOptions wrapper.
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to access your medical data.',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );

      setState(() {
        _isAuthenticated = didAuthenticate;
        _isAuthenticating = false;
      });
    } on LocalAuthException catch (e) {
      debugPrint('Biometric auth error: ${e.code}');
      // If the biometric UI is unavailable (e.g. no biometrics enrolled,
      // device policy, or emulator), grant access gracefully.
      final bool bypass =
          e.code == LocalAuthExceptionCode.uiUnavailable ||
          e.code == LocalAuthExceptionCode.noBiometricsEnrolled ||
          e.code == LocalAuthExceptionCode.noBiometricHardware ||
          e.code == LocalAuthExceptionCode.noCredentialsSet ||
          e.code ==
              LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable;
      setState(() {
        _isAuthenticated = bypass;
        _isAuthenticating = false;
      });
    } catch (e) {
      debugPrint('Biometric auth generic error: $e');
      setState(() {
        _isAuthenticated = true;
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return widget.child;
    }
    return AmbientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Symbols.health_and_safety_rounded,
                size: 72,
                color: Colors.white70,
                fill: 1,
              ),
              const SizedBox(height: 20),
              Text(
                'Medtrack',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Authentication required',
                style: TextStyle(color: Colors.white38),
              ),
              const SizedBox(height: 48),
              if (_isAuthenticating)
                const CircularProgressIndicator()
              else
                FilledButton.icon(
                  onPressed: _authenticate,
                  icon: const Icon(Symbols.fingerprint_rounded),
                  label: const Text('Unlock with Biometrics'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
