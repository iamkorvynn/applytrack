/// Reminder lead-time choices shown in Settings.
class ReminderLeadOptions {
  static const List<int> options = [0, 1, 3, 7, 14];

  static String label(int days) {
    switch (days) {
      case 0:
        return 'On the deadline day';
      case 1:
        return '1 day before';
      default:
        return '$days days before';
    }
  }
}
