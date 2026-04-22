import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/authentication/presentation/widgets/biometric_gate.dart';
import 'src/core/services/health_tips_service.dart';
import 'src/features/gamification/presentation/screens/achievements_screen.dart';
import 'src/features/navigation/presentation/screens/profile_settings_screen.dart';
import 'src/features/navigation/presentation/screens/notifications_screen.dart';
import 'src/features/navigation/presentation/screens/security_screen.dart';
import 'src/features/medication_management/presentation/screens/add_medicine_screen.dart';
import 'src/features/navigation/presentation/screens/policies_screen.dart';
import 'src/features/navigation/presentation/screens/readme_screen.dart';
import 'src/features/navigation/presentation/screens/privacy_policy_screen.dart';
import 'src/features/navigation/presentation/screens/main_screen.dart';
import 'src/core/services/firebase_service.dart';
import 'src/core/services/notification_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final FirebaseService firebaseService = FirebaseService();
    await firebaseService.initialize();
    await firebaseService.ensureAuthenticated();
  } catch (e) {
    debugPrint('Firebase initialization failed. Error: $e');
  }

  final NotificationManager notificationManager = NotificationManager();
  await notificationManager.initialize();
  await notificationManager.requestPermissions();

  // Initialize Health Tips Scheduler
  final HealthTipsService healthTipsService = HealthTipsService.instance;
  await healthTipsService.scheduleDiscoveryTips();

  runApp(const ProviderScope(child: MedTrackApp()));
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) =>
          BiometricGate(child: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const MainScreen(),
        ),
        GoRoute(
          path: '/add-medicine',
          builder: (BuildContext context, GoRouterState state) =>
              const AddMedicineScreen(),
        ),
        GoRoute(
          path: '/badges',
          builder: (BuildContext context, GoRouterState state) =>
              const AchievementsScreen(),
        ),
        GoRoute(
          path: '/achievements',
          builder: (BuildContext context, GoRouterState state) =>
              const AchievementsScreen(),
        ),
        GoRoute(
          path: '/profile-settings',
          builder: (BuildContext context, GoRouterState state) =>
              const ProfileSettingsScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (BuildContext context, GoRouterState state) =>
              const NotificationsScreen(),
        ),
        GoRoute(
          path: '/security',
          builder: (BuildContext context, GoRouterState state) =>
              const SecurityScreen(),
        ),
        GoRoute(
          path: '/policies',
          builder: (BuildContext context, GoRouterState state) =>
              const PoliciesScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: 'readme',
              builder: (BuildContext context, GoRouterState state) =>
                  const ReadmeScreen(),
            ),
            GoRoute(
              path: 'privacy',
              builder: (BuildContext context, GoRouterState state) =>
                  const PrivacyPolicyScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class MedTrackApp extends StatelessWidget {
  const MedTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Medtrack',
      theme: MedTrackTheme.lightTheme(),
      darkTheme: MedTrackTheme.darkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
