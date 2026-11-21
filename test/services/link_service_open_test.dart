import 'package:applytrack/services/link_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('openUrl returns false for invalid urls without crashing', () async {
    expect(await LinkService.openUrl('not a url'), isFalse);
    expect(await LinkService.openUrl(''), isFalse);
    expect(await LinkService.openUrl('ftp://example.com'), isFalse);
  });
}
