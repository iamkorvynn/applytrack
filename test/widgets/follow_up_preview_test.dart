import 'package:applytrack/models/application.dart';
import 'package:applytrack/widgets/follow_up_preview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows nothing when the list is empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FollowUpPreview(applications: [])),
      ),
    );
    expect(find.text('Needs a follow-up'), findsNothing);
  });

  testWidgets('lists applications needing a nudge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FollowUpPreview(
            applications: [
              Application(
                company: 'Acme',
                role: 'Dev',
                dateApplied: DateTime(2026, 11, 10),
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Needs a follow-up'), findsOneWidget);
    expect(find.textContaining('Acme'), findsOneWidget);
  });
}
