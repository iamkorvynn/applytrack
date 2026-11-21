import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/widgets/status_chip.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> pumpChip(
    WidgetTester tester,
    ApplicationStatus status,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: StatusChip(status: status)),
      ),
    );
  }

  testWidgets('shows the status label', (tester) async {
    await pumpChip(tester, ApplicationStatus.interview);
    expect(find.text('Interview'), findsOneWidget);
    await pumpChip(tester, ApplicationStatus.offer);
    expect(find.text('Offer'), findsOneWidget);
  });

  testWidgets('every status renders without error', (tester) async {
    for (final status in ApplicationStatus.values) {
      await pumpChip(tester, status);
      expect(find.text(status.label), findsOneWidget);
    }
  });
}
