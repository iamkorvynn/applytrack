import 'package:applytrack/utils/export_filename.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builds a timestamped csv name', () {
    expect(
      ExportFilename.build(now: DateTime(2026, 11, 21, 9, 5)),
      'applytrack_export_20261121_0905.csv',
    );
  });

  test('pads single digit months and minutes', () {
    expect(
      ExportFilename.build(now: DateTime(2026, 1, 2, 3, 4)),
      'applytrack_export_20260102_0304.csv',
    );
  });
}
