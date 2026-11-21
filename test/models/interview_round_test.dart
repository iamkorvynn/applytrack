import 'package:applytrack/models/interview_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('round type labels', () {
    expect(RoundType.hr.label, 'HR round');
    expect(RoundType.technical.label, 'Technical round');
    expect(RoundType.finalRound.label, 'Final round');
  });

  test('outcome labels', () {
    expect(RoundOutcome.scheduled.label, 'Scheduled');
    expect(RoundOutcome.cleared.label, 'Cleared');
  });

  test('isDone for completed, cleared and rejected', () {
    expect(
      InterviewRound(applicationId: 1, outcome: RoundOutcome.completed)
          .isDone,
      isTrue,
    );
    expect(
      InterviewRound(applicationId: 1, outcome: RoundOutcome.cleared).isDone,
      isTrue,
    );
    expect(
      InterviewRound(applicationId: 1, outcome: RoundOutcome.scheduled)
          .isDone,
      isFalse,
    );
  });

  test('toMap/fromMap round trip', () {
    final round = InterviewRound(
      applicationId: 7,
      type: RoundType.technical,
      scheduledAt: DateTime(2026, 11, 25, 10, 30),
      notes: 'Bring laptop',
      outcome: RoundOutcome.scheduled,
    );
    final restored = InterviewRound.fromMap(round.toMap());
    expect(restored.applicationId, 7);
    expect(restored.type, RoundType.technical);
    expect(restored.notes, 'Bring laptop');
    expect(restored.scheduledAt, DateTime(2026, 11, 25, 10, 30));
  });

  test('fromMap falls back on unknown type', () {
    final map = InterviewRound(applicationId: 1).toMap();
    map['type'] = 'mystery';
    expect(InterviewRound.fromMap(map).type, RoundType.hr);
  });
}
