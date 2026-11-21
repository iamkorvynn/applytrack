import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/services/duplicate_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Application app({int? id, String company = 'Acme', String role = 'Dev'}) {
    return Application(id: id, company: company, role: role);
  }

  test('finds same company and role, case-insensitive', () {
    final existing = [app(id: 1, company: 'Acme', role: 'Flutter Dev')];
    final candidate = Application(company: 'acme', role: 'flutter dev');
    expect(DuplicateDetector.hasDuplicate(existing, candidate), isTrue);
  });

  test('different role or company is not a duplicate', () {
    final existing = [app(id: 1)];
    expect(
      DuplicateDetector.hasDuplicate(
        existing,
        Application(company: 'Acme', role: 'Designer'),
      ),
      isFalse,
    );
    expect(
      DuplicateDetector.hasDuplicate(
        existing,
        Application(company: 'Beta', role: 'Dev'),
      ),
      isFalse,
    );
  });

  test('ignores the application itself when editing', () {
    final existing = [app(id: 1)];
    expect(
      DuplicateDetector.hasDuplicate(
        existing,
        app(id: 1),
      ),
      isFalse,
    );
  });

  test('ignores terminal applications', () {
    final existing = [
      app(id: 1).copyWith(status: ApplicationStatus.rejected),
    ];
    expect(
      DuplicateDetector.hasDuplicate(
        existing,
        Application(company: 'Acme', role: 'Dev'),
      ),
      isFalse,
    );
  });
}
