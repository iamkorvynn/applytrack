import 'package:applytrack/models/application.dart';
import 'package:applytrack/utils/csv_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('csv has a days-since-applied column', () {
    expect(CsvBuilder.headers, contains('Days since applied'));
    expect(CsvBuilder.headers.length, 18);
  });

  test('days since applied is empty when never applied', () {
    final app = Application(company: 'Acme', role: 'Dev');
    final row = CsvBuilder.build([app]).split('\n').last;
    final values = row.split(',');
    expect(values.last, '');
  });
}
