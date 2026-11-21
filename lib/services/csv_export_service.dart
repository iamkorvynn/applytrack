import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/application.dart';
import '../utils/constants.dart';
import '../utils/csv_builder.dart';

/// Write the CSV export to the app documents folder and return its path.
class CsvExportService {
  Future<String> export(List<Application> applications) async {
    final dir = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    final stamp =
        '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}';
    final file = File(
      '${dir.path}/${AppConstants.exportFilePrefix}_$stamp.csv',
    );
    await file.writeAsString(CsvBuilder.build(applications));
    return file.path;
  }
}
