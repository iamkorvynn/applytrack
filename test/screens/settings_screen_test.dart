import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/application_dao.dart';
import 'package:applytrack/data/checklist_dao.dart';
import 'package:applytrack/data/interview_dao.dart';
import 'package:applytrack/data/settings_store.dart';
import 'package:applytrack/models/application.dart';
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

  Future<void> pumpSettings(
    WidgetTester tester, {
    List<Application> applications = const [],
    ThemeMode themeMode = ThemeMode.system,
    ValueChanged<ThemeMode>? onThemeChanged,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsScreen(
            applications: applications,
            themeMode: themeMode,
            onThemeChanged: onThemeChanged ?? (_) {},
            settings: settings,
            service: service,
          ),
        ),
      ),
    );
  }

  testWidgets('shows theme choices and export row', (tester) async {
    await pumpSettings(
      tester,
      applications: [Application(company: 'Acme', role: 'Dev')],
    );
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Export as CSV'), findsOneWidget);
  });

  testWidgets('tapping a theme calls onThemeChanged', (tester) async {
    ThemeMode? picked;
    await pumpSettings(
      tester,
      onThemeChanged: (mode) => picked = mode,
    );
    await tester.tap(find.text('Dark'));
    expect(picked, ThemeMode.dark);
  });
}
