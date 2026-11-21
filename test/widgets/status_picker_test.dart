import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/widgets/status_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows the current status', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusPicker(
            value: ApplicationStatus.interview,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(find.text('Interview'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
  });
}
