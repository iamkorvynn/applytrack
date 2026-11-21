import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/interview_round.dart';
import 'package:applytrack/services/response_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('average days from applying to first round', () {
    final apps = [
      Application(
        id: 1,
        company: 'A',
        role: 'D',
        dateApplied: DateTime(2026, 11, 10),
      ),
      Application(
        id: 2,
        company: 'B',
        role: 'D',
        dateApplied: DateTime(2026, 11, 10),
      ),
    ];
    final rounds = [
      InterviewRound(
        applicationId: 1,
        scheduledAt: DateTime(2026, 11, 15),
      ),
      InterviewRound(
        applicationId: 2,
        scheduledAt: DateTime(2026, 11, 13),
      ),
    ];
    expect(
      ResponseTime.averageDaysToFirstRound(apps, rounds),
      4.0,
    );
  });

  test('null when no rounds have dates', () {
    final apps = [
      Application(id: 1, company: 'A', role: 'D'),
    ];
    expect(ResponseTime.averageDaysToFirstRound(apps, []), isNull);
    expect(
      ResponseTime.averageDaysToFirstRound(
        apps,
        [InterviewRound(applicationId: 1)],
      ),
      isNull,
    );
  });

  test('appsWithRounds counts distinct applications', () {
    final apps = [
      Application(id: 1, company: 'A', role: 'D'),
      Application(id: 2, company: 'B', role: 'D'),
    ];
    final rounds = [
      InterviewRound(applicationId: 1),
      InterviewRound(applicationId: 1),
    ];
    expect(ResponseTime.appsWithRounds(apps, rounds), 1);
  });
}
