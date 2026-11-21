import '../models/app_stats.dart';
import '../models/application.dart';
import '../models/application_status.dart';
import '../models/source.dart';
import '../utils/app_dates.dart';
import '../utils/constants.dart';

/// Pure stats maths: no database, no widgets, easy to test.
class StatsService {
  static AppStats compute(List<Application> apps, {DateTime? now}) {
    final current = now ?? DateTime.now();
    if (apps.isEmpty) return AppStats.empty();

    final byStatus = <ApplicationStatus, int>{};
    for (final status in ApplicationStatus.values) {
      byStatus[status] = 0;
    }
    var interviews = 0;
    var offers = 0;
    var responded = 0;
    var appliedThisWeek = 0;
    final weekStart = AppDates.weekStart(current);
    final weekCounts = <DateTime, int>{};
    for (final start in AppDates.lastWeekStarts(
      count: AppConstants.statsWeeks,
      now: current,
    )) {
      weekCounts[start] = 0;
    }
    final sourceCounts = <ApplicationSource, int>{};

    for (final app in apps) {
      byStatus[app.status] = (byStatus[app.status] ?? 0) + 1;
      if (app.status.reachedInterview) interviews++;
      if (app.status == ApplicationStatus.offer) offers++;
      if (app.status != ApplicationStatus.wishlist &&
          app.status != ApplicationStatus.applied) {
        responded++;
      }
      final applied = app.dateApplied ?? app.createdAt;
      if (!applied.isBefore(weekStart)) appliedThisWeek++;
      final start = AppDates.weekStart(applied);
      if (weekCounts.containsKey(start)) {
        weekCounts[start] = weekCounts[start]! + 1;
      }
      sourceCounts[app.source] = (sourceCounts[app.source] ?? 0) + 1;
    }

    final respondedBase =
        apps.where((a) => a.status != ApplicationStatus.wishlist).length;
    final responseRate =
        respondedBase == 0 ? 0.0 : responded / respondedBase;

    final weekly = weekCounts.entries
        .map((e) => WeeklyCount(weekStart: e.key, count: e.value))
        .toList()
      ..sort((a, b) => a.weekStart.compareTo(b.weekStart));

    final sources = sourceCounts.entries
        .map((e) => SourceCount(source: e.key, count: e.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    return AppStats(
      total: apps.length,
      byStatus: byStatus,
      interviews: interviews,
      offers: offers,
      responseRate: responseRate,
      appliedThisWeek: appliedThisWeek,
      weeklyCounts: weekly,
      topSources: sources,
    );
  }
}
