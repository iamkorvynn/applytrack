import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../utils/constants.dart';

/// Opens the local SQLite database and creates the tables.
/// All data stays on the device; nothing is uploaded anywhere.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get database async {
    final db = _db;
    if (db != null) return db;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    return openDatabase(
      p.join(dir, AppConstants.databaseName),
      version: 1,
      onCreate: (db, version) => createTables(db),
    );
  }

  /// In-memory database used by tests.
  static Future<Database> openInMemory() async {
    return openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) => createTables(db),
    );
  }

  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE applications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        company TEXT NOT NULL,
        role TEXT NOT NULL,
        job_type TEXT NOT NULL,
        work_mode TEXT NOT NULL,
        city TEXT NOT NULL,
        salary_min INTEGER NOT NULL,
        salary_max INTEGER NOT NULL,
        salary_period TEXT NOT NULL,
        job_url TEXT NOT NULL,
        source TEXT NOT NULL,
        date_applied TEXT,
        deadline TEXT,
        status TEXT NOT NULL,
        follow_up_date TEXT,
        contact_name TEXT NOT NULL,
        contact_email TEXT NOT NULL,
        resume_version TEXT NOT NULL,
        notes TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_applications_status ON applications(status)',
    );
    await db.execute(
      'CREATE INDEX idx_applications_deadline ON applications(deadline)',
    );
    await db.execute('''
      CREATE TABLE interview_rounds(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        application_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        scheduled_at TEXT,
        notes TEXT NOT NULL,
        outcome TEXT NOT NULL,
        FOREIGN KEY (application_id) REFERENCES applications(id)
          ON DELETE CASCADE
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_rounds_app ON interview_rounds(application_id)',
    );
    await db.execute('''
      CREATE TABLE checklist_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        application_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        is_done INTEGER NOT NULL,
        sort_order INTEGER NOT NULL,
        FOREIGN KEY (application_id) REFERENCES applications(id)
          ON DELETE CASCADE
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_checklist_app ON checklist_items(application_id)',
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
