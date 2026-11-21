import 'package:applytrack/models/application.dart';
import 'package:applytrack/utils/application_age.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 21, 12);

  test('daysSinceApplied counts from the applied date', () {
    final app = Application(
      company: 'A',
      role: 'D',
      dateApplied: DateTime(2026, 11, 16),
    );
    expect(ApplicationAge.daysSinceApplied(app, now: now), 5);
  });

  test('null when never applied', () {
    final app = Application(company: 'A', role: 'D');
    expect(ApplicationAge.daysSinceApplied(app, now: now), isNull);
    expect(ApplicationAge.label(app, now: now), 'Not applied yet');
  });

  test('labels for today and yesterday', () {
    expect(
      ApplicationAge.label(
        Application(
          company: 'A',
          role: 'D',
          dateApplied: DateTime(2026, 11, 21),
        ),
        now: now,
      ),
      'Applied today',
    );
    expect(
      ApplicationAge.label(
        Application(
          company: 'A',
          role: 'D',
          dateApplied: DateTime(2026, 11, 20),
        ),
        now: now,
      ),
      'Applied yesterday',
    );
  });
}
