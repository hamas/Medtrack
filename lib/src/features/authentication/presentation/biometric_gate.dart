import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricGate extends StatefulWidget {
  const BiometricGate({required this.child, super.key});
  final Widget child;

  @override
  State<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<BiometricGate>
    with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authenticate();
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
      _authenticate();
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
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      setState(() {
        _isAuthenticated = didAuthenticate;
        _isAuthenticating = false;
      });
    } on LocalAuthException catch (e) {
      debugPrint('Biometric auth error: ${e.code}');
      setState(() {
        _isAuthenticated = false;
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return widget.child;
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.health_and_safety, size: 72, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              'Medtrack',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Authentication required',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 48),
            if (_isAuthenticating)
              const CircularProgressIndicator()
            else
              FilledButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Unlock with Biometrics'),
              ),
          ],
        ),
      ),
    );
  }
}
