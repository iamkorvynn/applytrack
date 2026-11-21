import 'package:applytrack/widgets/date_picker_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows label and formatted date', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DatePickerField(
            label: 'Deadline',
            value: DateTime(2026, 11, 30),
            onPick: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Deadline'), findsOneWidget);
    expect(find.text('30 Nov 2026'), findsOneWidget);
  });

  testWidgets('clear button calls onPick with null', (tester) async {
    DateTime? picked = DateTime(2026, 11, 30);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DatePickerField(
            label: 'Deadline',
            value: DateTime(2026, 11, 30),
            onPick: (value) => picked = value,
          ),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.clear));
    expect(picked, isNull);
  });

  testWidgets('no clear button when no date is set', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DatePickerField(
            label: 'Deadline',
            value: null,
            onPick: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Not set'), findsOneWidget);
    expect(find.byIcon(Icons.clear), findsNothing);
  });
}
