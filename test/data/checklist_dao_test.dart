import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/checklist_dao.dart';
import 'package:applytrack/models/checklist_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late ChecklistDao dao;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await AppDatabase.openInMemory();
    dao = ChecklistDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('insert and list in sort order', () async {
    await dao.insert(
      ChecklistItem(applicationId: 1, title: 'Second', sortOrder: 1),
    );
    await dao.insert(
      ChecklistItem(applicationId: 1, title: 'First', sortOrder: 0),
    );
    final items = await dao.getForApplication(1);
    expect(items.map((i) => i.title).toList(), ['First', 'Second']);
  });

  test('toggle flips the done flag', () async {
    await dao.insert(ChecklistItem(applicationId: 1, title: 'Task'));
    var items = await dao.getForApplication(1);
    await dao.toggle(items.first);
    items = await dao.getForApplication(1);
    expect(items.first.isDone, isTrue);
    await dao.toggle(items.first);
    items = await dao.getForApplication(1);
    expect(items.first.isDone, isFalse);
  });

  test('countDone counts only finished items', () async {
    await dao.insert(
      ChecklistItem(applicationId: 1, title: 'A', isDone: true),
    );
    await dao.insert(ChecklistItem(applicationId: 1, title: 'B'));
    expect(await dao.countDone(1), 1);
    expect(await dao.countDone(2), 0);
  });

  test('delete removes one item', () async {
    final id = await dao.insert(
      ChecklistItem(applicationId: 1, title: 'A'),
    );
    await dao.delete(id);
    expect(await dao.getForApplication(1), isEmpty);
  });
}
