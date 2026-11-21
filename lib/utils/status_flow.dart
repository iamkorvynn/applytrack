import '../models/application_status.dart';

/// Which status changes are allowed from each stage.
class StatusFlow {
  static const Map<ApplicationStatus, List<ApplicationStatus>>
      allowedNext = {
    ApplicationStatus.wishlist: [
      ApplicationStatus.applied,
      ApplicationStatus.withdrawn,
    ],
    ApplicationStatus.applied: [
      ApplicationStatus.assessment,
      ApplicationStatus.interview,
      ApplicationStatus.offer,
      ApplicationStatus.rejected,
      ApplicationStatus.withdrawn,
    ],
    ApplicationStatus.assessment: [
      ApplicationStatus.interview,
      ApplicationStatus.offer,
      ApplicationStatus.rejected,
      ApplicationStatus.withdrawn,
    ],
    ApplicationStatus.interview: [
      ApplicationStatus.offer,
      ApplicationStatus.rejected,
      ApplicationStatus.withdrawn,
    ],
    ApplicationStatus.offer: [
      ApplicationStatus.withdrawn,
    ],
    ApplicationStatus.rejected: [],
    ApplicationStatus.withdrawn: [],
  };

  static bool canTransition(ApplicationStatus from, ApplicationStatus to) {
    if (from == to) return true;
    return allowedNext[from]?.contains(to) ?? false;
  }

  /// Stages that still need action from the user.
  static List<ApplicationStatus> get needsAction => [
        ApplicationStatus.applied,
        ApplicationStatus.assessment,
        ApplicationStatus.interview,
      ];
}
