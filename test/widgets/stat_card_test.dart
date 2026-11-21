import 'package:applytrack/widgets/stat_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows label and value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatCard(label: 'Applied', value: '12', icon: Icons.send),
        ),
      ),
    );
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Applied'), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
  });
}
