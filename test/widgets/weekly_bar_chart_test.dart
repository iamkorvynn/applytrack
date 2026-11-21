import 'package:applytrack/models/app_stats.dart';
import 'package:applytrack/widgets/weekly_bar_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows a bar per week with counts', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeeklyBarChart(
            weeks: [
              WeeklyCount(weekStart: DateTime(2026, 11, 9), count: 2),
              WeeklyCount(weekStart: DateTime(2026, 11, 16), count: 5),
            ],
          ),
        ),
      ),
    );
    expect(find.text('2'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('empty weeks show a friendly message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: WeeklyBarChart(weeks: [])),
      ),
    );
    expect(find.text('No applications yet.'), findsOneWidget);
  });
}
