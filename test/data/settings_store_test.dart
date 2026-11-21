import 'package:applytrack/data/settings_store.dart';
import 'package:applytrack/models/salary_period.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('theme mode defaults to system and round-trips', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await SettingsStore.load();
    expect(store.themeMode, ThemeMode.system);
    await store.setThemeMode(ThemeMode.dark);
    expect(store.themeMode, ThemeMode.dark);
    await store.setThemeMode(ThemeMode.light);
    expect(store.themeMode, ThemeMode.light);
  });

  test('reminder lead days default to 3 and clamp to 0..30', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await SettingsStore.load();
    expect(store.reminderLeadDays, 3);
    await store.setReminderLeadDays(7);
    expect(store.reminderLeadDays, 7);
    await store.setReminderLeadDays(99);
    expect(store.reminderLeadDays, 30);
    await store.setReminderLeadDays(-5);
    expect(store.reminderLeadDays, 0);
  });

  test('default salary period defaults to monthly', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await SettingsStore.load();
    expect(store.defaultSalaryPeriod, SalaryPeriod.monthly);
    await store.setDefaultSalaryPeriod(SalaryPeriod.yearly);
    expect(store.defaultSalaryPeriod, SalaryPeriod.yearly);
  });

  test('settings persist across loads', () async {
    SharedPreferences.setMockInitialValues({
      'theme_mode': 'dark',
      'reminder_lead_days': 5,
    });
    final store = await SettingsStore.load();
    expect(store.themeMode, ThemeMode.dark);
    expect(store.reminderLeadDays, 5);
  });
}
