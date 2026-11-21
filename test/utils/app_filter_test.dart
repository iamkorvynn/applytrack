import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/models/job_type.dart';
import 'package:applytrack/models/source.dart';
import 'package:applytrack/utils/app_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<Application> apps() {
    return [
      Application(
        company: 'Acme',
        role: 'Flutter Dev',
        jobType: JobType.internship,
        source: ApplicationSource.linkedin,
        status: ApplicationStatus.applied,
        deadline: DateTime(2026, 11, 25),
      ),
      Application(
        company: 'Beta',
        role: 'Backend Dev',
        jobType: JobType.fullTime,
        source: ApplicationSource.naukri,
        status: ApplicationStatus.interview,
        deadline: DateTime(2026, 11, 22),
      ),
      Application(
        company: 'Gamma',
        role: 'Designer',
        jobType: JobType.fullTime,
        source: ApplicationSource.referral,
        status: ApplicationStatus.wishlist,
      ),
    ];
  }

  test('empty filter returns everything sorted by deadline', () {
    final result = AppFilter().apply(apps());
    expect(result.length, 3);
    expect(result.first.company, 'Beta');
  });

  test('query matches company, role and city case-insensitively', () {
    expect(AppFilter(query: 'acme').apply(apps()).length, 1);
    expect(AppFilter(query: 'DEV').apply(apps()).length, 2);
    expect(AppFilter(query: 'nope').apply(apps()), isEmpty);
  });

  test('status filter keeps only that stage', () {
    final result = AppFilter(
      statuses: {ApplicationStatus.interview},
    ).apply(apps());
    expect(result.map((a) => a.company).toList(), ['Beta']);
  });

  test('type and source filters combine', () {
    final result = AppFilter(
      types: {JobType.fullTime},
      sources: {ApplicationSource.naukri},
    ).apply(apps());
    expect(result.map((a) => a.company).toList(), ['Beta']);
  });

  test('isEmpty is true only with no criteria', () {
    expect(AppFilter().isEmpty, isTrue);
    expect(AppFilter(query: 'x').isEmpty, isFalse);
    expect(
      AppFilter(statuses: {ApplicationStatus.applied}).isEmpty,
      isFalse,
    );
  });
}
