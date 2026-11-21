import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/interview_round.dart';
import 'package:applytrack/widgets/next_interview_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows company and round type with date', (tester) async {
    final round = InterviewRound(
      applicationId: 1,
      type: RoundType.technical,
      scheduledAt: DateTime(2026, 11, 25, 10, 30),
    );
    final app = Application(company: 'Acme', role: 'Dev');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NextInterviewCard(round: round, application: app),
        ),
      ),
    );
    expect(find.textContaining('Acme'), findsOneWidget);
    expect(find.textContaining('Technical round'), findsOneWidget);
    expect(find.textContaining('25 Nov 2026'), findsOneWidget);
  });
}
