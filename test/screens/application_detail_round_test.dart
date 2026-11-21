import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/application_dao.dart';
import 'package:applytrack/data/checklist_dao.dart';
import 'package:applytrack/data/interview_dao.dart';
import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/interview_round.dart';
import 'package:applytrack/screens/application_detail_screen.dart';
import 'package:applytrack/services/application_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
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

  testWidgets('tapping a round opens the outcome dialog', (tester) async {
    final (appId, app) = (await tester.runAsync(() async {
      final createdId = await service.createApplication(
        Application(company: 'Acme', role: 'Dev'),
      );
      await service.addRound(
        InterviewRound(applicationId: createdId, type: RoundType.hr),
      );
      final loaded = (await service.applications.getById(createdId))!;
      return (createdId, loaded);
    }))!;
    await tester.pumpWidget(
      MaterialApp(
        home: ApplicationDetailScreen(application: app, service: service),
      ),
    );
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('HR round'),
      200,
      scrollable: find.byType(ListView),
    );
    await tester.tap(find.text('HR round'));
    await tester.pumpAndSettle();
    expect(find.text('HR round outcome'), findsOneWidget);
    expect(find.text('Cleared'), findsOneWidget);
    await tester.tap(find.text('Cleared'));
    await tester.pumpAndSettle();
    // The tap handler saves the outcome through SQLite; let that real
    // async work finish (two turns: save, then reload) before checking.
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();
    final rounds = (await tester.runAsync(() => service.roundsFor(appId)))!;
    expect(rounds.first.outcome, RoundOutcome.cleared);
  });
}
