import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/local_db_service.dart';
import '../../../../core/services/notification_manager.dart';
import '../../../../core/widgets/shared_ui.dart';
import '../../../daily_dashboard/presentation/providers/daily_timeline_provider.dart';
import '../../../gamification/presentation/providers/adherence_history_provider.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../../../medication_management/presentation/providers/all_medicines_provider.dart';
import '../providers/settings_provider.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

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
              title: 'Biometric Lock',
              subtitle: 'Require fingerprint or PIN to open',
              icon: Symbols.fingerprint_rounded,
              color: Colors.greenAccent,
              value: settings['biometric_enabled'] as bool? ?? false,
              onChanged: (bool val) => _update(ref, 'biometric_enabled', val),
            ),
            const SizedBox(height: 32),
            const GlassSectionTitle(title: 'DATA MANAGEMENT'),
            const SizedBox(height: 16),
            GlassActionTile(
              title: 'Clear Local Medication Data',
              subtitle: 'Reset local offline database cache',
              icon: Symbols.cleaning_services_rounded,
              color: Colors.orangeAccent,
              onTap: () => _confirmClearData(context, ref),
            ),
            const SizedBox(height: 32),
            const GlassSectionTitle(title: 'ACCOUNT ACTIONS'),
            const SizedBox(height: 16),
            GlassActionTile(
              title: 'Sign Out & Reset Session',
              subtitle: 'Disconnect current user session',
              icon: Symbols.logout_rounded,
              color: Colors.redAccent,
              onTap: () => _confirmSignOut(context, ref),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object e, StackTrace? _) => Center(child: Text('Error: $e')),
    );
  }

  Future<void> _confirmClearData(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Clear Local Data?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This will purge all locally cached medicines and adherence logs from this device.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orangeAccent.shade700,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await NotificationManager().cancelAll();
      await LocalDbService().clearAllData();
      ref.invalidate(allMedicinesProvider);
      ref.invalidate(dailyTimelineProvider);
      ref.invalidate(adherenceHistoryProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Local cache cleared successfully.')),
        );
      }
    }
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Sign Out?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to end your session?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent.shade700,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseService().signOut();
      ref.invalidate(allMedicinesProvider);
      ref.invalidate(dailyTimelineProvider);
      ref.invalidate(userProfileStateProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed out successfully.')),
        );
      }
    }
  }

  Future<void> _update(WidgetRef ref, String key, dynamic value) async {
    if (key == 'biometric_enabled' && value == true) {
      final LocalAuthentication auth = LocalAuthentication();
      try {
        final bool canCheck =
            await auth.canCheckBiometrics || await auth.isDeviceSupported();
        if (canCheck) {
          final bool didAuth = await auth.authenticate(
            localizedReason: 'Please authenticate to enable biometric lock',
            biometricOnly: false,
            persistAcrossBackgrounding: true,
          );
          if (!didAuth) return;
        }
      } catch (e) {
        debugPrint('Auth verification failed: $e');
        return;
      }
    }
    await ref.read(settingsStateProvider.notifier).updateSetting(key, value);
  }
}
