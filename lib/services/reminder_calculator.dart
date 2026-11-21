/// Pure reminder maths: when should the phone buzz about a deadline?
class ReminderCalculator {
  /// [leadDays] before the deadline, at [hour] local time.
  /// Returns null when that moment is already in the past.
  static DateTime? reminderDateTime(
    DateTime deadline, {
    required int leadDays,
    int hour = 9,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final day = DateTime(
      deadline.year,
      deadline.month,
      deadline.day,
    ).subtract(Duration(days: leadDays));
    final reminder = DateTime(day.year, day.month, day.day, hour);
    if (!reminder.isAfter(current)) return null;
    return reminder;
  }

  /// Reminder ids are derived from the application id so editing or
  /// deleting can cancel exactly its own reminders.
  static int deadlineNotificationId(int applicationId) =>
      applicationId * 10 + 1;

  static int followUpNotificationId(int applicationId) =>
      applicationId * 10 + 2;
}
