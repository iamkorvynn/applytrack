import 'package:applytrack/models/deadline_bucket.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every bucket has a label', () {
    expect(DeadlineBucket.overdue.label, 'Overdue');
    expect(DeadlineBucket.today.label, 'Today');
    expect(DeadlineBucket.thisWeek.label, 'This week');
    expect(DeadlineBucket.later.label, 'Later');
    expect(DeadlineBucket.none.label, 'No deadline');
    expect(DeadlineBucket.values.length, 5);
  });
}
