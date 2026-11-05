import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../domain/entities/medicine.dart';
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
              return _MedicineCard(medicine: medicines[index]);
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
    return Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/medicines/add'),
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(
              Symbols.add_rounded,
              color: Colors.white,
              size: 28,
              weight: 700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Account for top-bar offset to achieve true visual center
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
            "Your cabinet is empty",
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
            "Start your health journey by adding your first medication reminder.",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          // Offset for Bottom Nav and FAB to push content into visual center
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({required this.medicine});
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
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
                        _getDeliveryIcon(medicine.deliveryMethod),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                            letterSpacing: -0.2,
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
                              medicine.intervalType.name.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white24,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${medicine.remainingQuantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            height: 1.1,
                          ),
                        ),
                        const Text(
                          'LEFT',
                          style: TextStyle(
                            color: Colors.white12,
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

  IconData _getDeliveryIcon(DeliveryMethod method) {
    switch (method) {
      case DeliveryMethod.tablet:
        return Symbols.pill_rounded;
      case DeliveryMethod.capsule:
        return Symbols.vaccines_rounded;
      case DeliveryMethod.syrup:
        return Symbols.medication_liquid_rounded;
      case DeliveryMethod.injection:
        return Symbols.syringe_rounded;
      case DeliveryMethod.water:
        return Symbols.pill_rounded;
      case DeliveryMethod.milk:
        return Symbols.vaccines_rounded;
      case DeliveryMethod.mixed:
        return Symbols.science_rounded;
      case DeliveryMethod.drops:
        return Symbols.opacity_rounded;
      case DeliveryMethod.inhaler:
        return Symbols.air_rounded;
      case DeliveryMethod.other:
        return Symbols.medication_rounded;
    }
  }
}
