import 'package:applytrack/services/link_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isLaunchableUrl accepts http and https with a host', () {
    expect(LinkService.isLaunchableUrl('https://example.com/jobs'), isTrue);
    expect(LinkService.isLaunchableUrl('http://naukri.com/x'), isTrue);
  });

  test('isLaunchableUrl rejects blank, relative and non-http urls', () {
    expect(LinkService.isLaunchableUrl(''), isFalse);
    expect(LinkService.isLaunchableUrl('  '), isFalse);
    expect(LinkService.isLaunchableUrl('example.com'), isFalse);
    expect(LinkService.isLaunchableUrl('ftp://example.com'), isFalse);
    expect(LinkService.isLaunchableUrl('https://localhost'), isFalse);
  });
}
