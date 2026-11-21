import 'package:intl/intl.dart';

/// Money is stored as whole rupees (int). No floats anywhere, so no
/// paise-rounding bugs like 0.1 + 0.2.
class Money {
  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '\u20b9',
    decimalDigits: 0,
  );

  static final NumberFormat _inrCompact = NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: '\u20b9',
    decimalDigits: 1,
  );

  /// 45000 -> "Rs.45,000" in en_IN grouping ("Rs.45,000").
  static String formatINR(int rupees) => _inr.format(rupees);

  /// 1250000 -> "Rs.12.5L" style compact form for chart labels.
  static String formatCompact(int rupees) => _inrCompact.format(rupees);

  /// "Rs. 45,000", "45000", "45k", "4.5L" -> rupees, or null if unparsable.
  static int? parseRupees(String raw) {
    final text = raw.trim().toLowerCase();
    if (text.isEmpty) return null;
    var cleaned = text
        .replaceAll('\u20b9', '')
        .replaceAll('rs.', '')
        .replaceAll('rs', '')
        .replaceAll(',', '')
        .replaceAll(' ', '');
    var multiplier = 1;
    if (cleaned.endsWith('l')) {
      multiplier = 100000;
      cleaned = cleaned.substring(0, cleaned.length - 1);
    } else if (cleaned.endsWith('k')) {
      multiplier = 1000;
      cleaned = cleaned.substring(0, cleaned.length - 1);
    }
    final value = double.tryParse(cleaned);
    if (value == null || value < 0) return null;
    return (value * multiplier).round();
  }

  /// "Rs.45,000 - Rs.60,000 /mo" or "Rs.45,000 /mo" or "" when no salary.
  static String formatSalaryRange(
    int min,
    int max,
    String periodLabel,
  ) {
    if (min <= 0 && max <= 0) return '';
    if (min > 0 && max > 0 && max != min) {
      return '${formatINR(min)} - ${formatINR(max)} $periodLabel';
    }
    final value = max > 0 ? max : min;
    return '${formatINR(value)} $periodLabel';
  }

  /// Monthly stipend of 25,000 is 3,00,000 a year; yearly stays as-is.
  static int toYearly(int amount, {required bool monthly}) =>
      monthly ? amount * 12 : amount;
}
