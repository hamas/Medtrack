// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:medtrack/main.dart';

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  testWidgets('App smoke test - verifies basic widget rendering', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MedTrackApp()));

    // Verify that the dashboard shell is rendered by checking the brand title
    expect(find.text('Medtrack'), findsOneWidget);
  });
}
