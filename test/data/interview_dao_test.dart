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

  test('insert and list rounds for an application', () async {
    await dao.insert(
      InterviewRound(
        applicationId: 1,
        type: RoundType.hr,
        scheduledAt: DateTime(2026, 11, 25, 10),
      ),
    );
    await dao.insert(
      InterviewRound(applicationId: 1, type: RoundType.technical),
    );
    final rounds = await dao.getForApplication(1);
    expect(rounds.length, 2);
    expect(await dao.getForApplication(2), isEmpty);
  });

  test('update changes the outcome', () async {
    final id = await dao.insert(
      InterviewRound(applicationId: 1, type: RoundType.hr),
    );
    final rounds = await dao.getForApplication(1);
    await dao.update(rounds.first.copyWith(outcome: RoundOutcome.cleared));
    expect(
      (await dao.getForApplication(1)).first.outcome,
      RoundOutcome.cleared,
    );
    expect(id, greaterThan(0));
  });

  test('deleteForApplication removes only that app rounds', () async {
    await dao.insert(InterviewRound(applicationId: 1));
    await dao.insert(InterviewRound(applicationId: 2));
    await dao.deleteForApplication(1);
    expect(await dao.getForApplication(1), isEmpty);
    expect((await dao.getForApplication(2)).length, 1);
  });

  test('nextUpcoming returns the soonest future scheduled round', () async {
    final now = DateTime.now();
    await dao.insert(
      InterviewRound(
        applicationId: 1,
        scheduledAt: now.add(const Duration(days: 5)),
      ),
    );
    await dao.insert(
      InterviewRound(
        applicationId: 2,
        scheduledAt: now.add(const Duration(days: 1)),
      ),
    );
    await dao.insert(
      InterviewRound(
        applicationId: 3,
        scheduledAt: now.subtract(const Duration(days: 1)),
      ),
    );
    final next = await dao.nextUpcoming();
    expect(next?.applicationId, 2);
  });
}
