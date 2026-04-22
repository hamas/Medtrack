import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:medtrack/src/core/widgets/ambient_background.dart';
import '../providers/settings_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Map<String, dynamic>> settingsAsync = ref.watch(
      settingsStateProvider,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Symbols.arrow_back_rounded,
            size: 22,
            color: Colors.white70,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: AmbientBackground(
        child: settingsAsync.when(
          data: (Map<String, dynamic> settings) => SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                const SizedBox(height: 20),
                _buildToggle(
                  'Main Notifications',
                  'Enable all alerts',
                  Symbols.notifications_active_rounded,
                  Colors.blueAccent,
                  settings['main_enabled'] as bool? ?? true,
                  (bool val) => _update(ref, 'main_enabled', val),
                ),
                const SizedBox(height: 32),
                const _SectionTitle(title: 'ALERT CATEGORIES'),
                const SizedBox(height: 16),
                _buildToggle(
                  'Medication Reminders',
                  'Dose alerts and refill nudges',
                  Symbols.pill_rounded,
                  Colors.pinkAccent,
                  settings['reminders_enabled'] as bool? ?? true,
                  (bool val) => _update(ref, 'reminders_enabled', val),
                ),
                _buildToggle(
                  'Daily Summary',
                  'Morning recap of your schedule',
                  Symbols.assignment_rounded,
                  Colors.amberAccent,
                  settings['summary_enabled'] as bool? ?? false,
                  (bool val) => _update(ref, 'summary_enabled', val),
                ),
                _buildToggle(
                  'Health Tips',
                  'Smart suggestions & insights',
                  Symbols.lightbulb_rounded,
                  Colors.tealAccent,
                  settings['tips_enabled'] as bool? ?? true,
                  (bool val) => _update(ref, 'tips_enabled', val),
                ),
                const SizedBox(height: 32),
                const _SectionTitle(title: 'PREFERENCES'),
                const SizedBox(height: 16),
                _buildTimePicker(
                  context,
                  ref,
                  'Summary Time',
                  settings['summary_time'] as String? ?? '08:00',
                ),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object e, StackTrace? _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Widget _buildToggle(
    String title,
    String sub,
    IconData icon,
    Color color,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          sub,
          style: const TextStyle(fontSize: 11, color: Colors.white38),
        ),
        activeTrackColor: color.withValues(alpha: 0.3),
        activeThumbColor: color,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Colors.white38,
        letterSpacing: 2,
      ),
    );
  }
}
