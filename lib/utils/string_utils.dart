/// Tiny string helpers for display.
class StringUtils {
  static bool isBlank(String? value) => value == null || value.trim().isEmpty;

  static String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  /// "Acme Corp" -> "AC", "Zivora" -> "Z".
  static String initials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  /// Collapse extra whitespace and trim.
  static String tidy(String value) =>
      value.trim().replaceAll(RegExp(r'\s+'), ' ');
}
