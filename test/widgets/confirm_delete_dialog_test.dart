import 'package:applytrack/widgets/confirm_delete_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> pumpOpener(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => ConfirmDeleteDialog.show(
                context,
                'Delete Acme — Dev?',
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the message with cancel and delete', (tester) async {
    await pumpOpener(tester);
    expect(find.text('Delete Acme — Dev?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsWidgets);
  });

  testWidgets('tapping delete closes the dialog', (tester) async {
    await pumpOpener(tester);
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('Delete Acme — Dev?'), findsNothing);
  });
}
