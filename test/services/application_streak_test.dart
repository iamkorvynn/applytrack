import 'package:applytrack/models/application.dart';
import 'package:applytrack/services/application_streak.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 21, 12);

  Application app(DateTime applied) {
    return Application(company: 'A', role: 'D', dateApplied: applied);
  }

  test('current streak counts back from today', () {
    final apps = [
      app(DateTime(2026, 11, 21)),
      app(DateTime(2026, 11, 20)),
      app(DateTime(2026, 11, 19)),
      app(DateTime(2026, 11, 15)),
    ];
    expect(ApplicationStreak.currentStreak(apps, now: now), 3);
  });

  test('streak still counts when today is empty but yesterday is not', () {
    final apps = [
      app(DateTime(2026, 11, 20)),
      app(DateTime(2026, 11, 19)),
    ];
    expect(ApplicationStreak.currentStreak(apps, now: now), 2);
  });

  test('no applications means no streak', () {
    expect(ApplicationStreak.currentStreak([], now: now), 0);
    expect(ApplicationStreak.longestStreak([]), 0);
  });

  test('longest streak finds the best run anywhere', () {
    final apps = [
      app(DateTime(2026, 11, 21)),
      app(DateTime(2026, 11, 10)),
      app(DateTime(2026, 11, 11)),
      app(DateTime(2026, 11, 12)),
      app(DateTime(2026, 11, 13)),
    ];
    expect(ApplicationStreak.longestStreak(apps), 4);
  });
}
