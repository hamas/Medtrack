import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medtrack/src/features/medication_management/presentation/screens/add_medicine_screen.dart';

void main() {
  group('Add Medicine Form Widget Tests', () {
    testWidgets('Add Medicine Form should render basic scaffold', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: AddMedicineScreen())),
      );

      expect(find.text('Add Medication'), findsOneWidget);
      expect(find.text('Basic Information'), findsOneWidget);
    });
  });
}
