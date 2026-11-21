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

  testWidgets('show() returns true after tapping Start tracking',
      (tester) async {
    var result = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await WelcomeDialog.show(context);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start tracking'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });
}
