import 'package:applytrack/widgets/settings_section.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows title and children', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SettingsSection(
            title: 'Appearance',
            children: [ListTile(title: Text('System'))],
          ),
        ),
      ),
    );
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
  });
}
