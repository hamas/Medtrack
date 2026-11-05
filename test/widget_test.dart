import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:medtrack/main.dart' hide main;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
    tz.initializeTimeZones();
  });

  testWidgets('App smoke test - verifies basic widget rendering', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MedTrackApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that the dashboard shell is rendered by checking the brand title
    expect(find.text('Medtrack'), findsOneWidget);
  });
}
