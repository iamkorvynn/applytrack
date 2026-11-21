import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:applytrack/services/deadline_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 21, 12);

  test('upcoming with 0 days returns only overdue and today', () {
    final list = DeadlineService.upcoming(
      [
        Application(
          company: 'A',
          role: 'D',
          deadline: DateTime(2026, 11, 21),
        ),
        Application(
          company: 'B',
          role: 'D',
          deadline: DateTime(2026, 11, 22),
        ),
      ],
      now: now,
      days: 0,
    );
    expect(list.length, 1);
    expect(list.first.company, 'A');
  });

  test('group puts no-deadline apps in none bucket', () {
    final grouped = DeadlineService.group(
      [Application(company: 'A', role: 'D')],
      now: now,
    );
    expect(grouped.values.expand((l) => l).length, 1);
  });

  test('wishlist applications still show deadlines', () {
    final grouped = DeadlineService.group(
      [
        Application(
          company: 'A',
          role: 'D',
          status: ApplicationStatus.wishlist,
          deadline: DateTime(2026, 11, 25),
        ),
      ],
      now: now,
    );
    expect(grouped.values.expand((l) => l).length, 1);
  });
}
