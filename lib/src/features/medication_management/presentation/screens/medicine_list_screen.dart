import 'dart:ui';
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 140), // Extra bottom padding for FAB/Nav
            itemCount: medicines.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 16),
            itemBuilder: (BuildContext context, int index) {
              final Medicine medicine = medicines[index];
              return _MedicineCard(medicine: medicine);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white24),
        ),
        error: (Object err, StackTrace stack) =>
            Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90), // Offset from bottom nav
        child: FloatingActionButton(
          onPressed: () => context.push('/medicines/add'),
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          elevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: const Icon(Symbols.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Glassy Icon container
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Icon(
                Symbols.medication_rounded,
                size: 72,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Your medicine cabinet is empty.",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.8,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Add your first prescription to start your journey.",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 56),
            // Minimalist Glass Button
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.push('/medicines/add'),
                      splashColor: Colors.white10,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Symbols.add_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              splashColor: Colors.white.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    // Method Icon Container (Glassy Bento Tile)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Center(
                        child: Icon(
                          _getDeliveryIcon(medicine.deliveryMethod),
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 26,
                          weight: 600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    // Main Info
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
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            medicine.dosage,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Inventory Status (Smart Inventory)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '${medicine.remainingQuantity}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Left',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.25),
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              letterSpacing: 1.2,
                              height: 1,
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
      ),
    );
  }

  IconData _getDeliveryIcon(DeliveryMethod method) {
    switch (method) {
      case DeliveryMethod.water:
        return Symbols.water_drop_rounded;
      case DeliveryMethod.milk:
        return Symbols.glass_cup_rounded;
      case DeliveryMethod.mixed:
        return Symbols.science_rounded;
      case DeliveryMethod.injection:
        return Symbols.vaccines_rounded;
      case DeliveryMethod.drops:
        return Symbols.opacity_rounded;
      case DeliveryMethod.inhaler:
        return Symbols.air_rounded;
      case DeliveryMethod.other:
        return Symbols.medication_rounded;
    }
  }
}

