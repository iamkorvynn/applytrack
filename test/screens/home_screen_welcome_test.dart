import 'package:applytrack/data/app_database.dart';
import 'package:applytrack/data/application_dao.dart';
import 'package:applytrack/data/checklist_dao.dart';
import 'package:applytrack/data/interview_dao.dart';
import 'package:applytrack/data/settings_store.dart';
import 'package:applytrack/screens/home_screen.dart';
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
    SharedPreferences.setMockInitialValues({'has_seen_welcome': false});
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

  testWidgets('first run shows the welcome dialog', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          service: service,
          settings: settings,
          themeMode: ThemeMode.system,
          onThemeChanged: (_) {},
        ),
      ),
    );
    // No pumpAndSettle: the loading spinner animates forever.
    await tester.pump();
    await tester.pump();
    await tester.runAsync(
      () async => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();
    expect(find.text('Welcome to ApplyTrack'), findsOneWidget);
    await tester.tap(find.text('Start tracking'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Welcome to ApplyTrack'), findsNothing);
  });
}
