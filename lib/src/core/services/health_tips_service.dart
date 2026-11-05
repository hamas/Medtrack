import 'notification_manager.dart';

class HealthTipsService {
  HealthTipsService._();
  static final HealthTipsService instance = HealthTipsService._();

  final List<String> _tips = <String>[
    'Taking meds with a full glass of water helps absorption and protects your stomach.',
    'Did you know? Setting a consistent daily routine is the best way to improve adherence.',
    'Always store your medications in a cool, dry place unless specified otherwise.',
    'Staying hydrated helps your kidneys and liver process medications more efficiently.',
    'Medication tracking isn’t just about the dose; it’s about the habit of health.',
    'Pro Tip: Use the Medtrack inventory feature to never run out of supply unexpectedly.',
    'Recovery is a marathon. Your 100% consistency today is a win for tomorrow.',
  ];

  Future<void> scheduleDiscoveryTips() async {
    final NotificationManager notificationManager = NotificationManager();

    // Schedule tips for the next 14 days (every 48 hours)
    final DateTime now = DateTime.now();

    for (int i = 1; i <= 7; i++) {
      final DateTime scheduledTime = DateTime(
        now.year,
        now.month,
        now.day + (i * 2),
        14, // 2:00 PM
        0,
      );

      final String tip = _tips[i % _tips.length];

      await notificationManager.scheduleNotification(
        id: 9000 + i, // Unique IDs for tips
        title: 'Medtrack Discovery ✨',
        body: tip,
        scheduledDate: scheduledTime,
      );
    }
  }
}
