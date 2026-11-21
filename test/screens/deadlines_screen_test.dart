import 'package:applytrack/models/application.dart';
import 'package:applytrack/screens/deadlines_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('groups deadlines into sections', (tester) async {
    final now = DateTime.now();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeadlinesScreen(
            applications: [
              Application(
                company: 'Late Co',
                role: 'Dev',
                deadline: now.subtract(const Duration(days: 2)),
              ),
              Application(
                company: 'Soon Co',
                role: 'Dev',
                deadline: now.add(const Duration(days: 1)),
              ),
              Application(company: 'NoDate Co', role: 'Dev'),
            ],
          ),
        ),
      ),
    );
    expect(find.textContaining('Overdue'), findsOneWidget);
    expect(find.textContaining('This week'), findsOneWidget);
    expect(find.textContaining('No deadline'), findsOneWidget);
  });

  testWidgets('empty state when nothing has a deadline', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: DeadlinesScreen(applications: [])),
      ),
    );
    expect(find.text('No deadlines'), findsOneWidget);
  });
}
