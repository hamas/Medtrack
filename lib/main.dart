import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/services/health_tips_service.dart';
import 'src/core/services/firebase_service.dart';
import 'src/core/services/notification_manager.dart';
import 'src/core/navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MedTrackApp()));

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    final FirebaseService firebaseService = FirebaseService();
    await firebaseService.initialize();
    await firebaseService.ensureAuthenticated();
  } catch (e) {
    debugPrint('Firebase initialization failed. Error: $e');
  }

  try {
    final NotificationManager notificationManager = NotificationManager();
    await notificationManager.initialize();
    await notificationManager.requestPermissions();
  } catch (e) {
    debugPrint('Notification initialization failed. Error: $e');
  }

  try {
    final HealthTipsService healthTipsService = HealthTipsService.instance;
    await healthTipsService.scheduleDiscoveryTips();
  } catch (e) {
    debugPrint('Health tips initialization failed. Error: $e');
  }
}

class MedTrackApp extends ConsumerWidget {
  const MedTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Medtrack',
      debugShowCheckedModeBanner: false,
      theme: MedTrackTheme.darkTheme(),
      routerConfig: appRouter,
    );
  }
}
