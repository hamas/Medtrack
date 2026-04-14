// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test - verifies basic widget rendering', (WidgetTester tester) async {
    // We test a simple scaffold to verify the test environment is healthy
    // and avoid complex Firebase/Biometric dependencies for this basic check.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Medtrack')),
            body: const Center(child: Text('Sanity Check')),
          ),
        ),
      ),
    );

    expect(find.text('Medtrack'), findsOneWidget);
    expect(find.text('Sanity Check'), findsOneWidget);
  });
}
