import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/services/stats_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 21, 12);

  test('all wishlist gives zero response rate', () {
    final stats = StatsService.compute(
      [Application(company: 'A', role: 'D', status: ApplicationStatus.wishlist)],
      now: now,
    );
    expect(stats.responseRate, 0);
    expect(stats.total, 1);
  });

  test('all responded gives 100 percent', () {
    final stats = StatsService.compute(
      [Application(company: 'A', role: 'D', status: ApplicationStatus.offer)],
      now: now,
    );
    expect(stats.responseRate, 1.0);
  });

  test('weekly counts sum to total for recent applications', () {
    final stats = StatsService.compute(
      [
        Application(
          company: 'A',
          role: 'D',
          dateApplied: DateTime(2026, 11, 18),
        ),
        Application(
          company: 'B',
          role: 'D',
          dateApplied: DateTime(2026, 11, 11),
        ),
      ],
      now: now,
    );
    final sum = stats.weeklyCounts.fold<int>(0, (a, w) => a + w.count);
    expect(sum, 2);
  });
}
