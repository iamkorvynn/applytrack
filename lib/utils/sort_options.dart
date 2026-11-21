import '../models/application.dart';

/// How the applications list is ordered.
enum SortOption { deadlineAsc, dateAppliedDesc, salaryDesc, companyAsc }

extension SortOptionX on SortOption {
  String get label {
    switch (this) {
      case SortOption.deadlineAsc:
        return 'Deadline (soonest)';
      case SortOption.dateAppliedDesc:
        return 'Date applied (newest)';
      case SortOption.salaryDesc:
        return 'Salary (highest)';
      case SortOption.companyAsc:
        return 'Company (A-Z)';
    }
  }

  int compare(Application a, Application b) {
    switch (this) {
      case SortOption.deadlineAsc:
        final ad = a.deadline;
        final bd = b.deadline;
        if (ad == null && bd == null) return _byCompany(a, b);
        if (ad == null) return 1;
        if (bd == null) return -1;
        final byDate = ad.compareTo(bd);
        return byDate != 0 ? byDate : _byCompany(a, b);
      case SortOption.dateAppliedDesc:
        final ad = a.dateApplied;
        final bd = b.dateApplied;
        if (ad == null && bd == null) return _byCompany(a, b);
        if (ad == null) return 1;
        if (bd == null) return -1;
        final byDate = bd.compareTo(ad);
        return byDate != 0 ? byDate : _byCompany(a, b);
      case SortOption.salaryDesc:
        final bySalary = b.salaryMax.compareTo(a.salaryMax);
        return bySalary != 0 ? bySalary : _byCompany(a, b);
      case SortOption.companyAsc:
        return _byCompany(a, b);
    }
  }

  int _byCompany(Application a, Application b) =>
      a.company.toLowerCase().compareTo(b.company.toLowerCase());
}
