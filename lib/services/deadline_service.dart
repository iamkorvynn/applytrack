import '../models/application.dart';
import '../models/application_status.dart';
import '../models/deadline_bucket.dart';
import '../utils/app_dates.dart';

/// Pure deadline grouping and upcoming-deadline lists.
class DeadlineService {
  /// Applications with a deadline in the next [days] days, soonest first.
  /// Overdue ones are included at the front.
  static List<Application> upcoming(
    List<Application> apps, {
    DateTime? now,
    int days = 7,
  }) {
    final current = now ?? DateTime.now();
    final list = apps.where((app) {
      if (app.deadline == null) return false;
      if (app.status.isTerminal) return false;
      final diff = AppDates.daysBetween(current, app.deadline!);
      return diff <= days;
    }).toList();
    list.sort((a, b) {
      final ad = a.deadline!;
      final bd = b.deadline!;
      return ad.compareTo(bd);
    });
    return list;
  }

  static DeadlineBucket bucketFor(Application app, {DateTime? now}) {
    if (app.deadline == null) return DeadlineBucket.none;
    final current = now ?? DateTime.now();
    final days = AppDates.daysBetween(current, app.deadline!);
    if (days < 0) return DeadlineBucket.overdue;
    if (days == 0) return DeadlineBucket.today;
    if (days <= 7) return DeadlineBucket.thisWeek;
    return DeadlineBucket.later;
  }

  static Map<DeadlineBucket, List<Application>> group(
    List<Application> apps, {
    DateTime? now,
  }) {
    final grouped = <DeadlineBucket, List<Application>>{
      DeadlineBucket.overdue: [],
      DeadlineBucket.today: [],
      DeadlineBucket.thisWeek: [],
      DeadlineBucket.later: [],
      DeadlineBucket.none: [],
    };
    for (final app in apps) {
      if (app.status.isTerminal) continue;
      grouped[bucketFor(app, now: now)]!.add(app);
    }
    for (final list in grouped.values) {
      list.sort((a, b) {
        final ad = a.deadline;
        final bd = b.deadline;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return ad.compareTo(bd);
      });
    }
    return grouped;
  }
}
