import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/widgets/application_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Application app() {
    return Application(
      company: 'Acme Corp',
      role: 'Flutter Developer',
      city: 'Bengaluru',
      salaryMin: 40000,
      salaryMax: 60000,
      status: ApplicationStatus.applied,
      deadline: DateTime(2026, 11, 30),
    );
  }

  testWidgets('shows role, company and status', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ApplicationCard(application: app())),
      ),
    );
    expect(find.text('Flutter Developer'), findsOneWidget);
    expect(find.textContaining('Acme Corp'), findsOneWidget);
    expect(find.text('Applied'), findsOneWidget);
  });

  testWidgets('tap calls onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ApplicationCard(
            application: app(),
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(ApplicationCard));
    expect(tapped, isTrue);
  });

  testWidgets('overdue deadline is flagged', (tester) async {
    final overdue = app().copyWith(deadline: DateTime(2020, 1, 1));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ApplicationCard(application: overdue)),
      ),
    );
    expect(find.textContaining('Deadline was'), findsOneWidget);
  });
}
