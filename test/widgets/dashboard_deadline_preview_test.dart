import 'package:applytrack/models/application.dart';
import 'package:applytrack/widgets/dashboard_deadline_preview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows nothing when there are no deadlines', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DashboardDeadlinePreview(upcoming: []),
        ),
      ),
    );
    expect(find.text('Upcoming deadlines'), findsNothing);
  });

  testWidgets('shows up to three upcoming deadlines', (tester) async {
    final now = DateTime.now();
    final apps = List.generate(
      5,
      (index) => Application(
        company: 'Co $index',
        role: 'Dev',
        deadline: now.add(Duration(days: index + 1)),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DashboardDeadlinePreview(upcoming: apps)),
      ),
    );
    expect(find.text('Upcoming deadlines'), findsOneWidget);
    expect(find.textContaining('Co 0'), findsOneWidget);
    expect(find.textContaining('Co 4'), findsNothing);
  });
}
