import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/alarm_service.dart';
import '../../../../core/widgets/shared_ui.dart';
import '../../../daily_dashboard/presentation/providers/daily_timeline_provider.dart';
import '../../../gamification/presentation/providers/adherence_history_provider.dart';
import '../../domain/entities/adherence_log.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/repositories/medication_repository.dart';
import '../providers/all_medicines_provider.dart';

class MedicineListScreen extends ConsumerWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Medicine>> medicinesAsync = ref.watch(
      allMedicinesProvider,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: medicinesAsync.when(
        data: (List<Medicine> medicines) {
          if (medicines.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
            itemCount: medicines.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              return _MedicineCard(
                medicine: medicines[index],
                onTap: () =>
                    _showMedicineActionSheet(context, ref, medicines[index]),
              );
            },
          );
        },
        loading: () => _buildEmptyState(context),
        error: (Object err, StackTrace stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: _buildFab(context),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.push('/medicines/add'),
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Symbols.add_rounded),
      label: const Text(
        'Add Medication',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Icon(
              Symbols.pill_rounded,
              size: 80,
              color: Colors.white.withValues(alpha: 0.1),
              weight: 300,
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Your cabinet is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Start your health journey by adding your first medication reminder.',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FloatingActionButton.extended(
            onPressed: () => context.push('/medicines/add'),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: const Icon(Symbols.add_rounded),
            label: const Text(
              'Add Medication',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _showMedicineActionSheet(
    BuildContext context,
    WidgetRef ref,
    Medicine medicine,
  ) {
    final bool isLowStock =
        medicine.remainingQuantity <= medicine.lowStockThreshold;

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext sheetCtx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Medication Header
              Row(
                children: <Widget>[
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Icon(
                        getDeliveryMethodIcon(medicine.deliveryMethod),
                        color: Colors.blueAccent,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          medicine.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${medicine.dosage} • ${_formatMealContext(medicine.mealContext)}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: medicine.isActive
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      medicine.isActive ? 'ACTIVE' : 'PAUSED',
                      style: TextStyle(
                        color: medicine.isActive
                            ? Colors.greenAccent
                            : Colors.amberAccent,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Stock Status Banner & Quick Refill
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isLowStock
                      ? Colors.redAccent.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isLowStock
                        ? Colors.redAccent.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              isLowStock
                                  ? Symbols.warning_amber_rounded
                                  : Symbols.inventory_2_rounded,
                              color: isLowStock
                                  ? Colors.redAccent
                                  : Colors.white60,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Cabinet Inventory',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${medicine.remainingQuantity} units left',
                          style: TextStyle(
                            color: isLowStock
                                ? Colors.redAccent
                                : Colors.tealAccent,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            onPressed: () =>
                                _refillMedicine(sheetCtx, ref, medicine, 10),
                            child: const Text(
                              '+10 Units',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            onPressed: () =>
                                _refillMedicine(sheetCtx, ref, medicine, 30),
                            child: const Text(
                              '+30 Units',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.08,
                            ),
                          ),
                          onPressed: () =>
                              _showCustomRefillDialog(sheetCtx, ref, medicine),
                          icon: const Icon(
                            Symbols.edit_rounded,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (medicine.isPrn) ...<Widget>[
                const SizedBox(height: 14),
                // PRN Rescue Dose Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.tealAccent.withValues(alpha: 0.2),
                      foregroundColor: Colors.tealAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () => _logPrnRescueDose(sheetCtx, ref, medicine),
                    icon: const Icon(Symbols.medication_rounded, size: 18),
                    label: Text(
                      'Log As-Needed Rescue Dose (Min ${medicine.minCooldownHours}h Cooldown)',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Edit Medication Action Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    context.push('/medicines/add', extra: medicine);
                  },
                  icon: const Icon(
                    Symbols.edit_note_rounded,
                    size: 18,
                    color: Colors.blueAccent,
                  ),
                  label: const Text(
                    'Edit Medication Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Pause / Resume and Delete Action Buttons
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () =>
                          _toggleMedicineActive(sheetCtx, ref, medicine),
                      icon: Icon(
                        medicine.isActive
                            ? Symbols.pause_rounded
                            : Symbols.play_arrow_rounded,
                        color: medicine.isActive
                            ? Colors.amberAccent
                            : Colors.greenAccent,
                        size: 18,
                      ),
                      label: Text(
                        medicine.isActive ? 'Pause Alarms' : 'Resume Alarms',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.15),
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () =>
                        _confirmDeleteMedicine(sheetCtx, ref, medicine),
                    icon: const Icon(
                      Symbols.delete_outline_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatMealContext(MealContext ctx) {
    switch (ctx) {
      case MealContext.beforeMeal:
        return 'Before meal';
      case MealContext.withMeal:
        return 'With meal';
      case MealContext.afterMeal:
        return 'After meal';
      case MealContext.none:
        return 'Anytime';
    }
  }

  static Future<void> _refillMedicine(
    BuildContext context,
    WidgetRef ref,
    Medicine medicine,
    int addCount,
  ) async {
    final Medicine updated = medicine.copyWith(
      remainingQuantity: medicine.remainingQuantity + addCount,
    );
    await ref.read(medicationRepositoryProvider).saveMedicine(updated);
    ref.invalidate(allMedicinesProvider);
    ref.invalidate(dailyTimelineProvider);
    ref.invalidate(adherenceHistoryProvider);

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Refilled ${medicine.name} by +$addCount (Total: ${updated.remainingQuantity})',
          ),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  static Future<void> _showCustomRefillDialog(
    BuildContext context,
    WidgetRef ref,
    Medicine medicine,
  ) async {
    final TextEditingController controller = TextEditingController(text: '30');
    await showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Refill ${medicine.name}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Units to add',
            labelStyle: const TextStyle(color: Colors.white60),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          FilledButton(
            onPressed: () {
              final int? val = int.tryParse(controller.text.trim());
              if (val != null && val > 0) {
                Navigator.pop(ctx);
                _refillMedicine(context, ref, medicine, val);
              }
            },
            child: const Text('Add Stock'),
          ),
        ],
      ),
    );
  }

  static Future<void> _toggleMedicineActive(
    BuildContext context,
    WidgetRef ref,
    Medicine medicine,
  ) async {
    final bool nextState = !medicine.isActive;
    final Medicine updated = medicine.copyWith(isActive: nextState);
    final MedicationRepository medRepo = ref.read(medicationRepositoryProvider);
    await medRepo.saveMedicine(updated);

    if (!nextState) {
      await AlarmService().cancelAlarm(medicine);
    } else {
      await AlarmService().scheduleNextAlarm(updated);
    }

    ref.invalidate(allMedicinesProvider);
    ref.invalidate(dailyTimelineProvider);
    ref.invalidate(adherenceHistoryProvider);

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            nextState
                ? '${medicine.name} resumed.'
                : '${medicine.name} paused. Reminders silenced.',
          ),
          backgroundColor: nextState ? Colors.green : Colors.amber[800],
        ),
      );
    }
  }

  static Future<void> _confirmDeleteMedicine(
    BuildContext context,
    WidgetRef ref,
    Medicine medicine,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(
          Symbols.delete_forever_rounded,
          color: Colors.redAccent,
          size: 36,
        ),
        title: const Text(
          'Delete Medication?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove "${medicine.name}" from your cabinet? All scheduled alarms will be cancelled.',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AlarmService().cancelAlarm(medicine);
      await ref.read(medicationRepositoryProvider).deleteMedicine(medicine.id);
      ref.invalidate(allMedicinesProvider);
      ref.invalidate(dailyTimelineProvider);

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${medicine.name} deleted from cabinet.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  static Future<void> _logPrnRescueDose(
    BuildContext context,
    WidgetRef ref,
    Medicine medicine,
  ) async {
    final MedicationRepository medRepo = ref.read(medicationRepositoryProvider);
    final List<AdherenceLog> pastLogs = await medRepo.getAdherenceLogs(
      medicine.id,
    );

    // Check cooldown
    DateTime? lastTaken;
    for (final AdherenceLog l in pastLogs) {
      if (l.status == AdherenceStatus.taken && l.takenTime != null) {
        if (lastTaken == null || l.takenTime!.isAfter(lastTaken)) {
          lastTaken = l.takenTime;
        }
      }
    }

    if (lastTaken != null) {
      final Duration diff = DateTime.now().difference(lastTaken);
      final int cooldownHours = medicine.minCooldownHours;
      if (diff.inHours < cooldownHours) {
        if (!context.mounted) return;
        final double hoursLeft = cooldownHours - (diff.inMinutes / 60.0);
        final bool? proceed = await showDialog<bool>(
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1B2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            icon: const Icon(
              Symbols.hourglass_top_rounded,
              color: Colors.amberAccent,
              size: 36,
            ),
            title: const Text(
              'PRN Cooldown Warning',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'The minimum recommended spacing for ${medicine.name} is $cooldownHours hours.\n\nYour last dose was ${diff.inHours}h ${diff.inMinutes % 60}m ago (~${hoursLeft.toStringAsFixed(1)}h remaining).\n\nTaking doses too close together increases toxicity risk.',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(
                  'Wait Cooldown',
                  style: TextStyle(color: Colors.white60),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber[800],
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Take Dose Anyway'),
              ),
            ],
          ),
        );
        if (proceed != true) return;
      }
    }

    // Deduct 1 unit and save log
    final int newQty = (medicine.remainingQuantity > 0)
        ? medicine.remainingQuantity - 1
        : 0;
    final Medicine updated = medicine.copyWith(remainingQuantity: newQty);
    await medRepo.saveMedicine(updated);

    final AdherenceLog log = AdherenceLog(
      id: const Uuid().v4(),
      medicineId: medicine.id,
      userId: medicine.userId,
      scheduledTime: DateTime.now(),
      takenTime: DateTime.now(),
      status: AdherenceStatus.taken,
      mealNotes: 'PRN Rescue Dose taken on-demand',
    );
    await medRepo.saveAdherenceLog(log);

    ref.invalidate(allMedicinesProvider);
    ref.invalidate(dailyTimelineProvider);
    ref.invalidate(adherenceHistoryProvider);

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PRN Rescue Dose of ${medicine.name} logged ($newQty units left).',
          ),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({required this.medicine, required this.onTap});

  final Medicine medicine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isLowStock =
        medicine.remainingQuantity <= medicine.lowStockThreshold;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isLowStock
              ? Colors.redAccent.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        getDeliveryMethodIcon(medicine.deliveryMethod),
                        color: Colors.blueAccent.withValues(alpha: 0.8),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          medicine.name,
                          style: TextStyle(
                            color: medicine.isActive
                                ? Colors.white
                                : Colors.white54,
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                            letterSpacing: -0.2,
                            decoration: medicine.isActive
                                ? null
                                : TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Text(
                              medicine.dosage,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Colors.white12,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              medicine.isPrn
                                  ? 'AS-NEEDED (PRN)'
                                  : medicine.intervalType.name.toUpperCase(),
                              style: TextStyle(
                                color: medicine.isPrn
                                    ? Colors.tealAccent
                                    : Colors.white24,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        if (medicine.durationDays != null &&
                            medicine.durationDays! > 0) ...<Widget>[
                          const SizedBox(height: 8),
                          _buildCourseProgressBar(medicine),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isLowStock
                          ? Colors.redAccent.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${medicine.remainingQuantity}',
                          style: TextStyle(
                            color: isLowStock ? Colors.redAccent : Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          isLowStock ? 'LOW' : 'LEFT',
                          style: TextStyle(
                            color: isLowStock
                                ? Colors.redAccent
                                : Colors.white12,
                            fontWeight: FontWeight.w900,
                            fontSize: 9,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseProgressBar(Medicine medicine) {
    final int totalDays = medicine.durationDays!;
    final int elapsedDays = DateTime.now()
        .difference(medicine.startDate)
        .inDays;
    final int currentDay = (elapsedDays + 1).clamp(1, totalDays);
    final double progress = (currentDay / totalDays).clamp(0.0, 1.0);
    final bool isFinished = elapsedDays >= totalDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation<Color>(
              isFinished ? Colors.greenAccent : Colors.tealAccent,
            ),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isFinished
              ? 'Course Complete ($totalDays days)'
              : 'Day $currentDay of $totalDays • ${totalDays - currentDay}d remaining',
          style: TextStyle(
            color: isFinished ? Colors.greenAccent : Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
