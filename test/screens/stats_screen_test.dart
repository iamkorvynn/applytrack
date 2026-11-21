import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/screens/stats_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('empty state when there are no applications', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StatsScreen(applications: [])),
      ),
    );
    expect(find.text('No stats yet'), findsOneWidget);
  });

  testWidgets('shows funnel, response rate and sources', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatsScreen(
            applications: [
              Application(
                company: 'Acme',
                role: 'Dev',
                status: ApplicationStatus.interview,
              ),
              Application(
                company: 'Beta',
                role: 'Dev',
                status: ApplicationStatus.applied,
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Pipeline funnel'), findsOneWidget);
    expect(find.text('Response rate'), findsOneWidget);
    expect(find.text('Top sources'), findsOneWidget);
    expect(find.textContaining('% of applications'), findsOneWidget);
  });
}
