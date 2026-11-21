import 'package:applytrack/models/app_stats.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty stats are all zero', () {
    final stats = AppStats.empty();
    expect(stats.total, 0);
    expect(stats.interviews, 0);
    expect(stats.offers, 0);
    expect(stats.responseRate, 0);
    expect(stats.weeklyCounts, isEmpty);
    expect(stats.topSources, isEmpty);
  });

  test('countFor returns zero for missing status', () {
    final stats = AppStats.empty();
    expect(stats.countFor(ApplicationStatus.offer), 0);
  });

  test('weekly count holds week start and count', () {
    final week = WeeklyCount(weekStart: DateTime(2026, 11, 16), count: 4);
    expect(week.count, 4);
    expect(week.weekStart.weekday, DateTime.monday);
  });
}
