import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

    return timelineAsync.when(
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
                  bottom: 24,
                  right: 24,
                  child: FloatingActionButton.extended(
                    onPressed: () => context.push('/add-medicine'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Medication'),
                  ),
                ),
              ],
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object err, StackTrace stack) =>
          Center(child: Text('Error: $err')),
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
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: dose.isTaken
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.secondaryContainer,
          child: Text(
            timeStr.split(' ')[0],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: dose.isTaken
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        title: Text(
          medicine.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            decoration: dose.isTaken ? TextDecoration.lineThrough : null,
            color: dose.isTaken ? theme.disabledColor : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${medicine.dosage} • ${medicine.deliveryMethod.name.toUpperCase()}',
            ),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  _getMealLabel(medicine.mealContext),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Checkbox(
          value: dose.isTaken,
          onChanged: dose.isTaken
              ? null
              : (bool? value) {
                  if (value == true) {
                    ref.read(dailyTimelineProvider.notifier).checkOffDose(dose);
                  }
                },
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  String _getMealLabel(MealContext context) {
    switch (context) {
      case MealContext.beforeMeal:
        return 'Take Before Meal';
      case MealContext.withMeal:
        return 'Take With Meal';
      case MealContext.afterMeal:
        return 'Take After Meal';
      case MealContext.none:
        return 'No meal instructions';
    }
  }
}
