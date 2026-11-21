/// App-wide constants.
class AppConstants {
  static const String appName = 'ApplyTrack';
  static const String databaseName = 'applytrack.db';
  static const String exportFilePrefix = 'applytrack_export';

  /// Default reminder: 3 days before a deadline, at 9am.
  static const int defaultReminderLeadDays = 3;
  static const int defaultReminderHour = 9;

  static const int maxResumeVersionLength = 40;
  static const int maxNotesLength = 2000;

  /// How far ahead the deadlines screen looks for "this week".
  static const int thisWeekDays = 7;

  /// Weeks shown on the stats chart.
  static const int statsWeeks = 8;
}
