// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medtrack/main.dart';
import 'package:medtrack/src/features/medication_management/domain/entities/medicine.dart';
import 'package:medtrack/src/features/medication_management/data/repositories/medication_repository_impl.dart';
import 'package:medtrack/src/services/local_db_service.dart';

void main() {
  testWidgets('App smoke test - verifies basic widget rendering', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MedTrackApp()));

    // Verify that the dashboard is shown
    expect(find.text('Medtrack Dashboard'), findsOneWidget);
  });
}
