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
import 'src/features/daily_dashboard/presentation/screens/daily_dashboard_screen.dart';
import 'src/features/medication_management/presentation/screens/medicine_list_screen.dart';
import 'src/features/history_tracking/presentation/screens/calendar_screen.dart';
import 'src/features/navigation/presentation/screens/menu_screen.dart';
import 'src/core/services/firebase_service.dart';
import 'src/core/services/notification_manager.dart';
import 'src/core/utils/motion_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
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

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    // Biometric Gate as the outer shell
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) =>
          BiometricGate(child: child),
      routes: <RouteBase>[
        // Main Persistent Shell for ALL pages
        StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) {
            return MainScreen(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            // Branch 0: Home
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const DailyDashboardScreen(),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        AppMotion.pageFadeTransitionBuilder(
                      child: child,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                    ),
                  ),
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'notifications',
                      pageBuilder: (BuildContext context, GoRouterState state) =>
                          CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const NotificationsScreen(),
                        transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child) =>
                            AppMotion.pageFadeTransitionBuilder(
                          child: child,
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Branch 1: Medicines
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/medicines',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const MedicineListScreen(),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        AppMotion.pageFadeTransitionBuilder(
                      child: child,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                    ),
                  ),
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'add',
                      pageBuilder: (BuildContext context, GoRouterState state) =>
                          CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const AddMedicineScreen(),
                        transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child) =>
                            AppMotion.pageFadeTransitionBuilder(
                          child: child,
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Branch 2: Calendar
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/calendar',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const CalendarScreen(),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        AppMotion.pageFadeTransitionBuilder(
                      child: child,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                    ),
                  ),
                ),
              ],
            ),
            // Branch 3: Profile Settings
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/profile-settings',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const ProfileSettingsScreen(),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        AppMotion.pageFadeTransitionBuilder(
                      child: child,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                    ),
                  ),
                ),
              ],
            ),
            // Branch 4: Menu & Its Sub-pages
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/menu',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const MenuScreen(),
                    transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) =>
                        AppMotion.pageFadeTransitionBuilder(
                      child: child,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                    ),
                  ),
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'achievements',
                      pageBuilder: (BuildContext context, GoRouterState state) =>
                          CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const AchievementsScreen(),
                        transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child) =>
                            AppMotion.pageFadeTransitionBuilder(
                          child: child,
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: 'security',
                      pageBuilder: (BuildContext context, GoRouterState state) =>
                          CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const SecurityScreen(),
                        transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child) =>
                            AppMotion.pageFadeTransitionBuilder(
                          child: child,
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                        ),
                      ),
                    ),
                    GoRoute(
                      path: 'policies',
                      pageBuilder: (BuildContext context, GoRouterState state) =>
                          CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const PoliciesScreen(),
                        transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child) =>
                            AppMotion.pageFadeTransitionBuilder(
                          child: child,
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                        ),
                      ),
                      routes: <RouteBase>[
                        GoRoute(
                          path: 'readme',
                          pageBuilder: (BuildContext context, GoRouterState state) =>
                              CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: const ReadmeScreen(),
                            transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) =>
                                AppMotion.pageFadeTransitionBuilder(
                              child: child,
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                            ),
                          ),
                        ),
                        GoRoute(
                          path: 'privacy',
                          pageBuilder: (BuildContext context, GoRouterState state) =>
                              CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: const PrivacyPolicyScreen(),
                            transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) =>
                                AppMotion.pageFadeTransitionBuilder(
                              child: child,
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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
