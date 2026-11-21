import '../models/application.dart';
import 'money.dart';

/// Salary insights across applications, in yearly rupees.
class SalaryInsights {
  /// Annual equivalents of the max salary of every app that has one.
  static List<int> annualMaxSalaries(List<Application> apps) {
    final values = <int>[];
    for (final app in apps) {
      if (app.salaryMax > 0) {
        values.add(
          Money.toYearly(
            app.salaryMax,
            monthly: app.salaryPeriod.name == 'monthly',
          ),
        );
      }
    }
    values.sort();
    return values;
  }

  static int? medianAnnual(List<Application> apps) {
    final values = annualMaxSalaries(apps);
    if (values.isEmpty) return null;
    final mid = values.length ~/ 2;
    if (values.length.isOdd) return values[mid];
    return (values[mid - 1] + values[mid]) ~/ 2;
  }

  static int? minAnnual(List<Application> apps) {
    final values = annualMaxSalaries(apps);
    if (values.isEmpty) return null;
    return values.first;
  }

  static int? maxAnnual(List<Application> apps) {
    final values = annualMaxSalaries(apps);
    if (values.isEmpty) return null;
    return values.last;
  }

  static String summary(List<Application> apps) {
    final median = medianAnnual(apps);
    if (median == null) {
      return 'Add salaries to your applications to see pay insights.';
    }
    return 'Median top pay ${Money.formatINR(median)} per year.';
  }
}
