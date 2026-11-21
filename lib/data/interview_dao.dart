import 'package:sqflite/sqflite.dart';

import '../models/interview_round.dart';

/// CRUD for interview rounds.
class InterviewDao {
  InterviewDao(this.db);

  final Database db;

  Future<int> insert(InterviewRound round) async {
    final map = round.toMap()..remove('id');
    return db.insert('interview_rounds', map);
  }

  Future<int> update(InterviewRound round) async {
    return db.update(
      'interview_rounds',
      round.toMap(),
      where: 'id = ?',
      whereArgs: [round.id],
    );
  }

  Future<int> delete(int id) async {
    return db.delete('interview_rounds', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteForApplication(int applicationId) async {
    return db.delete(
      'interview_rounds',
      where: 'application_id = ?',
      whereArgs: [applicationId],
    );
  }

  /// Rounds for one application, soonest scheduled first.
  Future<List<InterviewRound>> getForApplication(int applicationId) async {
    final rows = await db.query(
      'interview_rounds',
      where: 'application_id = ?',
      whereArgs: [applicationId],
      orderBy: 'scheduled_at ASC',
    );
    return rows.map(InterviewRound.fromMap).toList();
  }

  /// The next scheduled round across all applications, if any.
  Future<InterviewRound?> nextUpcoming() async {
    final now = DateTime.now().toIso8601String();
    final rows = await db.query(
      'interview_rounds',
      where: 'scheduled_at > ? AND outcome = ?',
      whereArgs: [now, RoundOutcome.scheduled.name],
      orderBy: 'scheduled_at ASC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return InterviewRound.fromMap(rows.first);
  }
}
