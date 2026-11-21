import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/application_dao.dart';
import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late ApplicationDao dao;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await AppDatabase.openInMemory();
    dao = ApplicationDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('delete cascades to rounds and checklist items', () async {
    final id = await dao.insert(
      Application(company: 'Acme', role: 'Dev'),
    );
    await db.insert('interview_rounds', {
      'application_id': id,
      'type': 'hr',
      'notes': '',
      'outcome': 'scheduled',
    });
    await db.insert('checklist_items', {
      'application_id': id,
      'title': 'Prep',
      'is_done': 0,
      'sort_order': 0,
    });
    await dao.delete(id);
    final rounds = await db.query('interview_rounds');
    final items = await db.query('checklist_items');
    expect(rounds, isEmpty);
    expect(items, isEmpty);
  });

  test('getAll returns newest created first', () async {
    final first = Application(
      company: 'First',
      role: 'Dev',
      createdAt: DateTime(2026, 11, 10),
    );
    final second = Application(
      company: 'Second',
      role: 'Dev',
      createdAt: DateTime(2026, 11, 12),
    );
    await dao.insert(first);
    await dao.insert(second);
    final all = await dao.getAll();
    expect(all.first.company, 'Second');
    expect(all.last.company, 'First');
  });

  test('search is case-insensitive on city too', () async {
    await dao.insert(
      Application(
        company: 'Acme',
        role: 'Dev',
        city: 'Bengaluru',
        status: ApplicationStatus.applied,
      ),
    );
    expect((await dao.search('bengaluru')).length, 1);
    expect((await dao.search('BENGALURU')).length, 1);
  });
}
