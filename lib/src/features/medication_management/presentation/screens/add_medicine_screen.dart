// Developed by Hamas — Medtrack Project [100% Dart Implementation]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/medicine.dart';
import '../../data/repositories/medication_repository_impl.dart';
import '../../../../services/local_db_service.dart';
import '../../../daily_dashboard/presentation/providers/daily_timeline_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // State
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  IntervalType _intervalType = IntervalType.daily;
  int _intervalCount = 1;
  IntervalUnit _intervalUnit = IntervalUnit.days;
  MealContext _mealContext = MealContext.none;
  DeliveryMethod _deliveryMethod = DeliveryMethod.water;
  final DateTime _startDate = DateTime.now();
  int? _durationDays;
  final List<TimeOfDay> _selectedTimes = [const TimeOfDay(hour: 8, minute: 0)];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    final id = const Uuid().v4();
    final userId = 'hamas_lead_dev';

    final medicine = Medicine(
      id: id,
      userId: userId,
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      intervalType: _intervalType,
      intervalCount: _intervalCount,
      intervalUnit: _intervalUnit,
      scheduleTimes: _selectedTimes.map((t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}').toList(),
      mealContext: _mealContext,
      deliveryMethod: _deliveryMethod,
      startDate: _startDate,
      durationDays: _durationDays,
      createdAt: DateTime.now(),
    );

    final repository = MedicationRepositoryImpl(LocalDbService());
    await repository.saveMedicine(medicine);

    // Refresh dashboard immediately
    ref.invalidate(dailyTimelineProvider);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Medication', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() => _currentStep++);
            } else {
              _save();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep--);
          },
          controlsBuilder: (context, details) => _buildControls(details),
          steps: [
            _buildInfoStep(),
            _buildRecurrenceStep(),
            _buildMethodStep(),
            _buildSummaryStep(),
          ],
        ),
      ),
    );
  }

  Step _buildInfoStep() {
    return Step(
      title: const Text('Basic Details'),
      isActive: _currentStep >= 0,
      content: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.medication)),
            validator: (v) => v!.isEmpty ? 'Enter medication name' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _dosageController,
            decoration: const InputDecoration(labelText: 'Dosage', prefixIcon: Icon(Icons.scale)),
            validator: (v) => v!.isEmpty ? 'Enter dosage (e.g. 500mg)' : null,
          ),
        ],
      ),
    );
  }

  Step _buildRecurrenceStep() {
    return Step(
      title: const Text('Scheduling'),
      isActive: _currentStep >= 1,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How often?', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          SegmentedButton<IntervalType>(
            segments: const [
              ButtonSegment(value: IntervalType.daily, label: Text('Daily')),
              ButtonSegment(value: IntervalType.weekly, label: Text('Weekly')),
              ButtonSegment(value: IntervalType.custom, label: Text('Custom')),
            ],
            selected: {_intervalType},
            onSelectionChanged: (v) => setState(() => _intervalType = v.first),
          ),
          if (_intervalType == IntervalType.custom) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Every '),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    initialValue: _intervalCount.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => _intervalCount = int.tryParse(v) ?? 1,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<IntervalUnit>(
                  value: _intervalUnit,
                  items: IntervalUnit.values.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
                  onChanged: (v) => setState(() => _intervalUnit = v!),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          _buildTimePickerSection(),
        ],
      ),
    );
  }

  Widget _buildTimePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dose Times', style: TextStyle(fontWeight: FontWeight.w500)),
        ..._selectedTimes.asMap().entries.map((e) => ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(e.value.format(context)),
          trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() => _selectedTimes.removeAt(e.key))),
          onTap: () async {
            final t = await showTimePicker(context: context, initialTime: e.value);
            if (t != null) setState(() => _selectedTimes[e.key] = t);
          },
        )),
        TextButton.icon(
          onPressed: () => setState(() => _selectedTimes.add(const TimeOfDay(hour: 8, minute: 0))),
          icon: const Icon(Icons.add),
          label: const Text('Add Another Dose'),
        ),
      ],
    );
  }

  Step _buildMethodStep() {
    return Step(
      title: const Text('Context & Method'),
      isActive: _currentStep >= 2,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Meal Context', style: TextStyle(fontWeight: FontWeight.w500)),
          Wrap(
            spacing: 8,
            children: MealContext.values.map((v) => ChoiceChip(
              label: Text(v.name.replaceAll('Meal', '')),
              selected: _mealContext == v,
              onSelected: (s) => setState(() => _mealContext = v),
            )).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Delivery Method', style: TextStyle(fontWeight: FontWeight.w500)),
          Wrap(
            spacing: 8,
            children: DeliveryMethod.values.map((v) => ChoiceChip(
              label: Text(v.name),
              selected: _deliveryMethod == v,
              onSelected: (s) => setState(() => _deliveryMethod = v),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Step _buildSummaryStep() {
    final start = DateFormat('MMM d').format(_startDate);
    return Step(
      title: const Text('Confirm'),
      isActive: _currentStep >= 3,
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            ListTile(title: Text(_nameController.text), subtitle: Text(_dosageController.text), leading: const Icon(Icons.check_circle)),
            ListTile(title: const Text('Starting'), subtitle: Text(start), leading: const Icon(Icons.calendar_today)),
            ListTile(title: const Text('Frequency'), subtitle: Text(_intervalType.name), leading: const Icon(Icons.repeat)),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(ControlsDetails details) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: details.onStepContinue,
            child: Text(_currentStep == 3 ? 'SAVE' : 'NEXT'),
          ),
          if (_currentStep > 0)
            TextButton(onPressed: details.onStepCancel, child: const Text('BACK')),
        ],
      ),
    );
  }
}
