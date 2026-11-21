import 'package:applytrack/models/application.dart';
import 'package:applytrack/widgets/salary_text.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows formatted salary range', (tester) async {
    final app = Application(
      company: 'Acme',
      role: 'Dev',
      salaryMin: 40000,
      salaryMax: 60000,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SalaryText(application: app)),
      ),
    );
    expect(find.textContaining('40,000'), findsOneWidget);
    expect(find.textContaining('60,000'), findsOneWidget);
  });

  testWidgets('renders nothing when no salary is set', (tester) async {
    final app = Application(company: 'Acme', role: 'Dev');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SalaryText(application: app)),
      ),
    );
    expect(find.byType(Text), findsNothing);
  });
}
