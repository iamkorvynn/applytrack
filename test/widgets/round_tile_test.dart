import 'package:applytrack/models/interview_round.dart';
import 'package:applytrack/widgets/round_tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows round type, date and outcome', (tester) async {
    final round = InterviewRound(
      applicationId: 1,
      type: RoundType.technical,
      scheduledAt: DateTime(2026, 11, 25, 10, 30),
      outcome: RoundOutcome.scheduled,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: RoundTile(round: round)),
      ),
    );
    expect(find.text('Technical round'), findsOneWidget);
    expect(find.textContaining('Scheduled'), findsOneWidget);
    expect(find.textContaining('25 Nov 2026'), findsOneWidget);
  });

  testWidgets('delete button calls onDelete', (tester) async {
    var deleted = false;
    final round = InterviewRound(applicationId: 1, type: RoundType.hr);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoundTile(round: round, onDelete: () => deleted = true),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.delete_outline));
    expect(deleted, isTrue);
  });
}
