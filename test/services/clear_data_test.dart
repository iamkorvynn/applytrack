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

  test('clearAllData removes every application and its children', () async {
    final first = await service.createApplication(
      Application(company: 'Acme', role: 'Dev'),
    );
    final second = await service.createApplication(
      Application(company: 'Beta', role: 'Designer'),
    );
    await service.addRound(InterviewRound(applicationId: first));
    await service.addChecklistItem(
      ChecklistItem(applicationId: second, title: 'Prep'),
    );
    await service.clearAllData();
    expect(await service.applications.getAll(), isEmpty);
    expect(await service.rounds.getAll(), isEmpty);
    expect(await service.checklist.getForApplication(first), isEmpty);
  });
}
