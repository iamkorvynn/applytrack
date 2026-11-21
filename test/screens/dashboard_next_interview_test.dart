import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/models/interview_round.dart';
import 'package:applytrack/screens/dashboard_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows the next interview card when one exists',
      (tester) async {
    final app = Application(
      id: 1,
      company: 'Acme',
      role: 'Dev',
      status: ApplicationStatus.interview,
    );
    final round = InterviewRound(
      applicationId: 1,
      type: RoundType.technical,
      scheduledAt: DateTime.now().add(const Duration(days: 2)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardScreen(
            applications: [app],
            nextInterview: round,
            nextInterviewApp: app,
          ),
        ),
      ),
    );
    expect(find.textContaining('Next interview: Acme'), findsOneWidget);
  });

  testWidgets('shows follow-ups needing a nudge', (tester) async {
    final app = Application(
      company: 'Old Co',
      role: 'Dev',
      status: ApplicationStatus.applied,
      dateApplied: DateTime.now().subtract(const Duration(days: 10)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DashboardScreen(applications: [app])),
      ),
    );
    expect(find.text('Needs a follow-up'), findsOneWidget);
  });
}
