import 'package:applytrack/models/checklist_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to not done', () {
    final item = ChecklistItem(applicationId: 1, title: 'Revise DSA');
    expect(item.isDone, isFalse);
    expect(item.sortOrder, 0);
  });

  test('copyWith toggles done', () {
    final item = ChecklistItem(applicationId: 1, title: 'Revise DSA');
    expect(item.copyWith(isDone: true).isDone, isTrue);
    expect(item.copyWith(title: 'Other').title, 'Other');
  });

  test('toMap/fromMap round trip keeps done flag', () {
    final item = ChecklistItem(
      applicationId: 3,
      title: 'Prep intro',
      isDone: true,
      sortOrder: 2,
    );
    final restored = ChecklistItem.fromMap(item.toMap());
    expect(restored.isDone, isTrue);
    expect(restored.sortOrder, 2);
    expect(restored.title, 'Prep intro');
  });
}
