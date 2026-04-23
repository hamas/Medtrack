import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

@riverpod
class NotificationCount extends _$NotificationCount {
  @override
  int build() => 3;

  void setCount(int count) => state = count;
}

@riverpod
class ProfileSaveTrigger extends _$ProfileSaveTrigger {
  @override
  int build() => 0;

  void trigger() => state++;
}

@riverpod
class SettingsState extends _$SettingsState {
  @override
  Future<Map<String, dynamic>> build() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return <String, dynamic>{
      'biometric_enabled': prefs.getBool('biometric_enabled') ?? false,
      'notifications_enabled': prefs.getBool('notifications_enabled') ?? true,
      'tips_enabled': prefs.getBool('tips_enabled') ?? true,
      'reminders_enabled': prefs.getBool('reminders_enabled') ?? true,
      'summary_enabled': prefs.getBool('summary_enabled') ?? false,
      'summary_time': prefs.getString('summary_time') ?? '20:00',
    };
  }

  Future<void> updateSetting(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }

    final Map<String, dynamic> current = await future;
    state = AsyncValue<Map<String, dynamic>>.data(<String, dynamic>{
      ...current,
      key: value,
    });
  }

  Future<void> toggleBiometric(bool value) async {
    await updateSetting('biometric_enabled', value);
  }
}
