/// Small calendar helpers. All maths is on calendar days, not 24h spans,
/// so "tomorrow" means the next calendar date even late at night.
class AppDates {
  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Whole calendar days from [from] to [to]. Negative when [to] is past.
  static int daysBetween(DateTime from, DateTime to) {
    final a = startOfDay(from);
    final b = startOfDay(to);
    return b.difference(a).inDays;
  }

  /// Monday of the week containing [date].
  static DateTime weekStart(DateTime date) {
    final day = startOfDay(date);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  /// The last [count] week starts, oldest first, ending this week.
  static List<DateTime> lastWeekStarts({int count = 8, DateTime? now}) {
    final current = weekStart(now ?? DateTime.now());
    final starts = <DateTime>[];
    for (var i = count - 1; i >= 0; i--) {
      starts.add(current.subtract(Duration(days: 7 * i)));
    }
    return starts;
  }

  static bool isWithinDays(DateTime date, DateTime now, int days) {
    final diff = daysBetween(now, date);
    return diff >= 0 && diff <= days;
  }
}
