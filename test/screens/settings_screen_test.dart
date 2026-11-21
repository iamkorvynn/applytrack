import 'package:applytrack/models/application.dart';
import 'package:applytrack/screens/settings_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows theme choices and export row', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsScreen(
            applications: [
              Application(company: 'Acme', role: 'Dev'),
            ],
            themeMode: ThemeMode.system,
            onThemeChanged: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Export as CSV'), findsOneWidget);
  });

  testWidgets('tapping a theme calls onThemeChanged', (tester) async {
    ThemeMode? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsScreen(
            applications: [],
            themeMode: ThemeMode.system,
            onThemeChanged: (mode) => picked = mode,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Dark'));
    expect(picked, ThemeMode.dark);
  });
}
