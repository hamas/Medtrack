import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/motion_utils.dart';
import '../../features/authentication/presentation/widgets/biometric_gate.dart';
import '../../features/daily_dashboard/presentation/screens/daily_dashboard_screen.dart';
import '../../features/navigation/presentation/screens/notifications_screen.dart';
import '../../features/medication_management/presentation/screens/medicine_list_screen.dart';
import '../../features/medication_management/presentation/screens/add_medicine_screen.dart';
import '../../features/history_tracking/presentation/screens/calendar_screen.dart';
import '../../features/navigation/presentation/screens/profile_screen.dart';
import '../../features/navigation/presentation/screens/profile_settings_screen.dart';
import '../../features/navigation/presentation/screens/menu_screen.dart';
import '../../features/navigation/presentation/screens/security_screen.dart';
import '../../features/gamification/presentation/screens/achievements_screen.dart';
import '../../features/navigation/presentation/screens/policies_screen.dart';
import '../../features/navigation/presentation/screens/readme_screen.dart';
import '../../features/navigation/presentation/screens/privacy_policy_screen.dart';
import '../../features/navigation/presentation/screens/main_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) =>
          BiometricGate(child: child),
      routes: <RouteBase>[
        StatefulShellRoute.indexedStack(
          builder: (BuildContext context, GoRouterState state,
              StatefulNavigationShell navigationShell) {
            return MainScreen(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
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
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: '/profile',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const ProfileScreen(),
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
                      path: 'edit',
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
              ],
            ),
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
