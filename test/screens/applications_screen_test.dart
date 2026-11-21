import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/screens/applications_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  List<Application> apps() {
    return [
      Application(
        company: 'Acme',
        role: 'Flutter Dev',
        status: ApplicationStatus.applied,
      ),
      Application(
        company: 'Beta',
        role: 'Designer',
        status: ApplicationStatus.interview,
      ),
    ];
  }

  testWidgets('lists all applications', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ApplicationsScreen(applications: apps())),
      ),
    );
    expect(find.text('Flutter Dev'), findsOneWidget);
    expect(find.text('Designer'), findsOneWidget);
    expect(find.text('2 application(s)'), findsOneWidget);
  });

  testWidgets('search narrows the list', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ApplicationsScreen(applications: apps())),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Acme');
    await tester.pump();
    expect(find.text('Flutter Dev'), findsOneWidget);
    expect(find.text('Designer'), findsNothing);
    expect(find.text('1 application(s)'), findsOneWidget);
  });

  testWidgets('empty list shows the empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ApplicationsScreen(applications: [])),
      ),
    );
    expect(find.text('No applications yet'), findsOneWidget);
  });
}
