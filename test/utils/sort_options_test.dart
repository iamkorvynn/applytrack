import 'package:applytrack/models/application.dart';
import 'package:applytrack/utils/sort_options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Application app({
    String company = 'Acme',
    DateTime? deadline,
    DateTime? applied,
    int max = 0,
  }) {
    return Application(
      company: company,
      role: 'Dev',
      deadline: deadline,
      dateApplied: applied,
      salaryMax: max,
    );
  }

  test('deadlineAsc puts soonest first and no-deadline last', () {
    final list = [
      app(company: 'NoDeadline'),
      app(company: 'Late', deadline: DateTime(2026, 12, 1)),
      app(company: 'Soon', deadline: DateTime(2026, 11, 22)),
    ];
    list.sort(SortOption.deadlineAsc.compare);
    expect(list.map((a) => a.company).toList(), ['Soon', 'Late', 'NoDeadline']);
  });

  test('dateAppliedDesc puts newest first', () {
    final list = [
      app(company: 'Old', applied: DateTime(2026, 11, 1)),
      app(company: 'New', applied: DateTime(2026, 11, 20)),
    ];
    list.sort(SortOption.dateAppliedDesc.compare);
    expect(list.first.company, 'New');
  });

  test('salaryDesc puts highest max first', () {
    final list = [app(company: 'Low', max: 30000), app(company: 'High', max: 90000)];
    list.sort(SortOption.salaryDesc.compare);
    expect(list.first.company, 'High');
  });

  test('companyAsc is case-insensitive alphabetical', () {
    final list = [app(company: 'Zebra'), app(company: 'apple')];
    list.sort(SortOption.companyAsc.compare);
    expect(list.first.company, 'apple');
  });

  test('labels are human readable', () {
    expect(SortOption.deadlineAsc.label, contains('Deadline'));
    expect(SortOption.salaryDesc.label, contains('Salary'));
  });
}
