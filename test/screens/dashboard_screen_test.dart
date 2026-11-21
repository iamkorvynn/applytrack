import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/screens/dashboard_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  List<Application> apps() {
    return [
      Application(
        company: 'Acme',
        role: 'Flutter Dev',
        status: ApplicationStatus.interview,
        deadline: DateTime.now().add(const Duration(days: 2)),
      ),
      Application(
        company: 'Beta',
        role: 'Backend Dev',
        status: ApplicationStatus.applied,
      ),
    ];
  }

  testWidgets('empty state invites the first application', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: DashboardScreen(applications: [])),
      ),
    );
    expect(find.text('No applications yet'), findsOneWidget);
    expect(find.text('Add application'), findsOneWidget);
  });

  testWidgets('shows stats and upcoming deadlines', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DashboardScreen(applications: apps())),
      ),
    );
    expect(find.text('Applied'), findsOneWidget);
    expect(find.text('Interviews'), findsOneWidget);
    expect(find.text('Upcoming deadlines'), findsOneWidget);
    expect(find.text('Recent applications'), findsOneWidget);
  });

  testWidgets('add button calls onAdd', (tester) async {
    var added = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardScreen(
            applications: [],
            onAdd: () => added = true,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Add application'));
    expect(added, isTrue);
  });
}
