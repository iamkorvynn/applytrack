import 'package:applytrack/widgets/empty_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows title, message and action button', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.work_outline,
            title: 'No applications yet',
            message: 'Add your first one.',
            actionLabel: 'Add application',
            onAction: () => pressed = true,
          ),
        ),
      ),
    );
    expect(find.text('No applications yet'), findsOneWidget);
    expect(find.text('Add your first one.'), findsOneWidget);
    await tester.tap(find.text('Add application'));
    expect(pressed, isTrue);
  });

  testWidgets('no button when no action is given', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.event,
            title: 'Nothing here',
            message: 'Empty.',
          ),
        ),
      ),
    );
    expect(find.byType(FilledButton), findsNothing);
  });
}
