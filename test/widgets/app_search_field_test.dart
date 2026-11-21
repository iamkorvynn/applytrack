import 'package:applytrack/widgets/app_search_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('typing calls onChanged', (tester) async {
    var seen = '';
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchField(
            controller: controller,
            onChanged: (value) => seen = value,
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Acme');
    expect(seen, 'Acme');
  });
}
