import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:medtrack/src/core/widgets/ambient_background.dart';
import '../../../daily_dashboard/presentation/screens/daily_dashboard_screen.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../../../history_tracking/presentation/screens/calendar_screen.dart';
import '../../../medication_management/presentation/screens/medicine_list_screen.dart';
import '../providers/navigation_provider.dart';
import 'menu_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(navigationProvider);
    final User? user = FirebaseAuth.instance.currentUser;
    final AsyncValue<UserProfile> userProfileAsync = ref.watch(
      userProfileStateProvider,
    );

    return Stack(
      children: <Widget>[
        const Positioned.fill(
          child: RepaintBoundary(child: AmbientBackground()),
        ),
        Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            titleSpacing: 16,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            toolbarHeight: 40,
            title: const Text('Medtrack'),
            actions: <Widget>[
              userProfileAsync.when(
                data: (UserProfile profile) => Row(
                  children: <Widget>[
                    if (profile.currentStreak > 0) ...<Widget>[
                      const Icon(
                        Symbols.local_fire_department_rounded,
                        color: Colors.orange,
                        size: 20,
                        fill: 1,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${profile.currentStreak}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (profile.earnedBadges.isNotEmpty) ...<Widget>[
                      const Icon(
                        Symbols.rewarded_ads_rounded,
                        color: Colors.amber,
                        size: 20,
                        fill: 1,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${profile.earnedBadges.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ],
                ),
                loading: () => const SizedBox.shrink(),
                error: (Object err, StackTrace stack) =>
                    const SizedBox.shrink(),
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icons/notification_bell.png',
                  width: 22,
                  height: 22,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: IndexedStack(
            index: currentIndex,
            children: const <Widget>[
              DailyDashboardScreen(),
              MedicineListScreen(),
              CalendarScreen(),
              MenuScreen(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: currentIndex,
            indicatorColor: Colors.transparent,
            onDestinationSelected: (int index) =>
                ref.read(navigationProvider.notifier).setIndex(index),
            destinations: <NavigationDestination>[
              const NavigationDestination(
                icon: Icon(Symbols.home_rounded, fill: 0),
                selectedIcon: Icon(Symbols.home_rounded, fill: 1),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Symbols.pill_rounded, fill: 0),
                selectedIcon: Icon(Symbols.pill_rounded, fill: 1),
                label: 'Medicines',
              ),
              const NavigationDestination(
                icon: Icon(Symbols.calendar_today_rounded, fill: 0),
                selectedIcon: Icon(Symbols.calendar_today_rounded, fill: 1),
                label: 'Calendar',
              ),
              NavigationDestination(
                icon: _buildNavProfileIcon(
                  user,
                  userProfileAsync,
                  isSelected: false,
                ),
                selectedIcon: _buildNavProfileIcon(
                  user,
                  userProfileAsync,
                  isSelected: true,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavProfileIcon(
    User? user,
    AsyncValue<UserProfile> profileAsync, {
    required bool isSelected,
  }) {
    return profileAsync.when(
      data: (UserProfile profile) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white24,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? <BoxShadow>[
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: ClipOval(
              child: user?.photoURL != null
                  ? Image.network(user!.photoURL!, fit: BoxFit.cover)
                  : Image.asset(
                      'assets/images/default_avatar.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          if (profile.equippedBadgeId != null)
            Positioned(
              right: -6,
              bottom: -6,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F0F1A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getBadgeIcon(profile.equippedBadgeId!),
                  size: 12,
                  color: _getBadgeColor(profile.equippedBadgeId!),
                ),
              ),
            ),
        ],
      ),
      loading: () => Icon(Symbols.person_rounded, fill: isSelected ? 1 : 0),
      error: (Object _, StackTrace st) =>
          Icon(Symbols.person_rounded, fill: isSelected ? 1 : 0),
    );
  }

  IconData _getBadgeIcon(String id) {
    if (id == 'day1') {
      return Symbols.star_rounded;
    }
    if (id == 'streak7' || id == '7_streak') {
      return Symbols.workspace_premium_rounded;
    }
    if (id == 'streak14' || id == '14_streak') {
      return Symbols.military_tech_rounded;
    }
    if (id == 'streak30' || id == '30_streak') {
      return Symbols.diamond_rounded;
    }
    if (id == 'day90') {
      return Symbols.emoji_events_rounded;
    }
    return Symbols.workspace_premium_rounded;
  }

  Color _getBadgeColor(String id) {
    if (id == 'day1') {
      return Colors.orangeAccent;
    }
    if (id == 'streak7' || id == '7_streak') {
      return Colors.cyanAccent;
    }
    if (id == 'streak14' || id == '14_streak') {
      return Colors.pinkAccent;
    }
    if (id == 'streak30' || id == '30_streak') {
      return Colors.blueAccent;
    }
    if (id == 'day90') {
      return Colors.purpleAccent;
    }
    return Colors.amber;
  }
}
