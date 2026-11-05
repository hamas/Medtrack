import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../medication_management/domain/entities/medicine.dart';
import '../../../medication_management/presentation/providers/all_medicines_provider.dart';

class LowStockBanner extends ConsumerWidget {
  const LowStockBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Medicine> lowStockMeds = ref.watch(lowStockMedicinesProvider);

    if (lowStockMeds.isEmpty) return const SizedBox.shrink();

    final Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: secondaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Symbols.inventory_2_rounded,
                color: secondaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Low Stock Alert',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '${lowStockMeds.length} medicine(s) running low',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lowStockMeds.length,
              itemBuilder: (BuildContext context, int index) {
                final Medicine med = lowStockMeds[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    side: BorderSide(
                      color: secondaryColor.withValues(alpha: 0.2),
                    ),
                    label: Text(
                      'Refill ${med.name}',
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                    onPressed: () {
                      final Medicine refilledMed = med.copyWith(
                        remainingQuantity: med.initialQuantity,
                      );
                      ref
                          .read(medicationRepositoryProvider)
                          .saveMedicine(refilledMed);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
