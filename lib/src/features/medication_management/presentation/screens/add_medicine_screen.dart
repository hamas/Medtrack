import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:uuid/uuid.dart';

import '../../../../services/local_db_service.dart';
import '../../../daily_dashboard/presentation/providers/daily_timeline_provider.dart';
import '../../data/repositories/medication_repository_impl.dart';
import '../../domain/entities/medicine.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();

  // Selections
  String _selectedType = 'Capsule'; // Tablet, Capsule, Syringe
  final List<String> _selectedTimes = <String>['After Breakfast', 'After Dinner'];
  String _duration = '1 Month';
  String _frequency = 'Daily';

  // State for database mapping
  IntervalType _intervalType = IntervalType.daily;
  MealContext _mealContext = MealContext.none;
  DeliveryMethod _deliveryMethod = DeliveryMethod.water;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final String id = const Uuid().v4();
    const String userId = 'hamas_lead_dev';

    final Medicine medicine = Medicine(
      id: id,
      userId: userId,
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim().isEmpty ? '500mg' : _dosageController.text.trim(),
      intervalType: _intervalType,
      scheduleTimes: <String>['08:00', '20:00'], // Simplified for UI demo
      mealContext: _mealContext,
      deliveryMethod: _deliveryMethod,
      startDate: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final MedicationRepositoryImpl repository = MedicationRepositoryImpl(
      LocalDbService(),
    );
    await repository.saveMedicine(medicine);

    ref.invalidate(dailyTimelineProvider);
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Custom Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Symbols.arrow_back_ios_new_rounded, size: 24),
                      onPressed: () => context.pop(),
                    ),
                    const Text(
                      'New Reminder',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Symbols.notifications_active_rounded,
                        color: Color(0xFF10B981),
                        size: 20,
                        fill: 1,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Hero Visual
                      Center(
                        child: Container(
                          height: 200,
                          margin: const EdgeInsets.symmetric(vertical: 24),
                          child: Image.asset(
                            'assets/images/medication_3d.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Medicine Name
                      const Text(
                        'Medicine Name',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter name...',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2),
                          ),
                        ),
                        validator: (String? v) => (v == null || v.isEmpty) ? '' : null,
                      ),

                      const SizedBox(height: 32),

                      // Type Selection
                      const Text(
                        'Type',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _TypeOption(
                            label: 'Tablet',
                            asset: 'assets/images/medicine_bottle_3d.png',
                            isSelected: _selectedType == 'Tablet',
                            onTap: () => setState(() => _selectedType = 'Tablet'),
                          ),
                          _TypeOption(
                            label: 'Capsule',
                            asset: 'assets/images/capsule_3d.png',
                            isSelected: _selectedType == 'Capsule',
                            onTap: () => setState(() => _selectedType = 'Capsule'),
                          ),
                          _TypeOption(
                            label: 'Syringe',
                            asset: 'assets/images/syringe_3d.png',
                            isSelected: _selectedType == 'Syringe',
                            onTap: () => setState(() => _selectedType = 'Syringe'),
                          ),
                          _TypeOption(
                            label: 'Other',
                            asset: 'assets/images/medication_3d.png',
                            isSelected: _selectedType == 'Other',
                            onTap: () => setState(() => _selectedType = 'Other'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Time & Schedule
                      const Text(
                        'Time & Schedule',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          ..._selectedTimes.map((String time) => _ScheduleChip(label: time)),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Color(0x1A000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Symbols.add_rounded, size: 24, color: Color(0xFFF87171)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Duration & Frequency
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Duration',
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _ParamRow(
                                  icon: Symbols.calendar_month_rounded,
                                  value: _duration,
                                  iconColor: const Color(0xFF60A5FA),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Frequency',
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _ParamRow(
                                  icon: Symbols.schedule_rounded,
                                  value: _frequency,
                                  iconColor: const Color(0xFFFB923C),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 120), // Spacing for bottom button
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Container(
                  width: double.infinity,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xFF5EEAD4), Color(0xFF2DD4BF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFF2DD4BF).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _save,
                      borderRadius: BorderRadius.circular(20),
                      child: const Center(
                        child: Text(
                          'Add Reminder',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
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
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  const _TypeOption({
    required this.label,
    required this.asset,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final String asset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected
              ? const LinearGradient(
                  colors: <Color>[Color(0xFF60A5FA), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ]
              : <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              color: isSelected ? Colors.white.withValues(alpha: 0.2) : null,
              colorBlendMode: isSelected ? BlendMode.overlay : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleChip extends StatelessWidget {
  const _ScheduleChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final bool isDinner = label.contains('Dinner');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDinner ? const Color(0xFFFFF7ED) : const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDinner ? const Color(0xFFEA580C) : const Color(0xFF059669),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _ParamRow extends StatelessWidget {
  const _ParamRow({
    required this.icon,
    required this.value,
    required this.iconColor,
  });
  final IconData icon;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, color: Color(0xFFF3F4F6)),
      ],
    );
  }
}

