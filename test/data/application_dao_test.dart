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

  Application sample(String company) {
    return Application(
      company: company,
      role: 'Developer',
      status: ApplicationStatus.applied,
    );
  }

  test('insert returns an id and getById finds it', () async {
    final id = await dao.insert(sample('Acme'));
    expect(id, greaterThan(0));
    final found = await dao.getById(id);
    expect(found?.company, 'Acme');
  });

  test('getById returns null for unknown id', () async {
    expect(await dao.getById(9999), isNull);
  });

  test('update changes the status', () async {
    final id = await dao.insert(sample('Acme'));
    final app = (await dao.getById(id))!;
    await dao.update(app.copyWith(status: ApplicationStatus.offer));
    expect((await dao.getById(id))!.status, ApplicationStatus.offer);
  });

  test('delete removes the application', () async {
    final id = await dao.insert(sample('Acme'));
    await dao.delete(id);
    expect(await dao.getById(id), isNull);
    expect(await dao.getAll(), isEmpty);
  });

  test('getByStatus filters by stage', () async {
    await dao.insert(sample('A'));
    await dao.insert(
      sample('B').copyWith(status: ApplicationStatus.interview),
    );
    final applied = await dao.getByStatus(ApplicationStatus.applied);
    expect(applied.length, 1);
    expect(applied.first.company, 'A');
  });

  test('search matches company and role', () async {
    await dao.insert(sample('Acme'));
    await dao.insert(sample('Beta').copyWith(role: 'Designer'));
    expect((await dao.search('acme')).length, 1);
    expect((await dao.search('Designer')).length, 1);
    expect((await dao.search('zzz')), isEmpty);
  });

  test('countByStatus counts correctly', () async {
    await dao.insert(sample('A'));
    await dao.insert(sample('B'));
    expect(
      await dao.countByStatus(ApplicationStatus.applied),
      2,
    );
    expect(await dao.countByStatus(ApplicationStatus.offer), 0);
  });
}
