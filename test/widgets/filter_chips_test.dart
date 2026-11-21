import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/widgets/filter_chips.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows a chip for every status', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusFilterChips(
            selected: const {},
            onChanged: (_) {},
          ),
        ),
      ),
    );
    for (final status in ApplicationStatus.values) {
      expect(find.text(status.label), findsOneWidget);
    }
  });

  testWidgets('tapping a chip adds it to the selection', (tester) async {
    Set<ApplicationStatus>? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusFilterChips(
            selected: const {},
            onChanged: (value) => picked = value,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Interview'));
    expect(picked, {ApplicationStatus.interview});
  });
}
