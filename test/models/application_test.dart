import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/models/job_type.dart';
import 'package:applytrack/models/salary_period.dart';
import 'package:applytrack/models/source.dart';
import 'package:applytrack/models/work_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Application sample({ApplicationStatus status = ApplicationStatus.applied}) {
    return Application(
      company: 'Acme Corp',
      role: 'Flutter Developer',
      jobType: JobType.fullTime,
      workMode: WorkMode.hybrid,
      city: 'Bengaluru',
      salaryMin: 40000,
      salaryMax: 60000,
      salaryPeriod: SalaryPeriod.monthly,
      jobUrl: 'https://example.com/jobs/1',
      source: ApplicationSource.linkedin,
      dateApplied: DateTime(2026, 11, 10),
      deadline: DateTime(2026, 11, 30),
      status: status,
    );
  }

  test('defaults are wishlist and full-time onsite', () {
    final app = Application(company: 'X', role: 'Y');
    expect(app.status, ApplicationStatus.wishlist);
    expect(app.jobType, JobType.fullTime);
    expect(app.workMode, WorkMode.onsite);
    expect(app.hasSalary, isFalse);
  });

  test('displayLocation combines city and mode', () {
    expect(sample().displayLocation, 'Bengaluru \u00b7 Hybrid');
    final remote = sample().copyWith(workMode: WorkMode.remote);
    expect(remote.displayLocation, 'Remote');
  });

  test('daysUntilDeadline counts calendar days', () {
    final app = sample();
    expect(
      app.daysUntilDeadline(now: DateTime(2026, 11, 25)),
      5,
    );
    expect(
      app.daysUntilDeadline(now: DateTime(2026, 12, 2)),
      -2,
    );
  });

  test('overdue only when deadline passed and not terminal', () {
    final app = sample();
    expect(app.isDeadlineOverdue(now: DateTime(2026, 12, 2)), isTrue);
    final rejected = sample(status: ApplicationStatus.rejected);
    expect(rejected.isDeadlineOverdue(now: DateTime(2026, 12, 2)), isFalse);
  });

  test('follow-up due when date arrived and not terminal', () {
    final app = sample().copyWith(
      followUpDate: DateTime(2026, 11, 20),
    );
    expect(app.isFollowUpDue(now: DateTime(2026, 11, 20)), isTrue);
    expect(app.isFollowUpDue(now: DateTime(2026, 11, 19)), isFalse);
  });

  test('toMap/fromMap round trip keeps every field', () {
    final app = sample();
    final restored = Application.fromMap(app.toMap());
    expect(restored.company, 'Acme Corp');
    expect(restored.role, 'Flutter Developer');
    expect(restored.salaryMin, 40000);
    expect(restored.salaryMax, 60000);
    expect(restored.status, ApplicationStatus.applied);
    expect(restored.source, ApplicationSource.linkedin);
    expect(restored.deadline, DateTime(2026, 11, 30));
  });

  test('fromMap falls back on unknown enum names', () {
    final map = sample().toMap();
    map['status'] = 'nope';
    map['job_type'] = 'nope';
    final restored = Application.fromMap(map);
    expect(restored.status, ApplicationStatus.wishlist);
    expect(restored.jobType, JobType.fullTime);
  });

  test('copyWith changes only given fields', () {
    final app = sample();
    final next = app.copyWith(status: ApplicationStatus.offer);
    expect(next.status, ApplicationStatus.offer);
    expect(next.company, 'Acme Corp');
    expect(next.id, app.id);
  });
}
