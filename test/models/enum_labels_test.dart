import 'package:applytrack/models/job_type.dart';
import 'package:applytrack/models/salary_period.dart';
import 'package:applytrack/models/source.dart';
import 'package:applytrack/models/work_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('job type labels', () {
    expect(JobType.fullTime.label, 'Full-time');
    expect(JobType.internship.label, 'Internship');
    expect(JobType.partTime.label, 'Part-time');
  });

  test('work mode labels', () {
    expect(WorkMode.onsite.label, 'On-site');
    expect(WorkMode.hybrid.label, 'Hybrid');
    expect(WorkMode.remote.label, 'Remote');
  });

  test('source labels', () {
    expect(ApplicationSource.linkedin.label, 'LinkedIn');
    expect(ApplicationSource.naukri.label, 'Naukri');
    expect(ApplicationSource.companySite.label, 'Company site');
    expect(ApplicationSource.other.label, 'Other');
  });

  test('salary period labels and yearly conversion', () {
    expect(SalaryPeriod.monthly.label, 'per month');
    expect(SalaryPeriod.yearly.label, 'per year');
    expect(SalaryPeriod.monthly.shortLabel, '/mo');
    expect(SalaryPeriod.yearly.shortLabel, '/yr');
    expect(SalaryPeriod.monthly.toYearly(25000), 300000);
    expect(SalaryPeriod.yearly.toYearly(600000), 600000);
  });
}
