import 'application_status.dart';
import 'source.dart';

/// One bar of the "applications per week" chart.
class WeeklyCount {
  WeeklyCount({required this.weekStart, required this.count});

  final DateTime weekStart;
  final int count;
}

/// One row of the "top sources" list.
class SourceCount {
  SourceCount({required this.source, required this.count});

  final ApplicationSource source;
  final int count;
}

/// Everything the stats screen shows, computed from applications.
class AppStats {
  AppStats({
    required this.total,
    required this.byStatus,
    required this.interviews,
    required this.offers,
    required this.responseRate,
    required this.appliedThisWeek,
    required this.weeklyCounts,
    required this.topSources,
  });

  final int total;
  final Map<ApplicationStatus, int> byStatus;
  final int interviews;
  final int offers;
  final double responseRate;
  final int appliedThisWeek;
  final List<WeeklyCount> weeklyCounts;
  final List<SourceCount> topSources;

  int countFor(ApplicationStatus status) => byStatus[status] ?? 0;

  factory AppStats.empty() {
    return AppStats(
      total: 0,
      byStatus: {},
      interviews: 0,
      offers: 0,
      responseRate: 0,
      appliedThisWeek: 0,
      weeklyCounts: [],
      topSources: [],
    );
  }
}
