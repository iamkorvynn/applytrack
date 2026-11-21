import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/application_dao.dart';
import 'package:applytrack/data/checklist_dao.dart';
import 'package:applytrack/data/interview_dao.dart';
import 'package:applytrack/models/application.dart';
import 'package:applytrack/models/application_status.dart';
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

  testWidgets('shows role, status and sections', (tester) async {
    final app = await tester.runAsync(() async {
      final id = await service.createApplication(
        Application(
          company: 'Acme',
          role: 'Flutter Dev',
          status: ApplicationStatus.interview,
          salaryMin: 50000,
          salaryMax: 70000,
        ),
      );
      return (await service.applications.getById(id))!;
    });
    await tester.pumpWidget(
      MaterialApp(
        home: ApplicationDetailScreen(application: app, service: service),
      ),
    );
    await tester.pump();
    expect(find.text('Flutter Dev'), findsOneWidget);
    expect(find.text('Interview'), findsOneWidget);
    expect(find.text('Interview rounds'), findsOneWidget);
    expect(find.textContaining('Interview prep'), findsOneWidget);
  });
}
