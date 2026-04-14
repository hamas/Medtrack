import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'src/core/theme.dart';
import 'src/features/authentication/presentation/biometric_gate.dart';
import 'src/features/medication_management/presentation/screens/add_medicine_screen.dart';
import 'src/features/navigation/presentation/screens/main_screen.dart';
import 'src/services/firebase_service.dart';
import 'src/services/notification_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final FirebaseService firebaseService = FirebaseService();
    await firebaseService.initialize();
  } catch (e) {
    debugPrint('Firebase initialization failed. Error: $e');
  }

  final NotificationManager notificationManager = NotificationManager();
  await notificationManager.initialize();
  await notificationManager.requestPermissions();

  runApp(const ProviderScope(child: MedTrackApp()));
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const MainScreen(),
    ),
    GoRoute(
      path: '/add-medicine',
      builder: (BuildContext context, GoRouterState state) => const AddMedicineScreen(),
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
            title: 'Medtrack',
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
