import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:uuid/uuid.dart';

import '../../../../services/local_db_service.dart';
import '../../../daily_dashboard/presentation/providers/daily_timeline_provider.dart';
import '../../../../core/theme/ambient_background.dart';
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
  final String _duration = '1 Month';
  final String _frequency = 'Daily';

  // State for database mapping
  final IntervalType _intervalType = IntervalType.daily;
  final MealContext _mealContext = MealContext.none;
  final DeliveryMethod _deliveryMethod = DeliveryMethod.water;

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
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: SafeArea(
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
                        icon: Icon(
                          Symbols.arrow_back_ios_new_rounded,
                          size: 24,
                          color: colorScheme.onSurface,
                        ),
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        'New Reminder',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Icon(
                          Symbols.notifications_active_rounded,
                          color: colorScheme.tertiary,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                if (_selectedType == 'Tablet')
                                  SvgPicture.asset('assets/images/tablet.svg', height: 180)
                                else if (_selectedType == 'Capsule')
                                  SvgPicture.asset('assets/images/capsule.svg', height: 180)
                                else if (_selectedType == 'Syringe')
                                  SvgPicture.asset('assets/images/syringe.svg', height: 180)
                                else if (_selectedType == 'Syrup')
                                  SvgPicture.asset('assets/images/syrup.svg', height: 180)
                                else
                                  Image.asset(
                                    'assets/images/medication_3d.png',
                                    fit: BoxFit.contain,
                                    height: 180,
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Medicine Name
                        Text(
                          'Medicine Name',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter name...',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.2),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: colorScheme.outline.withValues(alpha: 0.2),
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: colorScheme.outline.withValues(alpha: 0.2),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (String? v) => (v == null || v.isEmpty) ? '' : null,
                        ),

                        const SizedBox(height: 32),

                        // Type Selection
                        Text(
                          'Type',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _TypeOption(
                              label: 'Tablet',
                              asset: 'assets/images/tablet.svg',
                              isSelected: _selectedType == 'Tablet',
                              onTap: () => setState(() => _selectedType = 'Tablet'),
                            ),
                            _TypeOption(
                              label: 'Capsule',
                              asset: 'assets/images/capsule.svg',
                              isSelected: _selectedType == 'Capsule',
                              onTap: () => setState(() => _selectedType = 'Capsule'),
                            ),
                            _TypeOption(
                              label: 'Syringe',
                              asset: 'assets/images/syringe.svg',
                              isSelected: _selectedType == 'Syringe',
                              onTap: () => setState(() => _selectedType = 'Syringe'),
                            ),
                            _TypeOption(
                              label: 'Syrup',
                              asset: 'assets/images/syrup.svg',
                              isSelected: _selectedType == 'Syrup',
                              onTap: () => setState(() => _selectedType = 'Syrup'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Time & Schedule
                        Text(
                          'Time & Schedule',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
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
                                decoration: BoxDecoration(
                                  color: colorScheme.surface.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorScheme.outline.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Icon(
                                  Symbols.add_rounded,
                                  size: 24,
                                  color: colorScheme.error.withValues(alpha: 0.8),
                                ),
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
                                  Text(
                                    'Duration',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _ParamRow(
                                    icon: Symbols.calendar_month_rounded,
                                    value: _duration,
                                    iconColor: colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Frequency',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _ParamRow(
                                    icon: Symbols.schedule_rounded,
                                    value: _frequency,
                                    iconColor: colorScheme.tertiary,
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
                      gradient: LinearGradient(
                        colors: <Color>[
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected
              ? LinearGradient(
                  colors: <Color>[
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
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
          border: isSelected
              ? null
              : Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SvgPicture.asset(
              asset,
              fit: BoxFit.contain,
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDinner = label.contains('Dinner');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDinner
            ? colorScheme.errorContainer.withValues(alpha: 0.2)
            : colorScheme.tertiaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDinner
              ? colorScheme.error.withValues(alpha: 0.1)
              : colorScheme.tertiary.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDinner ? colorScheme.onErrorContainer : colorScheme.onTertiaryContainer,
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Divider(
          height: 1,
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}

