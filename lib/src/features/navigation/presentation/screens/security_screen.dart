import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:medtrack/src/core/widgets/ambient_background.dart';
import '../providers/settings_provider.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

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
          'Security',
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
                  'Biometric Lock',
                  'Secure app with Fingerprint/FaceID',
                  Symbols.fingerprint_rounded,
                  Colors.tealAccent,
                  settings['biometric_enabled'] as bool? ?? false,
                  (bool val) => _update(ref, 'biometric_enabled', val),
                ),
                _buildToggle(
                  'Cloud Sync',
                  'Keep data synced across devices',
                  Symbols.cloud_sync_rounded,
                  Colors.blueAccent,
                  settings['cloud_sync_enabled'] as bool? ?? true,
                  (bool val) => _update(ref, 'cloud_sync_enabled', val),
                ),
                const SizedBox(height: 32),
                const _SectionTitle(title: 'DATA MANAGEMENT'),
                const SizedBox(height: 16),
                _buildActionButton(
                  'Export Health Data',
                  'Download your adherence history',
                  Symbols.export_notes_rounded,
                  Colors.amberAccent,
                  () {
                    // Export logic
                  },
                ),
                _buildActionButton(
                  'Delete Account',
                  'Permanently remove all data',
                  Symbols.delete_forever_rounded,
                  Colors.redAccent,
                  () {
                    // Delete logic
                  },
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

  Widget _buildActionButton(
    String title,
    String sub,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
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
        trailing: const Icon(
          Symbols.chevron_right_rounded,
          color: Colors.white10,
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
