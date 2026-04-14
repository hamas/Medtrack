// Developed by Hamas — Medtrack Project [100% Dart]
// Developed by Hamas — Medtrack Project [100% Dart Implementation]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:go_router/go_router.dart';

import 'src/services/notification_manager.dart';
import 'src/core/theme.dart';
import 'src/features/authentication/presentation/biometric_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed. Error: $e');
  }

  final notificationManager = NotificationManager();
  await notificationManager.initialize();
  await notificationManager.requestPermissions();

  runApp(
    const ProviderScope(
      child: MedTrackApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'medicine/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return CheckoffScreen(medicineId: id!);
          },
        ),
      ],
    ),
  ],
);

class MedTrackApp extends StatelessWidget {
  const MedTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return BiometricGate(
          child: MaterialApp.router(
            title: 'MedTrack',
            theme: MedTrackTheme.lightTheme(lightDynamic),
            darkTheme: MedTrackTheme.darkTheme(darkDynamic),
            themeMode: ThemeMode.system,
            routerConfig: _router,
          ),
        );
      },
    );
  }
}

// Temporary scaffold screens for routing
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MedTrack Dashboard')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/medicine/123'),
          child: const Text('View Medicine 123 check-off'),
        ),
      ),
    );
  }
}

class CheckoffScreen extends StatelessWidget {
  final String medicineId;
  const CheckoffScreen({super.key, required this.medicineId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-off')),
      body: Center(child: Text('Check-off history for $medicineId')),
    );
  }
}
