import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/application_dao.dart';
import 'package:applytrack/data/checklist_dao.dart';
import 'package:applytrack/data/interview_dao.dart';
import 'package:applytrack/models/application.dart';
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

  testWidgets('shows how long ago the application was sent',
      (tester) async {
    final id = await service.createApplication(
      Application(
        company: 'Acme',
        role: 'Dev',
        dateApplied: DateTime.now().subtract(const Duration(days: 5)),
      ),
    );
    final app = (await service.applications.getById(id))!;
    await tester.pumpWidget(
      MaterialApp(
        home: ApplicationDetailScreen(application: app, service: service),
      ),
    );
    await tester.pump();
    expect(find.textContaining('Applied 5 days ago'), findsOneWidget);
  });
}
