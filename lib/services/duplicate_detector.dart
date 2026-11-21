import '../models/application.dart';
import '../models/application_status.dart';

/// Spot a likely duplicate: same company + same role, still active.
class DuplicateDetector {
  static List<Application> findDuplicates(
    List<Application> apps,
    Application candidate,
  ) {
    final company = candidate.company.trim().toLowerCase();
    final role = candidate.role.trim().toLowerCase();
    return apps.where((app) {
      if (candidate.id != null && app.id == candidate.id) return false;
      if (app.status.isTerminal) return false;
      return app.company.trim().toLowerCase() == company &&
          app.role.trim().toLowerCase() == role;
    }).toList();
  }

  static bool hasDuplicate(List<Application> apps, Application candidate) =>
      findDuplicates(apps, candidate).isNotEmpty;
}
