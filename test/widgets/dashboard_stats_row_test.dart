import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/services/stats_service.dart';
import 'package:applytrack/widgets/dashboard_stats_row.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows four headline numbers', (tester) async {
    final stats = StatsService.compute([
      Application(company: 'A', role: 'D', status: ApplicationStatus.interview),
      Application(company: 'B', role: 'D', status: ApplicationStatus.offer),
      Application(company: 'C', role: 'D', status: ApplicationStatus.applied),
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DashboardStatsRow(stats: stats)),
      ),
    );
    expect(find.text('Applied'), findsOneWidget);
    expect(find.text('Interviews'), findsOneWidget);
    expect(find.text('Offers'), findsOneWidget);
    expect(find.text('This week'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });
}
