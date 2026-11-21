import 'package:applytrack/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('company requires at least 2 characters', () {
    expect(Validators.company(null), isNotNull);
    expect(Validators.company(''), isNotNull);
    expect(Validators.company('A'), isNotNull);
    expect(Validators.company('Acme'), isNull);
  });

  test('role requires a value', () {
    expect(Validators.role(''), isNotNull);
    expect(Validators.role('Designer'), isNull);
  });

  test('email is optional but must look like an email', () {
    expect(Validators.email(''), isNull);
    expect(Validators.email(null), isNull);
    expect(Validators.email('not-an-email'), isNotNull);
    expect(Validators.email('a@b.com'), isNull);
  });

  test('jobUrl is optional but must be http(s) with a host', () {
    expect(Validators.jobUrl(''), isNull);
    expect(Validators.jobUrl('https://example.com/jobs'), isNull);
    expect(Validators.jobUrl('example.com'), isNotNull);
    expect(Validators.jobUrl('ftp://example.com'), isNotNull);
  });

  test('salaryRange rejects min above max and junk numbers', () {
    expect(Validators.salaryRange('60000', '40000'), isNotNull);
    expect(Validators.salaryRange('abc', '40000'), isNotNull);
    expect(Validators.salaryRange('40000', '60000'), isNull);
    expect(Validators.salaryRange('', ''), isNull);
    expect(Validators.salaryRange('40000', ''), isNull);
  });
}
