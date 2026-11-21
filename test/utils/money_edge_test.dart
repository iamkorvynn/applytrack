import 'package:applytrack/utils/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parseRupees handles rupee symbol and decimals', () {
    expect(Money.parseRupees('\u20b945,000'), 45000);
    expect(Money.parseRupees('Rs. 45,000'), 45000);
    expect(Money.parseRupees('45.5k'), 45500);
    expect(Money.parseRupees('0'), 0);
  });

  test('parseRupees rejects negatives and lone suffix', () {
    expect(Money.parseRupees('-5k'), isNull);
    expect(Money.parseRupees('k'), isNull);
    expect(Money.parseRupees('1.2.3'), isNull);
  });

  test('formatINR of zero and large values', () {
    expect(Money.formatINR(0), contains('0'));
    expect(Money.formatINR(10000000), contains('1,00,00,000'));
  });

  test('formatSalaryRange with only min set', () {
    final label = Money.formatSalaryRange(60000, 0, 'per year');
    expect(label, contains('60,000'));
    expect(label, contains('per year'));
  });

  test('compact format shortens lakhs', () {
    expect(Money.formatCompact(1250000), contains('12.5'));
  });
}
