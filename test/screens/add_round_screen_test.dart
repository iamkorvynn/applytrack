import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/application_dao.dart';
import 'package:applytrack/data/checklist_dao.dart';
import 'package:applytrack/data/interview_dao.dart';
import 'package:applytrack/models/application.dart';
import 'package:applytrack/screens/add_round_screen.dart';
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

  testWidgets('shows round type and outcome fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AddRoundScreen(applicationId: 1, service: service),
      ),
    );
    expect(find.text('Add interview round'), findsOneWidget);
    expect(find.text('HR round'), findsOneWidget);
    expect(find.text('Scheduled'), findsOneWidget);
  });

  testWidgets('saving creates the round', (tester) async {
    final appId = await tester.runAsync(
      () => service.createApplication(
        Application(company: 'Acme', role: 'Dev'),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: AddRoundScreen(applicationId: appId, service: service),
      ),
    );
    await tester.tap(find.text('Add round'));
    await tester.runAsync(
      () async => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpAndSettle();
    final rounds = await tester.runAsync(() => service.roundsFor(appId));
    expect(rounds.length, 1);
    expect(rounds.first.type.name, 'hr');
  });
}
