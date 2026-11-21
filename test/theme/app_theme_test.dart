import 'package:applytrack/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('light theme is light and dark theme is dark', () {
    expect(AppTheme.light.brightness, Brightness.light);
    expect(AppTheme.dark.brightness, Brightness.dark);
  });

  test('both themes use Material 3', () {
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.dark.useMaterial3, isTrue);
  });

  test('seed colour is the same in both themes', () {
    expect(AppTheme.seed, const Color(0xFF1B5E20));
  });
}
