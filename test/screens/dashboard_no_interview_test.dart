import 'package:applytrack/models/application.dart';
import 'package:applytrack/screens/dashboard_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('no next-interview card when nothing is scheduled',
      (tester) async {
    final app = Application(company: 'Acme', role: 'Dev');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DashboardScreen(applications: [app])),
      ),
    );
    expect(find.textContaining('Next interview'), findsNothing);
    expect(find.text('Recent applications'), findsOneWidget);
  });
}
