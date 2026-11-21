import '../models/application.dart';
import '../utils/app_dates.dart';

/// Consecutive days with at least one application.
class ApplicationStreak {
  static Set<DateTime> _appliedDays(List<Application> apps) {
    final days = <DateTime>{};
    for (final app in apps) {
      final date = app.dateApplied ?? app.createdAt;
      days.add(AppDates.startOfDay(date));
    }
    return days;
  }

  /// Streak ending today (or yesterday if nothing was applied today).
  static int currentStreak(List<Application> apps, {DateTime? now}) {
    final days = _appliedDays(apps);
    if (days.isEmpty) return 0;
    var cursor = AppDates.startOfDay(now ?? DateTime.now());
    if (!days.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Longest run of consecutive application days ever.
  static int longestStreak(List<Application> apps) {
    final days = _appliedDays(apps);
    if (days.isEmpty) return 0;
    final sorted = days.toList()..sort();
    var longest = 1;
    var current = 1;
    for (var i = 1; i < sorted.length; i++) {
      if (sorted[i].difference(sorted[i - 1]).inDays == 1) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 1;
      }
    }
    return longest;
  }
}
