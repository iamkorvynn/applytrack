import '../models/application.dart';
import '../models/application_status.dart';
import '../utils/app_dates.dart';

/// Follow-up suggestions: which applications need a nudge, and when.
class FollowUpHelper {
  /// Applications where the user should follow up: applied/assessment
  /// more than [quietDays] ago with no follow-up date set, or a
  /// follow-up date that has arrived.
  static List<Application> needingFollowUp(
    List<Application> apps, {
    DateTime? now,
    int quietDays = 7,
  }) {
    final current = now ?? DateTime.now();
    final list = apps.where((app) {
      if (app.status.isTerminal) return false;
      if (app.status == ApplicationStatus.wishlist) return false;
      if (app.followUpDate != null) {
        return AppDates.daysBetween(current, app.followUpDate!) <= 0;
      }
      final applied = app.dateApplied ?? app.createdAt;
      return AppDates.daysBetween(applied, current) >= quietDays;
    }).toList();
    list.sort((a, b) {
      final ad = a.followUpDate ?? a.dateApplied ?? a.createdAt;
      final bd = b.followUpDate ?? b.dateApplied ?? b.createdAt;
      return ad.compareTo(bd);
    });
    return list;
  }

  /// Suggest a follow-up date: [daysAfterApplied] days after applying.
  static DateTime suggestFollowUpDate(Application app, {int days = 7}) {
    final base = app.dateApplied ?? app.createdAt;
    return DateTime(base.year, base.month, base.day)
        .add(Duration(days: days));
  }
}
