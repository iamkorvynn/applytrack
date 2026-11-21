import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/interview_dao.dart';
import 'package:applytrack/models/interview_round.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late InterviewDao dao;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await AppDatabase.openInMemory();
    dao = InterviewDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('delete removes a single round', () async {
    final id = await dao.insert(
      InterviewRound(applicationId: 1, type: RoundType.hr),
    );
    await dao.insert(InterviewRound(applicationId: 1, type: RoundType.technical));
    await dao.delete(id);
    expect((await dao.getForApplication(1)).length, 1);
  });

  test('rounds list in scheduled order', () async {
    await dao.insert(
      InterviewRound(
        applicationId: 1,
        scheduledAt: DateTime(2026, 11, 28),
      ),
    );
    await dao.insert(
      InterviewRound(
        applicationId: 1,
        scheduledAt: DateTime(2026, 11, 22),
      ),
    );
    final rounds = await dao.getForApplication(1);
    expect(rounds.first.scheduledAt, DateTime(2026, 11, 22));
  });

  test('getAll returns every round', () async {
    await dao.insert(InterviewRound(applicationId: 1));
    await dao.insert(InterviewRound(applicationId: 2));
    expect((await dao.getAll()).length, 2);
  });
}
