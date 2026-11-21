import 'package:applytrack/utils/string_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isBlank catches null, empty and spaces', () {
    expect(StringUtils.isBlank(null), isTrue);
    expect(StringUtils.isBlank('   '), isTrue);
    expect(StringUtils.isBlank('x'), isFalse);
  });

  test('initials take first letters of first two words', () {
    expect(StringUtils.initials('Acme Corp'), 'AC');
    expect(StringUtils.initials('Zivora'), 'Z');
    expect(StringUtils.initials(''), '?');
    expect(StringUtils.initials('  google  india '), 'GI');
  });

  test('tidy collapses whitespace', () {
    expect(StringUtils.tidy('  hello   world  '), 'hello world');
  });

  test('capitalize uppercases the first letter', () {
    expect(StringUtils.capitalize('hello'), 'Hello');
    expect(StringUtils.capitalize(''), '');
  });
}
