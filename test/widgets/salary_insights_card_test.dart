import 'package:applytrack/models/application.dart';
import 'package:applytrack/widgets/salary_insights_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows median pay when salaries exist', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SalaryInsightsCard(
            applications: [
              Application(company: 'A', role: 'D', salaryMax: 50000),
              Application(company: 'B', role: 'D', salaryMax: 70000),
            ],
          ),
        ),
      ),
    );
    expect(find.textContaining('Median top pay'), findsOneWidget);
    expect(find.textContaining('Range:'), findsOneWidget);
  });

  testWidgets('shows a helpful message without salaries', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SalaryInsightsCard(applications: []),
        ),
      ),
    );
    expect(find.textContaining('Add salaries'), findsOneWidget);
  });
}
