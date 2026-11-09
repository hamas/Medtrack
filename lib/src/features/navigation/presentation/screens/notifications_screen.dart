import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/services/notification_manager.dart';
import '../../../../core/widgets/shared_ui.dart';
import '../providers/settings_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Map<String, dynamic>> settingsAsync = ref.watch(
      settingsStateProvider,
    );

    return settingsAsync.when(
      data: (Map<String, dynamic> settings) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: <Widget>[
            const SizedBox(height: 20),
            GlassSwitchTile(
              title: 'Main Notifications',
              subtitle: 'Enable all alerts',
              icon: Symbols.notifications_active_rounded,
              color: Colors.blueAccent,
              value: settings['notifications_enabled'] as bool? ?? true,
              onChanged: (bool val) =>
                  _update(ref, 'notifications_enabled', val),
            ),
            const SizedBox(height: 32),
            const GlassSectionTitle(title: 'ALERT CATEGORIES'),
            const SizedBox(height: 16),
            GlassSwitchTile(
              title: 'Medication Reminders',
              subtitle: 'Dose alerts and refill nudges',
              icon: Symbols.pill_rounded,
              color: Colors.pinkAccent,
              value: settings['reminders_enabled'] as bool? ?? true,
              onChanged: (bool val) => _update(ref, 'reminders_enabled', val),
            ),
            GlassSwitchTile(
              title: 'Daily Summary',
              subtitle: 'Morning recap of your schedule',
              icon: Symbols.assignment_rounded,
              color: Colors.amberAccent,
              value: settings['summary_enabled'] as bool? ?? false,
              onChanged: (bool val) => _update(ref, 'summary_enabled', val),
            ),
            GlassSwitchTile(
              title: 'Health Tips',
              subtitle: 'Smart suggestions & insights',
              icon: Symbols.lightbulb_rounded,
              color: Colors.tealAccent,
              value: settings['tips_enabled'] as bool? ?? true,
              onChanged: (bool val) => _update(ref, 'tips_enabled', val),
            ),
            const SizedBox(height: 32),
            const GlassSectionTitle(title: 'PREFERENCES'),
            const SizedBox(height: 16),
            _buildTimePicker(
              context,
              ref,
              'Summary Time',
              settings['summary_time'] as String? ?? '08:00',
            ),
            const SizedBox(height: 32),
            const GlassSectionTitle(title: 'DEVICE NOTIFICATION TEST'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Test Device Notification',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Triggers an immediate high-priority alert in your Android status bar.',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Symbols.notifications_active_rounded, size: 18),
                      label: const Text('Send Test Alert Now'),
                      onPressed: () async {
                        await NotificationManager().showNotification(
                          id: 99999,
                          title: 'Medtrack Alert: Aspirin (81mg) 🔔',
                          body: 'Time for your scheduled dose • Instructions: With Meal',
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notification sent to system notification tray!'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object e, StackTrace? _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    WidgetRef ref,
    String label,
    String timeStr,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                timeStr,
                style: const TextStyle(fontSize: 12, color: Colors.white38),
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: int.parse(timeStr.split(':')[0]),
                  minute: int.parse(timeStr.split(':')[1]),
                ),
              );
              if (picked != null) {
                _update(
                  ref,
                  'summary_time',
                  '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
                );
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _update(WidgetRef ref, String key, dynamic value) {
    ref.read(settingsStateProvider.notifier).updateSetting(key, value);
  }
}
