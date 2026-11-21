import 'package:applytrack/models/interview_round.dart';
import 'package:applytrack/services/prep_templates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every round type has at least 3 prep tasks', () {
    for (final type in RoundType.values) {
      final titles = PrepTemplates.titlesFor(type);
      expect(titles.length, greaterThanOrEqualTo(3), reason: type.label);
    }
  });

  test('technical prep mentions coding practice', () {
    final titles = PrepTemplates.titlesFor(RoundType.technical);
    expect(
      titles.any((title) => title.toLowerCase().contains('coding')),
      isTrue,
    );
  });

  test('returned lists are copies, not the shared template', () {
    final first = PrepTemplates.titlesFor(RoundType.hr);
    first.add('hacked');
    expect(PrepTemplates.titlesFor(RoundType.hr), isNot(contains('hacked')));
  });
}
