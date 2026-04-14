import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../daily_dashboard/presentation/screens/daily_dashboard_screen.dart';
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

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Medtrack'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : null,
            child: user?.photoURL == null
                ? const Icon(Icons.account_circle)
                : null,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_sharp),
            onPressed: () {
              // Notification center logic
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Background Layer
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.6),
                  radius: 1.5,
                  colors: <Color>[
                    Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withAlpha(150),
                    Theme.of(context).colorScheme.surface,
                  ],
                  stops: const <double>[0.0, 1.0],
                ),
              ),
            ),
          ),
          // Content Layer
          SafeArea(
            child: IndexedStack(
              index: currentIndex,
              children: const <Widget>[
                DailyDashboardScreen(),
                MedicineListScreen(),
                CalendarScreen(),
                MenuScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) =>
            ref.read(navigationProvider.notifier).setIndex(index),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_liquid_outlined),
            selectedIcon: Icon(Icons.medication_liquid),
            label: 'Medicines',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_open_outlined),
            selectedIcon: Icon(Icons.menu_open),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
