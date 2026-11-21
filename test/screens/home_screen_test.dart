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
    SharedPreferences.setMockInitialValues({'has_seen_welcome': true});
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

  Future<void> pumpHome(WidgetTester tester) async {
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
    await tester.pump();
    // HomeScreen loads from SQLite in initState; that work needs the
    // real event loop, so let it finish before rendering assertions.
    // (No pumpAndSettle here: the loading spinner animates forever.)
    await tester.runAsync(
      () async => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('shows dashboard empty state at first', (tester) async {
    await pumpHome(tester);
    expect(find.text('ApplyTrack'), findsOneWidget);
    expect(find.text('No applications yet'), findsOneWidget);
  });

  testWidgets('tapping Deadlines tab shows deadlines', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.text('Deadlines'));
    await tester.pumpAndSettle();
    expect(find.text('No deadlines'), findsOneWidget);
  });

  testWidgets('tapping the add button opens the form', (tester) async {
    await pumpHome(tester);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Add application'), findsWidgets);
  });
}
