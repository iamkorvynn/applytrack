import 'package:sqflite/sqflite.dart';

import '../models/application.dart';
import '../models/application_status.dart';

/// CRUD for applications on top of an opened database.
class ApplicationDao {
  ApplicationDao(this.db);

  final Database db;

  Future<int> insert(Application app) async {
    final map = app.toMap()..remove('id');
    return db.insert('applications', map);
  }

  Future<int> update(Application app) async {
    return db.update(
      'applications',
      app.toMap(),
      where: 'id = ?',
      whereArgs: [app.id],
    );
  }

  Future<int> delete(int id) async {
    await db.delete(
      'interview_rounds',
      where: 'application_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'checklist_items',
      where: 'application_id = ?',
      whereArgs: [id],
    );
    return db.delete('applications', where: 'id = ?', whereArgs: [id]);
  }

  Future<Application?> getById(int id) async {
    final rows = await db.query(
      'applications',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Application.fromMap(rows.first);
  }

  /// All applications, newest applied first.
  Future<List<Application>> getAll() async {
    final rows = await db.query(
      'applications',
      orderBy: 'created_at DESC',
    );
    return rows.map(Application.fromMap).toList();
  }

  Future<List<Application>> getByStatus(ApplicationStatus status) async {
    final rows = await db.query(
      'applications',
      where: 'status = ?',
      whereArgs: [status.name],
      orderBy: 'created_at DESC',
    );
    return rows.map(Application.fromMap).toList();
  }

  Future<List<Application>> search(String query) async {
    final pattern = '%${query.trim()}%';
    final rows = await db.query(
      'applications',
      where: 'company LIKE ? OR role LIKE ? OR city LIKE ?',
      whereArgs: [pattern, pattern, pattern],
      orderBy: 'created_at DESC',
    );
    return rows.map(Application.fromMap).toList();
  }

  Future<int> countByStatus(ApplicationStatus status) async {
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS n FROM applications WHERE status = ?',
      [status.name],
    );
    final value = rows.first['n'];
    if (value is int) return value;
    return 0;
  }
}
