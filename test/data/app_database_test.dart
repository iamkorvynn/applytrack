import 'package:applytrack/data/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('in-memory database creates all three tables', () async {
    final db = await AppDatabase.openInMemory();
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name",
    );
    final names = tables.map((row) => row['name'] as String).toList();
    expect(names, contains('applications'));
    expect(names, contains('interview_rounds'));
    expect(names, contains('checklist_items'));
    await db.close();
  });

  test('applications table rejects a row without company', () async {
    final db = await AppDatabase.openInMemory();
    expect(
      () => db.insert('applications', {'role': 'Dev'}),
      throwsA(anything),
    );
    await db.close();
  });
}
