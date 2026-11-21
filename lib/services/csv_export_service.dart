import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/application.dart';
import '../utils/csv_builder.dart';
import '../utils/export_filename.dart';

/// Write the CSV export to the app documents folder and return its path.
class CsvExportService {
  Future<String> export(List<Application> applications) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ExportFilename.build()}');
    await file.writeAsString(CsvBuilder.build(applications));
    return file.path;
  }
}
