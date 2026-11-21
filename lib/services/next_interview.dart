import '../models/interview_round.dart';

/// The next interview round across all applications.
class NextInterview {
  static InterviewRound? next(List<InterviewRound> rounds, {DateTime? now}) {
    final current = now ?? DateTime.now();
    InterviewRound? best;
    for (final round in rounds) {
      if (round.outcome != RoundOutcome.scheduled) continue;
      final scheduled = round.scheduledAt;
      if (scheduled == null) continue;
      if (!scheduled.isAfter(current)) continue;
      if (best == null ||
          scheduled.isBefore(best.scheduledAt ?? scheduled)) {
        best = round;
      }
    }
    return best;
  }

  static InterviewRound? nextForApplication(
    List<InterviewRound> rounds,
    int applicationId, {
    DateTime? now,
  }) {
    final filtered = rounds
        .where((round) => round.applicationId == applicationId)
        .toList();
    return next(filtered, now: now);
  }
}
