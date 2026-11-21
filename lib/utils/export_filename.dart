/// Predictable CSV export file names.
class ExportFilename {
  static String build({DateTime? now}) {
    final stamp = now ?? DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return 'applytrack_export_${stamp.year}${two(stamp.month)}'
        '${two(stamp.day)}_${two(stamp.hour)}${two(stamp.minute)}.csv';
  }
}
