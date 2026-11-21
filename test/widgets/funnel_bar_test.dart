import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/widgets/funnel_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows status label and count', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FunnelBar(
            status: ApplicationStatus.interview,
            count: 3,
            total: 10,
          ),
        ),
      ),
    );
    expect(find.text('Interview'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('zero total does not crash', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FunnelBar(
            status: ApplicationStatus.offer,
            count: 0,
            total: 0,
          ),
        ),
      ),
    );
    expect(find.text('0'), findsOneWidget);
  });
}
