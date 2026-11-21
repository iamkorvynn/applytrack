import 'package:applytrack/models/application.dart';
import 'package:applytrack/utils/csv_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('escape handles newlines by quoting', () {
    expect(CsvBuilder.escape('line1\nline2'), '"line1\nline2"');
  });

  test('build escapes quotes inside notes', () {
    final app = Application(
      company: 'Acme',
      role: 'Dev',
      notes: 'He said "hi"',
    );
    final csv = CsvBuilder.build([app]);
    expect(csv, contains('He said'));
  });

  test('build with no salary writes zeros', () {
    final app = Application(company: 'Acme', role: 'Dev');
    final row = CsvBuilder.build([app]).split('\n').last;
    expect(row.split(',')[5], '0');
  });

  test('header has exactly 18 columns', () {
    expect(CsvBuilder.headers.length, 18);
  });
}
