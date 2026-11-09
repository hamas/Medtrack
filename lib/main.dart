import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'firebase_options.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/services/health_tips_service.dart';
import 'src/core/services/firebase_service.dart';
import 'src/core/services/notification_manager.dart';
import 'src/core/navigation/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezones locally (synchronous & instant)
  try {
    tz.initializeTimeZones();
  } catch (e) {
    debugPrint('Timezone initialization warning: $e');
  }

  // 1. Immediately launch the app to eliminate splash screen hang/freeze
  runApp(const ProviderScope(child: MedTrackApp()));

  // 2. Bootstrap network services, notifications, and Firebase asynchronously in the background
  unawaited(_bootstrapServices());
}

Future<void> _bootstrapServices() async {
  // Initialize Firebase safely
  try {
    if (Firebase.apps.isEmpty) {
      if (Platform.isAndroid) {
        try {
          await Firebase.initializeApp();
        } catch (_) {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        }
      } else {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    }
    final FirebaseService firebaseService = FirebaseService();
    await firebaseService.initialize();
    await firebaseService.ensureAuthenticated();
  } catch (e) {
    debugPrint('Firebase bootstrap warning: $e');
  }

  // Initialize notifications & request notification permission
  try {
    final NotificationManager notificationManager = NotificationManager();
    await notificationManager.initialize();
    await notificationManager.requestPermissions();
  } catch (e) {
    debugPrint('Notification bootstrap warning: $e');
  }

  // Schedule tips in background
  try {
    final HealthTipsService healthTipsService = HealthTipsService.instance;
    await healthTipsService.scheduleDiscoveryTips();
  } catch (e) {
    debugPrint('Health tips bootstrap warning: $e');
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
