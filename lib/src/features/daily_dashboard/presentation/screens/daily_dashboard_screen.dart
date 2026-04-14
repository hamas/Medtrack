// Developed by Hamas — Medtrack Project [100% Dart Implementation]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../providers/daily_timeline_provider.dart';
import '../../domain/entities/dose.dart';

class DailyDashboardScreen extends ConsumerWidget {
  const DailyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(dailyTimelineProvider);

    return timelineAsync.when(
      data: (doses) => doses.isEmpty
          ? const Center(child: Text('No doses scheduled for today.'))
          : Stack(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: doses.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final dose = doses[index];
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
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _DashboardItem extends ConsumerWidget {
  final Dose dose;
  const _DashboardItem({required this.dose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final medicine = dose.medicine;
    final timeStr = DateFormat('hh:mm a').format(dose.scheduledTime);
    
    return Container(
      decoration: BoxDecoration(
        color: dose.isTaken 
          ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
          : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
        ),
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
              color: dose.isTaken ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSecondaryContainer,
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
          children: [
            Text('${medicine.dosage} • ${medicine.deliveryMethod.name.toUpperCase()}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: theme.colorScheme.primary),
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
          onChanged: dose.isTaken ? null : (value) {
            if (value == true) {
              ref.read(dailyTimelineProvider.notifier).checkOffDose(dose);
            }
          },
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  String _getMealLabel(dynamic context) {
    final name = context.toString().split('.').last;
    switch (name) {
      case 'beforeMeal': return 'Take Before Meal';
      case 'withMeal': return 'Take With Meal';
      case 'afterMeal': return 'Take After Meal';
      default: return 'No meal instructions';
    }
  }
}
