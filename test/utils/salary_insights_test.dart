import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/salary_period.dart';
import 'package:applytrack/utils/salary_insights.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Application app({int max = 0, SalaryPeriod period = SalaryPeriod.monthly}) {
    return Application(
      company: 'Acme',
      role: 'Dev',
      salaryMax: max,
      salaryPeriod: period,
    );
  }

  test('median of monthly max salaries converted to yearly', () {
    final median = SalaryInsights.medianAnnual([
      app(max: 40000),
      app(max: 60000),
      app(max: 50000),
    ]);
    expect(median, 600000);
  });

  test('median of an even list averages the middle two', () {
    final median = SalaryInsights.medianAnnual([
      app(max: 40000),
      app(max: 60000),
    ]);
    expect(median, 600000);
  });

  test('yearly salaries are not multiplied', () {
    expect(
      SalaryInsights.medianAnnual([app(max: 1200000, period: SalaryPeriod.yearly)]),
      1200000,
    );
  });

  test('no salaries gives nulls and a helpful summary', () {
    expect(SalaryInsights.medianAnnual([app()]), isNull);
    expect(SalaryInsights.minAnnual([app()]), isNull);
    expect(SalaryInsights.maxAnnual([app()]), isNull);
    expect(
      SalaryInsights.summary([app()]),
      contains('Add salaries'),
    );
  });

  test('min and max pick the extremes', () {
    final apps = [app(max: 30000), app(max: 90000), app(max: 50000)];
    expect(SalaryInsights.minAnnual(apps), 360000);
    expect(SalaryInsights.maxAnnual(apps), 1080000);
  });
}
