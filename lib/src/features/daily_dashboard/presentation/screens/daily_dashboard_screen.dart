import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../medication_management/domain/entities/medicine.dart';
import '../../domain/entities/dose.dart';
import '../providers/daily_timeline_provider.dart';

class DailyDashboardScreen extends ConsumerWidget {
  const DailyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Dose>> timelineAsync = ref.watch(
      dailyTimelineProvider,
    );

    return Column(
      children: <Widget>[
        const _GreetingHeader(),
        const _HorizontalDatePicker(),
        Expanded(
          child: timelineAsync.when(
            data: (List<Dose> doses) => doses.isEmpty
                ? const Center(child: Text('No doses scheduled for today.'))
                : Stack(
                    children: <Widget>[
                      ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: doses.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (BuildContext context, int index) {
                          final Dose dose = doses[index];
                          return _DashboardItem(dose: dose);
                        },
                      ),
                      Positioned(
                        bottom: 80, // Elevation for FAB alignment with nav bar
                        right: 24,
                        child: FloatingActionButton.extended(
                          onPressed: () => context.push('/add-medicine'),
                          icon: const Icon(Symbols.add_rounded),
                          label: const Text('Add Medication'),
                        ),
                      ),
                    ],
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object err, StackTrace stack) =>
                Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  String _getGreeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${_getGreeting()}, Hamas ❤️',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You have doses to take today.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalDatePicker extends StatelessWidget {
  const _HorizontalDatePicker();

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) {
          final DateTime date = startOfWeek.add(Duration(days: index));
          final bool isToday =
              date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;

          return _DateItem(date: date, isToday: isToday);
        },
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  const _DateItem({required this.date, required this.isToday});
  final DateTime date;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: isToday
            ? colorScheme.primary
            : colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: isToday
            ? null
            : Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            DateFormat('E').format(date).toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isToday ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardItem extends ConsumerWidget {
  const _DashboardItem({required this.dose});
  final Dose dose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final Medicine medicine = dose.medicine;
    final String timeStr = DateFormat('hh:mm a').format(dose.scheduledTime);

    return Container(
      decoration: BoxDecoration(
        color: dose.isTaken
            ? theme.colorScheme.surface.withValues(alpha: 0.05)
            : theme.colorScheme.surface.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Stack(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            title: Text(
              medicine.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                decoration: dose.isTaken ? TextDecoration.lineThrough : null,
                color: dose.isTaken
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                    : theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${medicine.dosage} • ${timeStr}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/notification_bell.png',
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getMealLabel(medicine.mealContext),
                      style: TextStyle(
                        color: theme.colorScheme.primary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: dose.isTaken
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Symbols.check_circle_rounded,
                      color: theme.colorScheme.primary,
                      fill: 1,
                    ),
                  )
                : Checkbox(
                    value: dose.isTaken,
                    onChanged: (bool? value) {
                      if (value == true) {
                        ref
                            .read(dailyTimelineProvider.notifier)
                            .checkOffDose(dose);
                      }
                    },
                    shape: const CircleBorder(),
                  ),
          ),
        ],
      ),
    );
  }

  String _getMealLabel(MealContext context) {
    switch (context) {
      case MealContext.beforeMeal:
        return 'Before Meal';
      case MealContext.withMeal:
        return 'With Meal';
      case MealContext.afterMeal:
        return 'After Meal';
      case MealContext.none:
        return 'Anytime';
    }
  }
}
