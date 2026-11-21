import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/models/source.dart';
import 'package:applytrack/services/stats_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 21, 12);

  Application app({
    ApplicationStatus status = ApplicationStatus.applied,
    DateTime? applied,
    ApplicationSource source = ApplicationSource.linkedin,
  }) {
    return Application(
      company: 'Acme',
      role: 'Dev',
      status: status,
      dateApplied: applied,
      source: source,
    );
  }

  test('empty list gives empty stats', () {
    final stats = StatsService.compute([], now: now);
    expect(stats.total, 0);
    expect(stats.responseRate, 0);
  });

  test('counts by status and totals', () {
    final stats = StatsService.compute(
      [
        app(status: ApplicationStatus.applied),
        app(status: ApplicationStatus.interview),
        app(status: ApplicationStatus.offer),
        app(status: ApplicationStatus.rejected),
      ],
      now: now,
    );
    expect(stats.total, 4);
    expect(stats.interviews, 2);
    expect(stats.offers, 1);
    expect(stats.countFor(ApplicationStatus.applied), 1);
  });

  test('response rate excludes wishlist from the base', () {
    final stats = StatsService.compute(
      [
        app(status: ApplicationStatus.wishlist),
        app(status: ApplicationStatus.applied),
        app(status: ApplicationStatus.interview),
      ],
      now: now,
    );
    // 1 of 2 non-wishlist apps moved past Applied.
    expect(stats.responseRate, 0.5);
  });

  test('appliedThisWeek counts applications from Monday onwards', () {
    final stats = StatsService.compute(
      [
        app(applied: DateTime(2026, 11, 18)),
        app(applied: DateTime(2026, 11, 2)),
      ],
      now: now,
    );
    expect(stats.appliedThisWeek, 1);
  });

  test('weekly counts cover 8 weeks oldest first', () {
    final stats = StatsService.compute(
      [app(applied: DateTime(2026, 11, 18))],
      now: now,
    );
    expect(stats.weeklyCounts.length, 8);
    expect(stats.weeklyCounts.last.count, 1);
    expect(stats.weeklyCounts.first.count, 0);
  });

  test('top sources are sorted by count descending', () {
    final stats = StatsService.compute(
      [
        app(source: ApplicationSource.naukri),
        app(source: ApplicationSource.naukri),
        app(source: ApplicationSource.linkedin),
      ],
      now: now,
    );
    expect(stats.topSources.first.source, ApplicationSource.naukri);
    expect(stats.topSources.first.count, 2);
  });
}
