import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/models/deadline_bucket.dart';
import 'package:applytrack/services/deadline_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 21, 12);

  Application app({DateTime? deadline, ApplicationStatus? status}) {
    return Application(
      company: 'Acme',
      role: 'Dev',
      deadline: deadline,
      status: status ?? ApplicationStatus.applied,
    );
  }

  test('upcoming includes overdue and next 7 days, soonest first', () {
    final list = DeadlineService.upcoming(
      [
        app(deadline: DateTime(2026, 12, 20)),
        app(deadline: DateTime(2026, 11, 20)),
        app(deadline: DateTime(2026, 11, 25)),
        app(deadline: null),
        app(
          deadline: DateTime(2026, 11, 22),
          status: ApplicationStatus.rejected,
        ),
      ],
      now: now,
    );
    expect(list.length, 2);
    expect(list.first.deadline, DateTime(2026, 11, 20));
  });

  test('bucketFor classifies overdue, today, week, later, none', () {
    expect(
      DeadlineService.bucketFor(
        app(deadline: DateTime(2026, 11, 20)),
        now: now,
      ),
      DeadlineBucket.overdue,
    );
    expect(
      DeadlineService.bucketFor(
        app(deadline: DateTime(2026, 11, 21)),
        now: now,
      ),
      DeadlineBucket.today,
    );
    expect(
      DeadlineService.bucketFor(
        app(deadline: DateTime(2026, 11, 27)),
        now: now,
      ),
      DeadlineBucket.thisWeek,
    );
    expect(
      DeadlineService.bucketFor(
        app(deadline: DateTime(2026, 12, 5)),
        now: now,
      ),
      DeadlineBucket.later,
    );
    expect(
      DeadlineService.bucketFor(app(deadline: null), now: now),
      DeadlineBucket.none,
    );
  });

  test('group skips terminal applications', () {
    final grouped = DeadlineService.group(
      [
        app(deadline: DateTime(2026, 11, 20)),
        app(
          deadline: DateTime(2026, 11, 20),
          status: ApplicationStatus.withdrawn,
        ),
      ],
      now: now,
    );
    expect(grouped[DeadlineBucket.overdue]!.length, 1);
  });

  test('bucket labels are readable', () {
    expect(DeadlineBucket.overdue.label, 'Overdue');
    expect(DeadlineBucket.thisWeek.label, 'This week');
  });
}
