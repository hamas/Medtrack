// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/timeline_provider.dart';
import '../providers/checkoff_notifier.dart';
import '../../domain/entities/adherence_log.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(dailyTimelineProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Medtrack Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('EEEE, MMMM d').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: timelineAsync.when(
        data: (doses) => doses.isEmpty
            ? const Center(
                child: Text('All caught up! No doses scheduled for today.'),
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(dailyTimelineProvider.future),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: doses.length,
                  itemBuilder: (context, index) {
                    final dose = doses[index];
                    return _DoseCard(dose: dose);
                  },
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-medicine'),
        icon: const Icon(Icons.add),
        label: const Text('Add Medication'),
      ),
    );
  }
}

class _DoseCard extends ConsumerWidget {
  final dynamic
  dose; // Using dynamic here for agility, will type properly in production

  const _DoseCard({required this.dose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeStr = DateFormat('HH:mm').format(dose.scheduledTime);
    final medicine = dose.medicine;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          alignment: Alignment.center,
          child: Text(
            timeStr,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        title: Text(
          medicine.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${medicine.dosage} • ${medicine.deliveryMethod.name.toUpperCase()}',
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.restaurant,
                  size: 14,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  _getMealInstruction(medicine.mealContext),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Checkbox(
          value: false, // Local state will be handled by CheckoffNotifier
          onChanged: (value) async {
            if (value == true) {
              await ref
                  .read(checkoffNotifierProvider(medicine.id).notifier)
                  .checkOffMedicine(
                    scheduledTime: dose.scheduledTime,
                    status: AdherenceStatus.taken,
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Marked ${medicine.name} as taken')),
                );
              }
            }
          },
          shape: const CircleBorder(),
        ),
      ),
    );
  }

  String _getMealInstruction(dynamic context) {
    switch (context.toString().split('.').last) {
      case 'beforeMeal':
        return 'Before Breakfast';
      case 'withMeal':
        return 'With Lunch';
      case 'afterMeal':
        return 'After Dinner';
      default:
        return 'No meal requirement';
    }
  }
}
