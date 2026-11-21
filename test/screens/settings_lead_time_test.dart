import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/application_dao.dart';
import 'package:applytrack/data/checklist_dao.dart';
import 'package:applytrack/data/interview_dao.dart';
import 'package:applytrack/data/settings_store.dart';
import 'package:applytrack/screens/settings_screen.dart';
import 'package:applytrack/services/application_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late ApplicationService service;
  late SettingsStore settings;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = await AppDatabase.openInMemory();
    service = ApplicationService(
      applications: ApplicationDao(db),
      rounds: InterviewDao(db),
      checklist: ChecklistDao(db),
    );
    settings = await SettingsStore.load();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('reminder lead time picker shows the saved value',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsScreen(
            applications: [],
            themeMode: ThemeMode.system,
            onThemeChanged: (_) {},
            settings: settings,
            service: service,
          ),
        ),
      ),
    );
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('3 days before'), findsOneWidget);
  });
}
