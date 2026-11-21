import 'package:applytrack/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('date formats as d MMM yyyy', () {
    expect(Formatters.date(DateTime(2026, 11, 21)), '21 Nov 2026');
    expect(Formatters.date(null), 'Not set');
  });

  test('relativeDay names today, tomorrow, yesterday', () {
    final now = DateTime(2026, 11, 21, 12);
    expect(Formatters.relativeDay(DateTime(2026, 11, 21), now: now), 'Today');
    expect(
      Formatters.relativeDay(DateTime(2026, 11, 22), now: now),
      'Tomorrow',
    );
    expect(
      Formatters.relativeDay(DateTime(2026, 11, 20), now: now),
      'Yesterday',
    );
    expect(
      Formatters.relativeDay(DateTime(2026, 11, 26), now: now),
      'In 5 days',
    );
    expect(
      Formatters.relativeDay(DateTime(2026, 11, 18), now: now),
      '3 days ago',
    );
  });

  test('dateTime combines date and time', () {
    expect(
      Formatters.dateTime(DateTime(2026, 11, 21, 10, 30)),
      contains('21 Nov 2026'),
    );
    expect(Formatters.dateTime(null), 'Not set');
  });
}
