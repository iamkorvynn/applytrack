/// Whether the salary numbers are monthly or yearly.
enum SalaryPeriod { monthly, yearly }

extension SalaryPeriodX on SalaryPeriod {
  String get label {
    switch (this) {
      case SalaryPeriod.monthly:
        return 'per month';
      case SalaryPeriod.yearly:
        return 'per year';
    }
  }

  String get shortLabel {
    switch (this) {
      case SalaryPeriod.monthly:
        return '/mo';
      case SalaryPeriod.yearly:
        return '/yr';
    }
  }

  /// Convert one amount in this period to its yearly equivalent.
  int toYearly(int amount) =>
      this == SalaryPeriod.monthly ? amount * 12 : amount;
}
