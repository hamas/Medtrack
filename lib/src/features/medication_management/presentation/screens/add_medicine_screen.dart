// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/medicine.dart';
import '../../data/repositories/medication_repository_impl.dart';
import '../../../../services/local_db_service.dart';
import '../providers/timeline_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Form State
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  IntervalType _intervalType = IntervalType.daily;
  MealContext _mealContext = MealContext.none;
  DeliveryMethod _deliveryMethod = DeliveryMethod.water;
  DateTime _startDate = DateTime.now();
  final List<TimeOfDay> _selectedTimes = [const TimeOfDay(hour: 8, minute: 0)];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  void _saveMedicine() async {
    const userId = 'hamas_lead_dev';
    final id = Uuid().v4();

    final medicine = Medicine(
      id: id,
      userId: userId,
      name: _nameController.text,
      dosage: _dosageController.text,
      intervalType: _intervalType,
      scheduleTimes: _selectedTimes.map((t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}').toList(),
      mealContext: _mealContext,
      deliveryMethod: _deliveryMethod,
      startDate: _startDate,
      createdAt: DateTime.now(),
    );

    final localDb = LocalDbService();
    final repository = MedicationRepositoryImpl(localDb);
    
    await repository.saveMedicine(medicine);
    
    // Refresh timeline and go back
    ref.invalidate(dailyTimelineProvider);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Medication')),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() => _currentStep += 1);
            } else {
              _saveMedicine();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            } else {
              context.pop();
            }
          },
          steps: [
            Step(
              title: const Text('Basic Information'),
              isActive: _currentStep >= 0,
              content: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Medicine Name', hintText: 'e.g., Amoxicillin'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _dosageController,
                    decoration: const InputDecoration(labelText: 'Dosage', hintText: 'e.g., 500mg'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Recurrence Schedule'),
              isActive: _currentStep >= 1,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<IntervalType>(
                    value: _intervalType,
                    decoration: const InputDecoration(labelText: 'Frequency'),
                    items: IntervalType.values.map((type) => DropdownMenuItem(value: type, child: Text(type.name.toUpperCase()))).toList(),
                    onChanged: (v) => setState(() => _intervalType = v!),
                  ),
                  const SizedBox(height: 16),
                  const Text('Dose Times', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._selectedTimes.asMap().entries.map((entry) => ListTile(
                    title: Text('Dose ${entry.key + 1}: ${entry.value.format(context)}'),
                    trailing: const Icon(Icons.edit),
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: entry.value);
                      if (time != null) {
                        setState(() => _selectedTimes[entry.key] = time);
                      }
                    },
                  )),
                ],
              ),
            ),
            Step(
              title: const Text('Context & Method'),
              isActive: _currentStep >= 2,
              content: Column(
                children: [
                  DropdownButtonFormField<MealContext>(
                    value: _mealContext,
                    decoration: const InputDecoration(labelText: 'Meal Context'),
                    items: MealContext.values.map((v) => DropdownMenuItem(value: v, child: Text(v.name.toUpperCase()))).toList(),
                    onChanged: (v) => setState(() => _mealContext = v!),
                  ),
                  DropdownButtonFormField<DeliveryMethod>(
                    value: _deliveryMethod,
                    decoration: const InputDecoration(labelText: 'Delivery Method'),
                    items: DeliveryMethod.values.map((v) => DropdownMenuItem(value: v, child: Text(v.name.toUpperCase()))).toList(),
                    onChanged: (v) => setState(() => _deliveryMethod = v!),
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Summary & Confirmation'),
              isActive: _currentStep >= 3,
              content: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Schedule Preview', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('• ${_nameController.text} (${_dosageController.text})'),
                      Text('• ${_intervalType.name.toUpperCase()} at ${_selectedTimes.map((t) => t.format(context)).join(', ')}'),
                      Text('• Beginning ${DateFormat('yMMMd').format(_startDate)}'),
                      Text('• Instruction: ${_mealContext.name.toUpperCase()} via ${_deliveryMethod.name.toUpperCase()}'),
                    ],
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
