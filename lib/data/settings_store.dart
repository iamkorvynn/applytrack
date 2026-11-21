import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/salary_period.dart';
import '../utils/constants.dart';

/// Small user preferences: theme, reminder lead time, default salary
/// period. Stored with SharedPreferences, no account needed.
class SettingsStore {
  SettingsStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<SettingsStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsStore(prefs);
  }

  static const String _themeKey = 'theme_mode';
  static const String _leadDaysKey = 'reminder_lead_days';
  static const String _salaryPeriodKey = 'default_salary_period';

  ThemeMode get themeMode {
    final raw = _prefs.getString(_themeKey);
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }

  int get reminderLeadDays =>
      _prefs.getInt(_leadDaysKey) ?? AppConstants.defaultReminderLeadDays;

  Future<void> setReminderLeadDays(int days) async {
    final clamped = days.clamp(0, 30);
    await _prefs.setInt(_leadDaysKey, clamped);
  }

  SalaryPeriod get defaultSalaryPeriod {
    final raw = _prefs.getString(_salaryPeriodKey);
    if (raw == SalaryPeriod.yearly.name) return SalaryPeriod.yearly;
    return SalaryPeriod.monthly;
  }

  Future<void> setDefaultSalaryPeriod(SalaryPeriod period) async {
    await _prefs.setString(_salaryPeriodKey, period.name);
  }
}
