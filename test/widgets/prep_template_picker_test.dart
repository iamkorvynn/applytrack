import 'package:applytrack/models/interview_round.dart';
import 'package:applytrack/widgets/prep_template_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows a chip per round type', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrepTemplatePicker(onAdd: (_) {}),
        ),
      ),
    );
    expect(find.textContaining('HR round prep'), findsOneWidget);
    expect(find.textContaining('Technical round prep'), findsOneWidget);
  });

  testWidgets('tapping a chip calls onAdd with that type', (tester) async {
    RoundType? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrepTemplatePicker(onAdd: (type) => picked = type),
        ),
      ),
    );
    await tester.tap(find.textContaining('HR round prep'));
    expect(picked, RoundType.hr);
  });
}
