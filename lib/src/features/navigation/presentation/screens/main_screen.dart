import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:medtrack/src/core/widgets/ambient_background.dart';
import 'package:medtrack/src/features/history_tracking/presentation/providers/calendar_month_provider.dart';
import '../../../authentication/presentation/widgets/biometric_gate.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../../../medication_management/presentation/providers/medicine_save_provider.dart';
import '../providers/settings_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final AsyncValue<UserProfile> userProfileAsync = ref.watch(
      userProfileStateProvider,
    );

    final int currentIndex = widget.navigationShell.currentIndex;
    final String currentPath = GoRouterState.of(context).uri.path;

    final List<String> mainRootPaths = <String>[
      '/',
      '/medicines',
      '/calendar',
      '/profile',
    ];
    final bool isMainRoot = mainRootPaths.contains(currentPath);
    final DateTime calendarMonth = ref.watch(calendarMonthProvider);

    final ({
      String title,
      bool showSettingsGear,
      bool showBellIcon,
      bool showEditPen,
    })
    config = _resolveAppBarConfig(currentPath, calendarMonth);

    final bool showBackButton = !isMainRoot;
    final String title = config.title;
    final bool showSettingsGear = config.showSettingsGear;
    final bool showBellIcon = config.showBellIcon;
    final bool showEditPen = config.showEditPen;

    final int navBarIndex = currentIndex <= 3 ? currentIndex : 0;
    final bool hideHighlight = currentIndex > 3;

    return PopScope(
      canPop: currentIndex == 0 && !context.canPop(),
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        _handleBack();
      },
      child: BiometricGate(
        child: Stack(
          children: <Widget>[
            const Positioned.fill(
              child: RepaintBoundary(child: AmbientBackground()),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
                child: Container(color: Colors.black.withValues(alpha: 0.8)),
              ),
            ),
            Scaffold(
              extendBody: true,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: true,
                title: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    fontSize: 20,
                  ),
                ),
                leadingWidth: 72,
                leading: Center(
                  child: (currentPath == '/profile/edit' || showBackButton)
                      ? _buildCircularIconButton(
                          icon: Symbols.arrow_back_rounded,
                          onPressed: _handleBack,
                          hasBackground: true,
                        )
                      : _buildCircularIconButton(
                          icon: Symbols.menu_rounded,
                          onPressed: () => widget.navigationShell.goBranch(4),
                          hasBackground: true,
                        ),
                ),
                actions: <Widget>[
                  if (currentPath == '/calendar') ...<Widget>[
                    _buildCircularIconButton(
                      icon: Symbols.chevron_left_rounded,
                      onPressed: () => ref
                          .read(calendarMonthProvider.notifier)
                          .previousMonth(),
                      hasBackground: true,
                    ),
                    const SizedBox(width: 8),
                    _buildCircularIconButton(
                      icon: Symbols.chevron_right_rounded,
                      onPressed: () =>
                          ref.read(calendarMonthProvider.notifier).nextMonth(),
                      hasBackground: true,
                    ),
                  ] else if (showEditPen)
                    _buildCircularIconButton(
                      icon: Symbols.edit_rounded,
                      onPressed: () => context.push('/profile/edit'),
                      hasBackground: true,
                    )
                  else if (currentPath == '/medicines/add')
                    _buildCircularIconButton(
                      icon: Symbols.check_rounded,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        ref
                            .read(medicineSaveTriggerProvider.notifier)
                            .trigger();
                      },
                      hasBackground: true,
                    )
                  else if (showSettingsGear)
                    _buildCircularIconButton(
                      icon: Symbols.settings_rounded,
                      onPressed: () => context.push('/menu/security'),
                      hasBackground: true,
                    )
                  else if (currentPath == '/profile/edit')
                    _buildCircularIconButton(
                      icon: Symbols.check_rounded,
                      onPressed: () => ref
                          .read(profileSaveTriggerProvider.notifier)
                          .trigger(),
                      hasBackground: true,
                    )
                  else if (showBellIcon)
                    Badge.count(
                      count: ref.watch(notificationCountProvider),
                      isLabelVisible: ref.watch(notificationCountProvider) > 0,
                      child: _buildCircularIconButton(
                        customIcon: Image.asset(
                          'assets/icons/notification_bell.png',
                          width: 18,
                          height: 18,
                        ),
                        onPressed: () => context.push('/notifications'),
                        hasBackground: false,
                      ),
                    ),
                  const SizedBox(width: 16),
                ],
              ),
              body: widget.navigationShell,
              bottomNavigationBar: NavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                selectedIndex: navBarIndex,
                indicatorColor: Colors.transparent,
                onDestinationSelected: (int index) {
                  widget.navigationShell.goBranch(index);
                },
                destinations: <NavigationDestination>[
                  NavigationDestination(
                    icon: const Icon(Symbols.home_rounded, fill: 0, size: 20),
                    selectedIcon: Icon(
                      Symbols.home_rounded,
                      fill: hideHighlight ? 0 : 1,
                      size: 20,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: const Icon(Symbols.pill_rounded, fill: 0, size: 20),
                    selectedIcon: Icon(
                      Symbols.pill_rounded,
                      fill: (hideHighlight || navBarIndex != 1) ? 0 : 1,
                      size: 20,
                    ),
                    label: 'Medicines',
                  ),
                  NavigationDestination(
                    icon: const Icon(
                      Symbols.calendar_today_rounded,
                      fill: 0,
                      size: 20,
                    ),
                    selectedIcon: Icon(
                      Symbols.calendar_today_rounded,
                      fill: (hideHighlight || navBarIndex != 2) ? 0 : 1,
                      size: 20,
                    ),
                    label: 'Calendar',
                  ),
                  NavigationDestination(
                    icon: _buildProfileAvatar(
                      user,
                      userProfileAsync,
                      size: 20,
                      isSelected: false,
                    ),
                    selectedIcon: _buildProfileAvatar(
                      user,
                      userProfileAsync,
                      size: 20,
                      isSelected: !hideHighlight && navBarIndex == 3,
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ({String title, bool showSettingsGear, bool showBellIcon, bool showEditPen})
  _resolveAppBarConfig(String currentPath, DateTime calendarMonth) {
    return switch (currentPath) {
      '/medicines/add' => (
        title: 'Add Medicine',
        showSettingsGear: false,
        showBellIcon: false,
        showEditPen: false,
      ),
      '/notifications' => (
        title: 'Notifications',
        showSettingsGear: true,
        showBellIcon: false,
        showEditPen: false,
      ),
      '/menu' => (
        title: 'Main Menu',
        showSettingsGear: false,
        showBellIcon: true,
        showEditPen: false,
      ),
      '/profile' => (
        title: 'Your Profile',
        showSettingsGear: false,
        showBellIcon: false,
        showEditPen: true,
      ),
      '/profile/edit' => (
        title: 'Edit Profile',
        showSettingsGear: false,
        showBellIcon: false,
        showEditPen: false,
      ),
      '/menu/achievements' || '/achievements' => (
        title: 'Achievements',
        showSettingsGear: false,
        showBellIcon: false,
        showEditPen: false,
      ),
      '/menu/security' || '/security' => (
        title: 'Security',
        showSettingsGear: false,
        showBellIcon: false,
        showEditPen: false,
      ),
      '/medicines' => (
        title: 'Medicines',
        showSettingsGear: false,
        showBellIcon: true,
        showEditPen: false,
      ),
      '/calendar' => (
        title: DateFormat('MMMM yyyy').format(calendarMonth),
        showSettingsGear: false,
        showBellIcon: false,
        showEditPen: false,
      ),
      _ when currentPath.endsWith('readme') => (
        title: 'About Medtrack',
        showSettingsGear: false,
        showBellIcon: false,
        showEditPen: false,
      ),
      _ when currentPath.endsWith('privacy') => (
        title: 'Privacy Policy',
        showSettingsGear: false,
        showBellIcon: false,
        showEditPen: false,
      ),
      _ when currentPath.contains('/policies') => (
        title: 'Policies & Info',
        showSettingsGear: false,
        showBellIcon: false,
        showEditPen: false,
      ),
      _ => (
        title: 'Medtrack',
        showSettingsGear: false,
        showBellIcon: true,
        showEditPen: false,
      ),
    };
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else if (widget.navigationShell.currentIndex != 0) {
      widget.navigationShell.goBranch(0);
    }
  }

  Widget _buildCircularIconButton({
    IconData? icon,
    Widget? customIcon,
    required VoidCallback onPressed,
    double fill = 0,
    bool hasBackground = true,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: hasBackground
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon:
            customIcon ?? Icon(icon, size: 20, fill: fill, color: Colors.white),
      ),
    );
  }

  Widget _buildProfileAvatar(
    User? user,
    AsyncValue<UserProfile> profileAsync, {
    double size = 32,
    bool isSelected = false,
  }) {
    return profileAsync.when(
      data: (UserProfile profile) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white24,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: ClipOval(
          child: (user?.photoURL != null && user!.photoURL!.isNotEmpty)
              ? Image.network(
                  user.photoURL!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) => Image.asset(
                        'assets/images/default_avatar.png',
                        fit: BoxFit.cover,
                      ),
                )
              : Image.asset(
                  'assets/images/default_avatar.png',
                  fit: BoxFit.cover,
                ),
        ),
      ),
      loading: () => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
        ),
        child: Icon(Symbols.person_rounded, size: size * 0.8),
      ),
      error: (Object error, StackTrace stackTrace) => Image.asset(
        'assets/images/default_avatar.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
