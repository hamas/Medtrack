import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/medicine.dart';
import '../providers/all_medicines_provider.dart';

class MedicineListScreen extends ConsumerWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Medicine>> medicinesAsync = ref.watch(
      allMedicinesProvider,
    );
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: medicinesAsync.when(
        data: (List<Medicine> medicines) {
          if (medicines.isEmpty) {
            return _buildEmptyState(context, theme);
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: medicines.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final Medicine medicine = medicines[index];
              return _MedicineCard(medicine: medicine);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object err, StackTrace stack) =>
            Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-medicine'),
        icon: const Icon(Icons.add),
        label: const Text('New Medication'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.medication_liquid_outlined,
              size: 80,
              color: theme.colorScheme.primary.withAlpha(100),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Library is Empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Add your prescriptions here to track your daily doses and health journey.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/add-medicine'),
              icon: const Icon(Icons.add),
              label: const Text('Add First Medicine'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({required this.medicine});
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha(220),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(50)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to details in future expansion
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        _getDeliveryIcon(medicine.deliveryMethod),
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            medicine.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            medicine.dosage,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _buildChip(
                      context,
                      _getIntervalLabel(medicine.intervalType),
                      Icons.repeat,
                      theme.colorScheme.secondaryContainer,
                      theme.colorScheme.onSecondaryContainer,
                    ),
                    _buildChip(
                      context,
                      _getMealLabel(medicine.mealContext),
                      Icons.restaurant_menu,
                      theme.colorScheme.tertiaryContainer,
                      theme.colorScheme.onTertiaryContainer,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    String label,
    IconData icon,
    Color bgColor,
    Color fgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: fgColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDeliveryIcon(DeliveryMethod method) {
    switch (method) {
      case DeliveryMethod.water:
        return Icons.water_drop;
      case DeliveryMethod.milk:
        return Icons.egg;
      case DeliveryMethod.injection:
        return Icons.vaccines;
      case DeliveryMethod.drops:
        return Icons.opacity;
      case DeliveryMethod.inhaler:
        return Icons.air;
      default:
        return Icons.medication;
    }
  }

  String _getIntervalLabel(IntervalType type) {
    switch (type) {
      case IntervalType.daily:
        return 'Daily';
      case IntervalType.weekly:
        return 'Weekly';
      case IntervalType.monthly:
        return 'Monthly';
      case IntervalType.custom:
        return 'Custom Schedule';
    }
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
        return 'Flexible Timing';
    }
  }
}
