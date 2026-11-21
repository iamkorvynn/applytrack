/// Pipeline stages an application moves through.
enum ApplicationStatus {
  wishlist,
  applied,
  assessment,
  interview,
  offer,
  rejected,
  withdrawn,
}

extension ApplicationStatusX on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.wishlist:
        return 'Wishlist';
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.assessment:
        return 'Assessment';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.offer:
        return 'Offer';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  /// Order in the pipeline, for sorting and funnel display.
  int get order {
    switch (this) {
      case ApplicationStatus.wishlist:
        return 0;
      case ApplicationStatus.applied:
        return 1;
      case ApplicationStatus.assessment:
        return 2;
      case ApplicationStatus.interview:
        return 3;
      case ApplicationStatus.offer:
        return 4;
      case ApplicationStatus.rejected:
        return 5;
      case ApplicationStatus.withdrawn:
        return 6;
    }
  }

  /// Rejected / withdrawn end the application.
  bool get isTerminal =>
      this == ApplicationStatus.rejected ||
      this == ApplicationStatus.withdrawn;

  /// Actively being pursued (not wishlist, not terminal).
  bool get isActive =>
      this == ApplicationStatus.applied ||
      this == ApplicationStatus.assessment ||
      this == ApplicationStatus.interview ||
      this == ApplicationStatus.offer;

  /// Got far enough to talk to a human.
  bool get reachedInterview =>
      this == ApplicationStatus.interview ||
      this == ApplicationStatus.offer;
}
