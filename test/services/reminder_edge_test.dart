import 'package:applytrack/services/reminder_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('custom hour is honoured', () {
    final when = ReminderCalculator.reminderDateTime(
      DateTime(2026, 11, 30),
      leadDays: 1,
      hour: 18,
      now: DateTime(2026, 11, 21),
    );
    expect(when, DateTime(2026, 11, 29, 18));
  });

  test('reminder exactly now is treated as past', () {
    final when = ReminderCalculator.reminderDateTime(
      DateTime(2026, 11, 25),
      leadDays: 0,
      hour: 9,
      now: DateTime(2026, 11, 25, 9),
    );
    expect(when, isNull);
  });

  test('large lead days still compute', () {
    final when = ReminderCalculator.reminderDateTime(
      DateTime(2026, 12, 31),
      leadDays: 30,
      now: DateTime(2026, 11, 21),
    );
    expect(when, DateTime(2026, 12, 1, 9));
  });
}
