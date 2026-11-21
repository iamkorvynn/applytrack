import 'package:applytrack/utils/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatINR groups Indian style', () {
    expect(Money.formatINR(45000), contains('45,000'));
    expect(Money.formatINR(1250000), contains('12,50,000'));
  });

  test('parseRupees handles plain numbers and commas', () {
    expect(Money.parseRupees('45000'), 45000);
    expect(Money.parseRupees('45,000'), 45000);
    expect(Money.parseRupees('  60000  '), 60000);
  });

  test('parseRupees handles k and L suffixes', () {
    expect(Money.parseRupees('45k'), 45000);
    expect(Money.parseRupees('4.5L'), 450000);
    expect(Money.parseRupees('12.5L'), 1250000);
  });

  test('parseRupees returns null for blank or junk', () {
    expect(Money.parseRupees(''), isNull);
    expect(Money.parseRupees('abc'), isNull);
    expect(Money.parseRupees('-500'), isNull);
  });

  test('formatSalaryRange shows range, single value, or empty', () {
    expect(
      Money.formatSalaryRange(40000, 60000, 'per month'),
      contains('40,000'),
    );
    expect(
      Money.formatSalaryRange(40000, 60000, 'per month'),
      contains('60,000'),
    );
    expect(Money.formatSalaryRange(50000, 50000, 'per month'), contains('50,000'));
    expect(Money.formatSalaryRange(0, 0, 'per month'), '');
    expect(Money.formatSalaryRange(0, 30000, 'per month'), contains('30,000'));
  });

  test('toYearly multiplies monthly by 12', () {
    expect(Money.toYearly(25000, monthly: true), 300000);
    expect(Money.toYearly(600000, monthly: false), 600000);
  });
}
