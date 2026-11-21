import 'package:intl/intl.dart';

import 'app_dates.dart';

/// Human date strings used across screens.
class Formatters {
  static final DateFormat _dayMonthYear = DateFormat('d MMM yyyy');
  static final DateFormat _dayMonth = DateFormat('d MMM');
  static final DateFormat _full = DateFormat('EEE, d MMM yyyy');
  static final DateFormat _time = DateFormat('h:mm a');

  static String date(DateTime? value) =>
      value == null ? 'Not set' : _dayMonthYear.format(value);

  static String shortDate(DateTime? value) =>
      value == null ? '—' : _dayMonth.format(value);

  static String fullDate(DateTime? value) =>
      value == null ? 'Not set' : _full.format(value);

  static String dateTime(DateTime? value) {
    if (value == null) return 'Not set';
    return '${_dayMonthYear.format(value)} · ${_time.format(value)}';
  }

  /// "Today", "Tomorrow", "In 5 days", "3 days ago", "12 Jan 2026".
  static String relativeDay(DateTime date, {DateTime? now}) {
    final days = AppDates.daysBetween(now ?? DateTime.now(), date);
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    if (days == -1) return 'Yesterday';
    if (days > 1) return 'In $days days';
    return '${-days} days ago';
  }
}
