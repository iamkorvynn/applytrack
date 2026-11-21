import 'package:applytrack/models/checklist_item.dart';
import 'package:applytrack/widgets/checklist_tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows the task title', (tester) async {
    final item = ChecklistItem(applicationId: 1, title: 'Revise DSA');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ChecklistTile(item: item)),
      ),
    );
    expect(find.text('Revise DSA'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
  });

  testWidgets('tapping the checkbox calls onToggle', (tester) async {
    var toggled = false;
    final item = ChecklistItem(applicationId: 1, title: 'Revise DSA');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChecklistTile(item: item, onToggle: () => toggled = true),
        ),
      ),
    );
    await tester.tap(find.byType(Checkbox));
    expect(toggled, isTrue);
  });
}
