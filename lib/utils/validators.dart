import 'money.dart';

/// Form validation. Every function returns an error string or null.
class Validators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? company(String? value) {
    final error = required(value, 'Company');
    if (error != null) return error;
    if (value!.trim().length < 2) return 'Company name looks too short';
    return null;
  }

  static String? role(String? value) {
    final error = required(value, 'Role');
    if (error != null) return error;
    if (value!.trim().length < 2) return 'Role looks too short';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final text = value.trim();
    if (!text.contains('@') || !text.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  /// Empty is fine (link is optional). Otherwise needs http(s) + a dot.
  static String? jobUrl(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final text = value.trim();
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        !uri.host.contains('.')) {
      return 'Enter a full link starting with http:// or https://';
    }
    return null;
  }

  /// Salary fields are optional, but min must not exceed max.
  static String? salaryRange(String? minRaw, String? maxRaw) {
    final min = Money.parseRupees(minRaw ?? '');
    final max = Money.parseRupees(maxRaw ?? '');
    if ((minRaw ?? '').trim().isNotEmpty && min == null) {
      return 'Min salary is not a number';
    }
    if ((maxRaw ?? '').trim().isNotEmpty && max == null) {
      return 'Max salary is not a number';
    }
    if (min != null && max != null && min > max) {
      return 'Min salary cannot be more than max salary';
    }
    return null;
  }
}
