import 'package:applytrack/models/application.dart';
import 'package:applytrack/widgets/deadline_row.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows company, role and relative day', (tester) async {
    final app = Application(
      company: 'Acme',
      role: 'Dev',
      deadline: DateTime.now().add(const Duration(days: 2)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DeadlineRow(application: app)),
      ),
    );
    expect(find.textContaining('Acme'), findsOneWidget);
    expect(find.textContaining('In 2 days'), findsOneWidget);
  });

  testWidgets('overdue shows a warning icon', (tester) async {
    final app = Application(
      company: 'Acme',
      role: 'Dev',
      deadline: DateTime(2020, 1, 1),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DeadlineRow(application: app)),
      ),
    );
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });
}
