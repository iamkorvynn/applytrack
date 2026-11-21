import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/work_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('hasJobUrl and hasContact reflect the fields', () {
    final app = Application(company: 'A', role: 'D');
    expect(app.hasJobUrl, isFalse);
    expect(app.hasContact, isFalse);
    final filled = app.copyWith(
      jobUrl: 'https://example.com',
      contactName: 'Priya',
    );
    expect(filled.hasJobUrl, isTrue);
    expect(filled.hasContact, isTrue);
  });

  test('displayLocation with empty city shows only the mode', () {
    final app = Application(company: 'A', role: 'D', city: '');
    expect(app.displayLocation, 'On-site');
    final remote = app.copyWith(workMode: WorkMode.remote);
    expect(remote.displayLocation, 'Remote');
  });

  test('copyWith keeps the id', () {
    final app = Application(id: 42, company: 'A', role: 'D');
    expect(app.copyWith(role: 'Designer').id, 42);
  });

  test('salary helpers report no salary when both are zero', () {
    final app = Application(company: 'A', role: 'D');
    expect(app.hasSalary, isFalse);
    expect(app.hasDeadline, isFalse);
  });
}
