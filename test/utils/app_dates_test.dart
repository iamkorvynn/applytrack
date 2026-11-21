import 'package:applytrack/utils/app_dates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('daysBetween counts calendar days, not 24h spans', () {
    final from = DateTime(2026, 11, 21, 23, 30);
    final to = DateTime(2026, 11, 22, 0, 30);
    expect(AppDates.daysBetween(from, to), 1);
  });

  test('daysBetween is negative when the date is past', () {
    expect(
      AppDates.daysBetween(DateTime(2026, 11, 25), DateTime(2026, 11, 20)),
      -5,
    );
  });

  test('isSameDay ignores time', () {
    expect(
      AppDates.isSameDay(
        DateTime(2026, 11, 21, 9),
        DateTime(2026, 11, 21, 23),
      ),
      isTrue,
    );
    expect(
      AppDates.isSameDay(DateTime(2026, 11, 21), DateTime(2026, 11, 22)),
      isFalse,
    );
  });

  test('weekStart is the Monday of that week', () {
    // 2026-11-21 is a Saturday.
    expect(AppDates.weekStart(DateTime(2026, 11, 21)), DateTime(2026, 11, 16));
    expect(AppDates.weekStart(DateTime(2026, 11, 16)), DateTime(2026, 11, 16));
  });

  test('lastWeekStarts returns oldest first ending this week', () {
    final starts = AppDates.lastWeekStarts(
      count: 3,
      now: DateTime(2026, 11, 21),
    );
    expect(starts.length, 3);
    expect(starts.last, DateTime(2026, 11, 16));
    expect(starts.first, DateTime(2026, 11, 2));
  });

  test('isWithinDays includes today and the limit', () {
    final now = DateTime(2026, 11, 21);
    expect(AppDates.isWithinDays(DateTime(2026, 11, 21), now, 7), isTrue);
    expect(AppDates.isWithinDays(DateTime(2026, 11, 28), now, 7), isTrue);
    expect(AppDates.isWithinDays(DateTime(2026, 11, 29), now, 7), isFalse);
    expect(AppDates.isWithinDays(DateTime(2026, 11, 20), now, 7), isFalse);
  });
}
