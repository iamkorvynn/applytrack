import 'package:applytrack/utils/app_dates.dart';
import 'package:applytrack/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('daysBetween across month boundary', () {
    expect(
      AppDates.daysBetween(DateTime(2026, 10, 31), DateTime(2026, 11, 2)),
      2,
    );
  });

  test('weekStart on a Sunday goes back to Monday', () {
    expect(AppDates.weekStart(DateTime(2026, 11, 22)), DateTime(2026, 11, 16));
  });

  test('relativeDay far future shows the date count', () {
    final now = DateTime(2026, 11, 21);
    expect(
      Formatters.relativeDay(DateTime(2026, 12, 21), now: now),
      'In 30 days',
    );
    expect(
      Formatters.relativeDay(DateTime(2026, 10, 21), now: now),
      '31 days ago',
    );
  });

  test('shortDate shows day and month only', () {
    expect(Formatters.shortDate(DateTime(2026, 11, 21)), '21 Nov');
    expect(Formatters.shortDate(null), '\u2014');
  });
}
