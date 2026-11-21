import 'package:material_ui/material_ui.dart';

import 'data/app_database.dart';
import 'data/application_dao.dart';
import 'data/checklist_dao.dart';
import 'data/interview_dao.dart';
import 'data/settings_store.dart';
import 'screens/home_screen.dart';
import 'services/application_service.dart';
import 'theme/app_theme.dart';

/// Root widget. Loads saved theme, then shows the home shell.
class ApplyTrackApp extends StatefulWidget {
  const ApplyTrackApp({super.key});

  @override
  State<ApplyTrackApp> createState() => _ApplyTrackAppState();
}

class _ApplyTrackAppState extends State<ApplyTrackApp> {
  ThemeMode _themeMode = ThemeMode.system;
  ApplicationService? _service;
  SettingsStore? _settings;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = await AppDatabase.instance.database;
    final settings = await SettingsStore.load();
    final service = ApplicationService(
      applications: ApplicationDao(db),
      rounds: InterviewDao(db),
      checklist: ChecklistDao(db),
    );
    if (!mounted) return;
    setState(() {
      _themeMode = settings.themeMode;
      _settings = settings;
      _service = service;
    });
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    await _settings?.setThemeMode(mode);
    if (!mounted) return;
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    final service = _service;
    return MaterialApp(
      title: 'ApplyTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: service == null
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : HomeScreen(
              service: service,
              settings: _settings!,
              themeMode: _themeMode,
              onThemeChanged: _changeTheme,
            ),
    );
  }
}
