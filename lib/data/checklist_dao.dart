import 'package:sqflite/sqflite.dart';

import '../models/checklist_item.dart';

/// CRUD for interview-prep checklist items.
class ChecklistDao {
  ChecklistDao(this.db);

  final Database db;

  Future<int> insert(ChecklistItem item) async {
    final map = item.toMap()..remove('id');
    return db.insert('checklist_items', map);
  }

  Future<int> update(ChecklistItem item) async {
    return db.update(
      'checklist_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> toggle(ChecklistItem item) async {
    return update(item.copyWith(isDone: !item.isDone));
  }

  Future<int> delete(int id) async {
    return db.delete('checklist_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteForApplication(int applicationId) async {
    return db.delete(
      'checklist_items',
      where: 'application_id = ?',
      whereArgs: [applicationId],
    );
  }

  Future<List<ChecklistItem>> getForApplication(int applicationId) async {
    final rows = await db.query(
      'checklist_items',
      where: 'application_id = ?',
      whereArgs: [applicationId],
      orderBy: 'sort_order ASC',
    );
    return rows.map(ChecklistItem.fromMap).toList();
  }

  Future<int> countDone(int applicationId) async {
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS n FROM checklist_items '
      'WHERE application_id = ? AND is_done = 1',
      [applicationId],
    );
    final value = rows.first['n'];
    if (value is int) return value;
    return 0;
  }
}
