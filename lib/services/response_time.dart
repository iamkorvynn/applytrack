import '../models/application.dart';
import '../models/interview_round.dart';
import '../utils/app_dates.dart';

/// How fast applications turn into interviews.
class ResponseTime {
  /// Average days from applying to the first scheduled interview round.
  /// Null when no application has a round with a date.
  static double? averageDaysToFirstRound(
    List<Application> apps,
    List<InterviewRound> rounds, {
    DateTime? now,
  }) {
    final byApp = <int, Application>{};
    for (final app in apps) {
      if (app.id != null) byApp[app.id!] = app;
    }
    final days = <int>[];
    for (final round in rounds) {
      final app = byApp[round.applicationId];
      if (app == null) continue;
      final applied = app.dateApplied ?? app.createdAt;
      final scheduled = round.scheduledAt;
      if (scheduled == null) continue;
      days.add(AppDates.daysBetween(applied, scheduled));
    }
    if (days.isEmpty) return null;
    var total = 0;
    for (final day in days) {
      total += day;
    }
    return total / days.length;
  }

  /// Applications that already have at least one interview round.
  static int appsWithRounds(
    List<Application> apps,
    List<InterviewRound> rounds,
  ) {
    final ids = rounds.map((round) => round.applicationId).toSet();
    return apps.where((app) => ids.contains(app.id)).length;
  }
}
