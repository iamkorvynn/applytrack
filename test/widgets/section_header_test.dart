import 'package:applytrack/widgets/section_header.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows title and optional action', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Upcoming deadlines',
            actionLabel: 'See all',
            onAction: () => pressed = true,
          ),
        ),
      ),
    );
    expect(find.text('Upcoming deadlines'), findsOneWidget);
    await tester.tap(find.text('See all'));
    expect(pressed, isTrue);
  });

  testWidgets('no action button when none is given', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SectionHeader(title: 'Stats')),
      ),
    );
    expect(find.byType(TextButton), findsNothing);
  });
}
