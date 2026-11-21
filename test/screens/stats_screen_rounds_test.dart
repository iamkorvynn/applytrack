import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/models/interview_round.dart';
import 'package:applytrack/screens/stats_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows streak, response time and salary insights',
      (tester) async {
    final apps = [
      Application(
        company: 'Acme',
        role: 'Dev',
        status: ApplicationStatus.interview,
        dateApplied: DateTime(2026, 11, 10),
        salaryMax: 60000,
      ),
      Application(
        company: 'Beta',
        role: 'Dev',
        status: ApplicationStatus.applied,
        dateApplied: DateTime(2026, 11, 11),
        salaryMax: 40000,
      ),
    ];
    final rounds = [
      InterviewRound(
        applicationId: 1,
        scheduledAt: DateTime(2026, 11, 15),
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatsScreen(applications: apps, rounds: rounds),
        ),
      ),
    );
    expect(find.text('Application streak'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('first interview'),
      200,
      scrollable: find.byType(ListView),
    );
    expect(find.textContaining('first interview'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('Median top pay'),
      200,
      scrollable: find.byType(ListView),
    );
    expect(find.textContaining('Median top pay'), findsOneWidget);
  });
}
