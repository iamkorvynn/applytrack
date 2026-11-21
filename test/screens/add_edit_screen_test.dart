import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/application_dao.dart';
import 'package:applytrack/data/checklist_dao.dart';
import 'package:applytrack/data/interview_dao.dart';
import 'package:applytrack/models/application.dart';
import 'package:applytrack/screens/add_edit_application_screen.dart';
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

  testWidgets('shows the add form fields', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AddEditApplicationScreen(service: service),
      ),
    );
    expect(find.text('Add application'), findsOneWidget);
    expect(find.text('Company *'), findsOneWidget);
    expect(find.text('Role *'), findsOneWidget);
    expect(find.text('Job link'), findsOneWidget);
  });

  testWidgets('saving with empty company shows a validation error',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AddEditApplicationScreen(service: service),
      ),
    );
    await tester.tap(find.text('Add application'));
    await tester.pump();
    expect(find.text('Company is required'), findsOneWidget);
  });

  testWidgets('saving a filled form creates the application',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AddEditApplicationScreen(service: service),
      ),
    );
    await tester.enterText(find.byType(TextFormField).first, 'Acme');
    await tester.enterText(find.byType(TextFormField).at(1), 'Dev');
    await tester.tap(find.text('Add application'));
    await tester.pumpAndSettle();
    final all = await service.applications.getAll();
    expect(all.length, 1);
    expect(all.first.company, 'Acme');
  });

  testWidgets('edit mode prefills company and role', (tester) async {
    final existing = Application(company: 'Acme', role: 'Dev');
    await tester.pumpWidget(
      MaterialApp(
        home: AddEditApplicationScreen(
          service: service,
          existing: existing,
        ),
      ),
    );
    expect(find.text('Edit application'), findsOneWidget);
    expect(find.text('Acme'), findsOneWidget);
    expect(find.text('Dev'), findsOneWidget);
  });
}
