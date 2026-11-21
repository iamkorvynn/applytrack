import 'package:applytrack/models/interview_round.dart';
import 'package:applytrack/services/next_interview.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 21, 12);

  test('picks the soonest future scheduled round', () {
    final rounds = [
      InterviewRound(
        applicationId: 1,
        scheduledAt: DateTime(2026, 11, 25, 10),
      ),
      InterviewRound(
        applicationId: 2,
        scheduledAt: DateTime(2026, 11, 22, 10),
      ),
      InterviewRound(
        applicationId: 3,
        scheduledAt: DateTime(2026, 11, 20, 10),
      ),
    ];
    final next = NextInterview.next(rounds, now: now);
    expect(next?.applicationId, 2);
  });

  test('skips rounds that are done or rejected', () {
    final rounds = [
      InterviewRound(
        applicationId: 1,
        scheduledAt: DateTime(2026, 11, 22, 10),
        outcome: RoundOutcome.cleared,
      ),
      InterviewRound(
        applicationId: 2,
        scheduledAt: DateTime(2026, 11, 23, 10),
      ),
    ];
    expect(NextInterview.next(rounds, now: now)?.applicationId, 2);
  });

  test('null when nothing is upcoming', () {
    expect(NextInterview.next([], now: now), isNull);
    expect(
      NextInterview.next(
        [InterviewRound(applicationId: 1)],
        now: now,
      ),
      isNull,
    );
  });

  test('nextForApplication filters by application', () {
    final rounds = [
      InterviewRound(
        applicationId: 1,
        scheduledAt: DateTime(2026, 11, 22, 10),
      ),
      InterviewRound(
        applicationId: 2,
        scheduledAt: DateTime(2026, 11, 21, 15),
      ),
    ];
    expect(
      NextInterview.nextForApplication(rounds, 1, now: now)?.applicationId,
      1,
    );
  });
}
