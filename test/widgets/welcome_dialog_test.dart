import 'package:applytrack/widgets/welcome_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows welcome text and start button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: WelcomeDialog()),
      ),
    );
    expect(find.text('Welcome to ApplyTrack'), findsOneWidget);
    expect(find.text('Start tracking'), findsOneWidget);
  });
}
