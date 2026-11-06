import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/motion_utils.dart';
import '../../features/daily_dashboard/presentation/screens/daily_dashboard_screen.dart';
import '../../features/navigation/presentation/screens/notifications_screen.dart';
import '../../features/medication_management/presentation/screens/medicine_list_screen.dart';
import '../../features/medication_management/presentation/screens/add_medicine_screen.dart';
import '../../features/medication_management/domain/entities/medicine.dart';
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

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

Page<void> _buildFadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) => AppMotion.pageFadeTransitionBuilder(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
        ),
  );
}

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder:
          (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) => MainScreen(navigationShell: navigationShell),
      branches: <StatefulShellBranch>[
        // Branch 0: Dashboard & Timeline
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  _buildFadePage(state, const DailyDashboardScreen()),
              routes: <RouteBase>[
                GoRoute(
                  path: 'notifications',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      _buildFadePage(state, const NotificationsScreen()),
                ),
              ],
            ),
          ],
        ),

        // Branch 1: Medication Cabinet
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/medicines',
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  _buildFadePage(state, const MedicineListScreen()),
              routes: <RouteBase>[
                GoRoute(
                  path: 'add',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      _buildFadePage(
                        state,
                        AddMedicineScreen(
                          initialMedicine: state.extra as Medicine?,
                        ),
                      ),
                ),
              ],
            ),
          ],
        ),

        // Branch 2: Clinical Adherence Calendar
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/calendar',
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  _buildFadePage(state, const CalendarScreen()),
            ),
          ],
        ),

        // Branch 3: Patient Profile
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  _buildFadePage(state, const ProfileScreen()),
              routes: <RouteBase>[
                GoRoute(
                  path: 'edit',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      _buildFadePage(state, const ProfileSettingsScreen()),
                ),
              ],
            ),
          ],
        ),

        // Branch 4: Menu, Settings & Policies
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/menu',
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  _buildFadePage(state, const MenuScreen()),
              routes: <RouteBase>[
                GoRoute(
                  path: 'security',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      _buildFadePage(state, const SecurityScreen()),
                ),
                GoRoute(
                  path: 'achievements',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      _buildFadePage(state, const AchievementsScreen()),
                ),
                GoRoute(
                  path: 'policies',
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      _buildFadePage(state, const PoliciesScreen()),
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'readme',
                      pageBuilder:
                          (BuildContext context, GoRouterState state) =>
                              _buildFadePage(state, const ReadmeScreen()),
                    ),
                    GoRoute(
                      path: 'privacy',
                      pageBuilder:
                          (BuildContext context, GoRouterState state) =>
                              _buildFadePage(
                                state,
                                const PrivacyPolicyScreen(),
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
);
