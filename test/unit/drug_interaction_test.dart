import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack/src/features/medication_management/domain/entities/medicine.dart';
import 'package:medtrack/src/features/medication_management/domain/services/drug_interaction_service.dart';

void main() {
  group('Clinical Drug Interaction Unit Tests', () {
    final Medicine warfarin = Medicine(
      id: 'med_1',
      userId: 'test_user',
      name: 'Warfarin 5mg',
      dosage: '5mg',
      intervalType: IntervalType.daily,
      scheduleTimes: <String>['08:00'],
      mealContext: MealContext.none,
      deliveryMethod: DeliveryMethod.tablet,
      startDate: DateTime(2026, 1, 1),
    );

    final Medicine lisinopril = Medicine(
      id: 'med_2',
      userId: 'test_user',
      name: 'Lisinopril 10mg',
      dosage: '10mg',
      intervalType: IntervalType.daily,
      scheduleTimes: <String>['08:00'],
      mealContext: MealContext.none,
      deliveryMethod: DeliveryMethod.tablet,
      startDate: DateTime(2026, 1, 1),
    );

    test(
      'should flag High hemorrhage risk when adding Ibuprofen with active Warfarin',
      () {
        final List<DrugInteraction> results =
            DrugInteractionService.checkInteractions(
              newDrugName: 'Ibuprofen',
              cabinetDrugs: <Medicine>[warfarin],
            );

        expect(results.isNotEmpty, true);
        expect(results.first.severity, 'High');
        expect(results.first.title, contains('Hemorrhage'));
      },
    );

    test(
      'should flag Hyperkalemia risk when adding Spironolactone with active Lisinopril',
      () {
        final List<DrugInteraction> results =
            DrugInteractionService.checkInteractions(
              newDrugName: 'Spironolactone 25mg',
              cabinetDrugs: <Medicine>[lisinopril],
            );

        expect(results.isNotEmpty, true);
        expect(results.first.title, contains('Hyperkalemia'));
      },
    );

    test(
      'should flag Chelation absorption block when taking Ciprofloxacin with Milk',
      () {
        final List<DrugInteraction> results =
            DrugInteractionService.checkInteractions(
              newDrugName: 'Ciprofloxacin 500mg',
              cabinetDrugs: <Medicine>[],
              deliveryMethod: DeliveryMethod.milk,
            );

        expect(results.isNotEmpty, true);
        expect(results.first.title, contains('Calcium-Binding'));
      },
    );

    test(
      'should return empty list when no known clinical interactions exist',
      () {
        final List<DrugInteraction> results =
            DrugInteractionService.checkInteractions(
              newDrugName: 'Metformin 500mg',
              cabinetDrugs: <Medicine>[warfarin],
            );

        expect(results.isEmpty, true);
      },
    );
  });
}
