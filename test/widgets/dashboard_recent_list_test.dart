import 'package:applytrack/models/application.dart';
import 'package:applytrack/widgets/dashboard_recent_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows nothing when the list is empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DashboardRecentList(applications: []),
        ),
      ),
    );
    expect(find.text('Recent applications'), findsNothing);
  });

  testWidgets('shows recent applications', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardRecentList(
            applications: [
              Application(company: 'Acme', role: 'Flutter Dev'),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Recent applications'), findsOneWidget);
    expect(find.text('Flutter Dev'), findsOneWidget);
  });
}
