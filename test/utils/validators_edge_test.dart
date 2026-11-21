import 'package:applytrack/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('company trims whitespace before checking length', () {
    expect(Validators.company('  A  '), isNotNull);
    expect(Validators.company('  Acme  '), isNull);
  });

  test('jobUrl rejects urls without a dot in host', () {
    expect(Validators.jobUrl('https://localhost/jobs'), isNotNull);
    expect(Validators.jobUrl('https://jobs.example.co.in/1'), isNull);
  });

  test('salaryRange allows equal min and max', () {
    expect(Validators.salaryRange('50000', '50000'), isNull);
  });

  test('salaryRange accepts k suffixes', () {
    expect(Validators.salaryRange('40k', '60k'), isNull);
    expect(Validators.salaryRange('60k', '40k'), isNotNull);
  });

  test('email rejects missing dot after @', () {
    expect(Validators.email('a@b'), isNotNull);
    expect(Validators.email('a@b.c'), isNull);
  });
}
