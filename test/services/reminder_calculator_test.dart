import 'package:applytrack/services/reminder_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reminder is lead days before deadline at 9am', () {
    final when = ReminderCalculator.reminderDateTime(
      DateTime(2026, 11, 30),
      leadDays: 3,
      now: DateTime(2026, 11, 21),
    );
    expect(when, DateTime(2026, 11, 27, 9));
  });

  test('reminder is null when it would be in the past', () {
    final when = ReminderCalculator.reminderDateTime(
      DateTime(2026, 11, 22),
      leadDays: 3,
      now: DateTime(2026, 11, 21),
    );
    expect(when, isNull);
  });

  test('leadDays 0 reminds on the deadline day itself', () {
    final when = ReminderCalculator.reminderDateTime(
      DateTime(2026, 11, 25),
      leadDays: 0,
      now: DateTime(2026, 11, 21),
    );
    expect(when, DateTime(2026, 11, 25, 9));
  });

  test('notification ids are unique per application and type', () {
    expect(ReminderCalculator.deadlineNotificationId(5), 51);
    expect(ReminderCalculator.followUpNotificationId(5), 52);
    expect(
      ReminderCalculator.deadlineNotificationId(5),
      isNot(ReminderCalculator.followUpNotificationId(5)),
    );
    expect(
      ReminderCalculator.deadlineNotificationId(5),
      isNot(ReminderCalculator.deadlineNotificationId(6)),
    );
  });
}
