import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/utils/csv_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Application app({String company = 'Acme', String notes = ''}) {
    return Application(
      company: company,
      role: 'Developer',
      salaryMin: 40000,
      salaryMax: 60000,
      status: ApplicationStatus.applied,
      dateApplied: DateTime(2026, 11, 10),
      notes: notes,
    );
  }

  test('header row lists all columns', () {
    final csv = CsvBuilder.build([]);
    expect(csv.split('\n').first, contains('Company'));
    expect(csv.split('\n').first, contains('Status'));
    expect(csv.split('\n').first, contains('Deadline'));
  });

  test('one row per application with dates as yyyy-MM-dd', () {
    final csv = CsvBuilder.build([app()]);
    final lines = csv.split('\n');
    expect(lines.length, 2);
    expect(lines[1], contains('Acme'));
    expect(lines[1], contains('2026-11-10'));
    expect(lines[1], contains('Applied'));
  });

  test('fields with commas and quotes are escaped', () {
    expect(CsvBuilder.escape('a,b'), '"a,b"');
    expect(CsvBuilder.escape('say "hi"'), contains('""hi""'));
    expect(CsvBuilder.escape('plain'), 'plain');
    final csv = CsvBuilder.build([app(notes: 'met, the team')]);
    expect(csv, contains('"met, the team"'));
  });

  test('summary counts applications', () {
    expect(CsvBuilder.summary([]), contains('No applications'));
    expect(CsvBuilder.summary([app(), app()]), contains('2 application'));
  });
}
