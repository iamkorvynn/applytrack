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
    final appId = await service.createApplication(
      Application(company: 'Acme', role: 'Dev'),
    );
    await service.addRound(
      InterviewRound(applicationId: appId, type: RoundType.hr),
    );
    final app = (await service.applications.getById(appId))!;
    await tester.pumpWidget(
      MaterialApp(
        home: ApplicationDetailScreen(application: app, service: service),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('HR round'));
    await tester.pumpAndSettle();
    expect(find.text('HR round outcome'), findsOneWidget);
    expect(find.text('Cleared'), findsOneWidget);
    await tester.tap(find.text('Cleared'));
    await tester.pumpAndSettle();
    final rounds = await service.roundsFor(appId);
    expect(rounds.first.outcome, RoundOutcome.cleared);
  });
}
