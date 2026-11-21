import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/application_dao.dart';
import 'package:applytrack/data/checklist_dao.dart';
import 'package:applytrack/data/interview_dao.dart';
import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/checklist_item.dart';
import 'package:applytrack/models/interview_round.dart';
import 'package:applytrack/services/application_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late ApplicationService service;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await AppDatabase.openInMemory();
    service = ApplicationService(
      applications: ApplicationDao(db),
      rounds: InterviewDao(db),
      checklist: ChecklistDao(db),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('create + delete removes rounds and checklist too', () async {
    final id = await service.createApplication(
      Application(company: 'Acme', role: 'Dev'),
    );
    await service.addRound(InterviewRound(applicationId: id));
    await service.addChecklistItem(
      ChecklistItem(applicationId: id, title: 'Prep'),
    );
    await service.deleteApplication(id);
    expect(await service.applications.getById(id), isNull);
    expect(await service.roundsFor(id), isEmpty);
    expect(await service.checklistFor(id), isEmpty);
  });

  test('addPrepTemplate adds HR tasks once, not twice', () async {
    final id = await service.createApplication(
      Application(company: 'Acme', role: 'Dev'),
    );
    await service.addPrepTemplate(id, RoundType.hr);
    await service.addPrepTemplate(id, RoundType.hr);
    final items = await service.checklistFor(id);
    expect(items.length, 5);
    expect(items.first.title, contains('job description'));
  });

  test('toggle checklist flips done state', () async {
    final id = await service.createApplication(
      Application(company: 'Acme', role: 'Dev'),
    );
    final itemId = await service.addChecklistItem(
      ChecklistItem(applicationId: id, title: 'Task'),
    );
    expect(itemId, greaterThan(0));
    var items = await service.checklistFor(id);
    await service.toggleChecklistItem(items.first);
    items = await service.checklistFor(id);
    expect(items.first.isDone, isTrue);
  });
}
