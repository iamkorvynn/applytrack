import '../models/application.dart';
import 'app_dates.dart';

/// How long ago an application was sent.
class ApplicationAge {
  static int? daysSinceApplied(Application app, {DateTime? now}) {
    final applied = app.dateApplied;
    if (applied == null) return null;
    return AppDates.daysBetween(applied, now ?? DateTime.now());
  }

  static String label(Application app, {DateTime? now}) {
    final days = daysSinceApplied(app, now: now);
    if (days == null) return 'Not applied yet';
    if (days == 0) return 'Applied today';
    if (days == 1) return 'Applied yesterday';
    if (days < 0) return 'Applied in the future?';
    return 'Applied $days days ago';
  }
}
