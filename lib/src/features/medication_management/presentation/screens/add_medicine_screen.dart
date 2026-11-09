import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../../../daily_dashboard/presentation/providers/daily_timeline_provider.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/services/drug_interaction_service.dart';
import '../providers/all_medicines_provider.dart';
import '../../../medication_management/presentation/providers/medicine_save_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key, this.initialMedicine});

  final Medicine? initialMedicine;

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _supplyController = TextEditingController(
    text: '30',
  );
  final TextEditingController _lowStockController = TextEditingController(
    text: '5',
  );
  final TextEditingController _courseDaysController = TextEditingController(
    text: '7',
  );
  final TextEditingController _cooldownController = TextEditingController(
    text: '4',
  );

  // Scheduling & Clinical State
  DateTime _startDate = DateTime.now();
  String _frequency = 'Daily';
  String _selectedType = 'Tablet';
  MealContext _mealContext = MealContext.none;
  bool _isFixedCourse = false;
  bool _isPrn = false;

  final List<String> _frequencies = <String>[
    'Daily',
    'Once a week',
    'Twice a week',
    'Every 2 weeks',
    'Once a month',
  ];

  final List<TimeOfDay> _times = <TimeOfDay>[
    const TimeOfDay(hour: 08, minute: 00),
  ];

  @override
  void initState() {
    super.initState();
    final Medicine? initMed = widget.initialMedicine;
    if (initMed != null) {
      _nameController.text = initMed.name;
      _dosageController.text = initMed.dosage;
      _supplyController.text = initMed.remainingQuantity.toString();
      _lowStockController.text = initMed.lowStockThreshold.toString();
      _startDate = initMed.startDate;
      _mealContext = initMed.mealContext;
      _isFixedCourse = initMed.durationDays != null;
      if (initMed.durationDays != null) {
        _courseDaysController.text = initMed.durationDays.toString();
      }
      _isPrn = initMed.isPrn;
      _cooldownController.text = initMed.minCooldownHours.toString();

      switch (initMed.deliveryMethod) {
        case DeliveryMethod.tablet:
          _selectedType = 'Tablet';
          break;
        case DeliveryMethod.capsule:
          _selectedType = 'Capsule';
          break;
        case DeliveryMethod.injection:
          _selectedType = 'Syringe';
          break;
        case DeliveryMethod.syrup:
          _selectedType = 'Syrup';
          break;
        default:
          _selectedType = 'Tablet';
          break;
      }

      switch (initMed.intervalType) {
        case IntervalType.daily:
          _frequency = 'Daily';
          break;
        case IntervalType.weekly:
          _frequency = initMed.intervalCount == 2
              ? 'Every 2 weeks'
              : 'Once a week';
          break;
        case IntervalType.monthly:
          _frequency = 'Once a month';
          break;
        case IntervalType.custom:
          _frequency = 'Twice a week';
          break;
      }

      if (initMed.scheduleTimes.isNotEmpty) {
        _times.clear();
        for (final String t in initMed.scheduleTimes) {
          final List<String> parts = t.split(':');
          if (parts.length >= 2) {
            final int? h = int.tryParse(parts[0]);
            final int? m = int.tryParse(parts[1]);
            if (h != null && m != null) {
              _times.add(TimeOfDay(hour: h, minute: m));
            }
          }
        }
        if (_times.isEmpty) {
          _times.add(const TimeOfDay(hour: 8, minute: 0));
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _supplyController.dispose();
    _lowStockController.dispose();
    _courseDaysController.dispose();
    _cooldownController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime earliestDate = _startDate.isBefore(DateTime.now())
        ? _startDate.subtract(const Duration(days: 30))
        : DateTime.now().subtract(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: earliestDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectTime(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _times[index],
    );
    if (picked != null) {
      setState(() => _times[index] = picked);
    }
  }

  void _addTime() {
    if (_times.length < 6) {
      setState(() {
        _times.add(const TimeOfDay(hour: 12, minute: 0));
      });
    }
  }

  void _removeTime(int index) {
    if (_times.length > 1) {
      setState(() {
        _times.removeAt(index);
      });
    }
  }

  Future<void> _save() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a medicine name'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final String medName = _nameController.text.trim();

    // Map selected type to DeliveryMethod enum
    DeliveryMethod deliveryMethod = DeliveryMethod.other;
    switch (_selectedType) {
      case 'Tablet':
        deliveryMethod = DeliveryMethod.tablet;
        break;
      case 'Capsule':
        deliveryMethod = DeliveryMethod.capsule;
        break;
      case 'Syringe':
        deliveryMethod = DeliveryMethod.injection;
        break;
      case 'Syrup':
        deliveryMethod = DeliveryMethod.syrup;
        break;
    }

    // Clinical Safety Check 1: Cross-reference against saved user allergies
    final UserProfile? userProfile = ref.read(userProfileStateProvider).value;
    if (userProfile != null && userProfile.allergies.isNotEmpty) {
      final String lowerName = medName.toLowerCase();
      final List<String> matchingAllergies = userProfile.allergies
          .where(
            (String a) =>
                a.trim().isNotEmpty &&
                (lowerName.contains(a.trim().toLowerCase()) ||
                    a.trim().toLowerCase().contains(lowerName)),
          )
          .toList();

      if (matchingAllergies.isNotEmpty) {
        final bool proceed = await _showAllergyWarningDialog(
          medName,
          matchingAllergies,
        );
        if (!proceed) return;
      }
    }

    // Clinical Safety Check 2: Drug-to-Drug and Food/Milk Interactions
    final List<Medicine> cabinetMedicines =
        ref.read(allMedicinesProvider).value ?? <Medicine>[];
    final List<DrugInteraction> interactions =
        DrugInteractionService.checkInteractions(
          newDrugName: medName,
          cabinetDrugs: cabinetMedicines,
          deliveryMethod: deliveryMethod,
        );

    if (interactions.isNotEmpty) {
      final bool proceed = await _showInteractionWarningDialog(interactions);
      if (!proceed) return;
    }

    try {
      final String id = widget.initialMedicine?.id ?? const Uuid().v4();
      final User? user = Firebase.apps.isNotEmpty
          ? FirebaseAuth.instance.currentUser
          : null;
      final String userId =
          widget.initialMedicine?.userId ?? (user?.uid ?? 'guest_user');

      // Map Frequency string to entity types
      IntervalType intervalType = IntervalType.daily;
      int intervalCount = 1;

      switch (_frequency) {
        case 'Daily':
          intervalType = IntervalType.daily;
          break;
        case 'Once a week':
          intervalType = IntervalType.weekly;
          break;
        case 'Twice a week':
          intervalType = IntervalType.custom;
          intervalCount = 3;
          break;
        case 'Every 2 weeks':
          intervalType = IntervalType.weekly;
          intervalCount = 2;
          break;
        case 'Once a month':
          intervalType = IntervalType.monthly;
          break;
      }

      final int initialQuantity = widget.initialMedicine != null
          ? widget.initialMedicine!.initialQuantity
          : (int.tryParse(_supplyController.text.trim()) ?? 30);
      final int remainingQuantity =
          int.tryParse(_supplyController.text.trim()) ?? initialQuantity;
      final int lowStockThreshold =
          int.tryParse(_lowStockController.text.trim()) ?? 5;
      final int? durationDays = _isFixedCourse
          ? (int.tryParse(_courseDaysController.text.trim()) ?? 7)
          : null;
      final DateTime? endDate = durationDays != null
          ? _startDate.add(Duration(days: durationDays))
          : null;
      final int minCooldown =
          int.tryParse(_cooldownController.text.trim()) ?? 4;

      final Medicine medicine = Medicine(
        id: id,
        userId: userId,
        name: medName,
        dosage: _dosageController.text.trim().isEmpty
            ? '1 unit'
            : _dosageController.text.trim(),
        intervalType: intervalType,
        intervalCount: intervalCount,
        scheduleTimes: _times.map((TimeOfDay t) {
          final String h = t.hour.toString().padLeft(2, '0');
          final String m = t.minute.toString().padLeft(2, '0');
          return '$h:$m';
        }).toList(),
        mealContext: _mealContext,
        deliveryMethod: deliveryMethod,
        startDate: _startDate,
        endDate: endDate,
        durationDays: durationDays,
        initialQuantity: initialQuantity,
        remainingQuantity: remainingQuantity,
        lowStockThreshold: lowStockThreshold,
        isActive: widget.initialMedicine?.isActive ?? true,
        isPrn: _isPrn,
        minCooldownHours: minCooldown,
        createdAt: widget.initialMedicine?.createdAt ?? DateTime.now(),
      );

      await ref.read(medicationRepositoryProvider).saveMedicine(medicine);

      ref.invalidate(dailyTimelineProvider);
      ref.invalidate(allMedicinesProvider);

      // Reset the trigger so it doesn't fire again if the screen is reused or state persists
      ref.read(medicineSaveTriggerProvider.notifier).reset();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.initialMedicine != null
                  ? 'Medication updated successfully'
                  : 'Medicine saved successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<bool> _showInteractionWarningDialog(
    List<DrugInteraction> interactions,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1B2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            icon: const Icon(
              Symbols.health_and_safety_rounded,
              color: Colors.redAccent,
              size: 40,
            ),
            title: const Text(
              'Clinical Interaction Guardrail',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: interactions.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(color: Colors.white12, height: 20),
                itemBuilder: (BuildContext context, int index) {
                  final DrugInteraction item = interactions[index];
                  final bool isSevere = item.severity.toLowerCase() == 'severe';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isSevere
                                  ? Colors.redAccent.withValues(alpha: 0.2)
                                  : Colors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${item.severity.toUpperCase()} RISK',
                              style: TextStyle(
                                color: isSevere
                                    ? Colors.redAccent
                                    : Colors.amber,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Recommendation: ${item.recommendation}',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(
                  'Review & Adjust',
                  style: TextStyle(color: Colors.white60),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Doctor Approved — Save'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _showAllergyWarningDialog(
    String medName,
    List<String> allergies,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1B2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            icon: const Icon(
              Symbols.warning_amber_rounded,
              color: Colors.amberAccent,
              size: 40,
            ),
            title: const Text(
              'Clinical Allergy Warning',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            content: Text(
              'You have registered an allergy to "${allergies.join(', ')}", which may conflict with "$medName".\n\nPlease confirm with your physician or pharmacist before administering this medication.',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(
                  'Cancel & Review',
                  style: TextStyle(color: Colors.white60),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Proceed Anyway'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showExpressiveBottomSheet({
    required String title,
    required Widget content,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Symbols.close_rounded,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            content,
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showFrequencyPicker() {
    _showExpressiveBottomSheet(
      title: 'Select Frequency',
      content: Builder(
        builder: (BuildContext sheetContext) {
          return ListView(
            shrinkWrap: true,
            children: _frequencies.map((String f) {
              final bool isSelected = _frequency == f;
              return ListTile(
                onTap: () {
                  setState(() => _frequency = f);
                  Navigator.pop(sheetContext);
                },
                leading: Icon(
                  isSelected
                      ? Symbols.radio_button_checked_rounded
                      : Symbols.radio_button_unchecked_rounded,
                  color: isSelected ? Colors.blueAccent : Colors.white24,
                ),
                title: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(medicineSaveTriggerProvider, (int? previous, int next) {
      debugPrint('Save trigger received: $next');
      if (next > 0) _save();
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTypePicker(),
                const SizedBox(height: 24),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildInputField(
                        controller: _nameController,
                        label: 'NAME',
                        hint: 'e.g. Paracetamol',
                        icon: Symbols.medication_rounded,
                      ),
                      _buildInputField(
                        controller: _dosageController,
                        label: 'DOSAGE',
                        hint: 'e.g. 500mg, 1 tablet',
                        icon: Symbols.weight_rounded,
                        isRequired: false,
                      ),

                      const Text(
                        'FREQUENCY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white38,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _showFrequencyPicker,
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Symbols.event_repeat_rounded,
                                color: Colors.white24,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _frequency,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Symbols.expand_more_rounded,
                                color: Colors.white24,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Text(
                        'START DATE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white38,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDateSelector(),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildSectionLabel('MEAL INSTRUCTIONS'),
                    ),
                    const SizedBox(height: 12),
                    _buildCard(child: _buildMealContextPicker()),
                  ],
                ),

                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildSectionLabel('SUPPLY & REFILL ALERT'),
                    ),
                    const SizedBox(height: 12),
                    _buildSupplyCard(),
                  ],
                ),

                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildSectionLabel('DURATION & PRN RESCUE'),
                    ),
                    const SizedBox(height: 12),
                    _buildCourseAndPrnCard(),
                  ],
                ),

                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _buildSectionLabel('REMINDERS'),
                    ),
                    const SizedBox(height: 16),
                    _buildTimeGrid(),
                  ],
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealContextPicker() {
    final List<({MealContext context, String label, IconData icon})> options =
        <({MealContext context, String label, IconData icon})>[
          (
            context: MealContext.none,
            label: 'Anytime',
            icon: Symbols.timer_rounded,
          ),
          (
            context: MealContext.beforeMeal,
            label: 'Before Meal',
            icon: Symbols.restaurant_rounded,
          ),
          (
            context: MealContext.withMeal,
            label: 'With Meal',
            icon: Symbols.lunch_dining_rounded,
          ),
          (
            context: MealContext.afterMeal,
            label: 'After Meal',
            icon: Symbols.dinner_dining_rounded,
          ),
        ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.3,
      children: options.map((
        ({MealContext context, IconData icon, String label}) opt,
      ) {
        final bool isSelected = _mealContext == opt.context;
        return GestureDetector(
          onTap: () => setState(() => _mealContext = opt.context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blueAccent.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Colors.blueAccent.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  opt.icon,
                  size: 18,
                  color: isSelected ? Colors.blueAccent : Colors.white38,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    opt.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSupplyCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildInputField(
            controller: _supplyController,
            label: 'CURRENT SUPPLY (PACK SIZE / UNITS)',
            hint: 'e.g. 30',
            icon: Symbols.inventory_2_rounded,
            isRequired: false,
          ),
          _buildInputField(
            controller: _lowStockController,
            label: 'LOW STOCK ALERT THRESHOLD',
            hint: 'e.g. 5',
            icon: Symbols.warning_amber_rounded,
            isRequired: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCourseAndPrnCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Fixed Duration Course',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'e.g. Antibiotics or short steroid course',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
              Switch(
                value: _isFixedCourse,
                activeThumbColor: Colors.blueAccent,
                onChanged: (bool val) => setState(() => _isFixedCourse = val),
              ),
            ],
          ),
          if (_isFixedCourse) ...<Widget>[
            const SizedBox(height: 12),
            _buildInputField(
              controller: _courseDaysController,
              label: 'COURSE DURATION (DAYS)',
              hint: 'e.g. 7 or 14',
              icon: Symbols.date_range_rounded,
              isRequired: false,
            ),
          ],
          const Divider(height: 24, color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'As-Needed (PRN) Rescue Dose',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'For painkillers, inhalers, or relief drugs',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
              Switch(
                value: _isPrn,
                activeThumbColor: Colors.tealAccent,
                onChanged: (bool val) => setState(() => _isPrn = val),
              ),
            ],
          ),
          if (_isPrn) ...<Widget>[
            const SizedBox(height: 12),
            _buildInputField(
              controller: _cooldownController,
              label: 'SAFE MINIMUM SPACING (HOURS)',
              hint: 'e.g. 4 or 6',
              icon: Symbols.hourglass_empty_rounded,
              isRequired: false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: child,
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.blueAccent,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isRequired = true,
  }) {
    const Color dulledGrey = Colors.white60;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white38,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: TextFormField(
              controller: controller,
              style: const TextStyle(
                color: dulledGrey,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                prefixIcon: Icon(icon, color: Colors.white24, size: 18),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              validator: isRequired
                  ? (String? v) => (v == null || v.isEmpty) ? '' : null
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypePicker() {
    final List<({String label, IconData icon, Color color})> types =
        <({String label, IconData icon, Color color})>[
          (label: 'Tablet', icon: Symbols.pill_rounded, color: Colors.amber),
          (
            label: 'Capsule',
            icon: Symbols.vaccines_rounded,
            color: Colors.redAccent,
          ),
          (
            label: 'Syringe',
            icon: Symbols.syringe_rounded,
            color: Colors.blueAccent,
          ),
          (
            label: 'Syrup',
            icon: Symbols.medication_liquid_rounded,
            color: Colors.greenAccent,
          ),
        ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.0,
      children: types.map((({Color color, IconData icon, String label}) type) {
        final bool isSelected = _selectedType == type.label;
        return GestureDetector(
          onTap: () => setState(() => _selectedType = type.label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? type.color.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? type.color.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  type.icon,
                  color: isSelected ? type.color : Colors.white24,
                  size: 18,
                ),
                const SizedBox(height: 4),
                Text(
                  type.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white24,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: _times.length + (_times.length < 6 ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index == _times.length) {
          return GestureDetector(
            onTap: _addTime,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: const Icon(
                Symbols.add_rounded,
                color: Colors.blueAccent,
                size: 24,
              ),
            ),
          );
        }

        return Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () => _selectTime(index),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _times[index].format(context).split(' ')[0],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      _times[index].format(context).split(' ')[1],
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (index > 0)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _removeTime(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: const Icon(
                      Symbols.close_rounded,
                      color: Colors.redAccent,
                      size: 12,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDateSelector() {
    const Color dulledGrey = Colors.white60;
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Symbols.calendar_today_rounded,
              color: Colors.white24,
              size: 18,
            ),
            const SizedBox(width: 12),
            Text(
              DateFormat('MMMM dd, yyyy').format(_startDate),
              style: const TextStyle(
                color: dulledGrey,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(
              Symbols.edit_calendar_rounded,
              color: Colors.white24,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
