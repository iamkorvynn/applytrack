/// Where the work happens.
enum WorkMode { onsite, hybrid, remote }

extension WorkModeX on WorkMode {
  String get label {
    switch (this) {
      case WorkMode.onsite:
        return 'On-site';
      case WorkMode.hybrid:
        return 'Hybrid';
      case WorkMode.remote:
        return 'Remote';
    }
  }
}
