import 'package:material_ui/material_ui.dart';

import '../data/settings_store.dart';
import '../models/application.dart';
import '../models/interview_round.dart';
import '../services/application_service.dart';
import '../services/next_interview.dart';
import '../services/onboarding_service.dart';
import '../widgets/welcome_dialog.dart';
import 'add_edit_application_screen.dart';
import 'application_detail_screen.dart';
import 'applications_screen.dart';
import 'dashboard_screen.dart';
import 'deadlines_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';

/// Bottom-navigation shell: Dashboard, Applications, Deadlines, Stats,
/// Settings. Loads applications from the database and refreshes after
/// every add / edit / delete.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.service,
    required this.settings,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ApplicationService service;
  final SettingsStore settings;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _index = 0;
  List<Application> _applications = [];
  List<InterviewRound> _rounds = [];
  InterviewRound? _nextInterview;
  Application? _nextInterviewApp;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final onboarding = await OnboardingService.load();
      if (!onboarding.hasSeenWelcome && mounted) {
        await WelcomeDialog.show(context);
        await onboarding.markWelcomeSeen();
      }
    });
  }

  Future<void> _refresh() async {
    final apps = await widget.service.applications.getAll();
    final rounds = await widget.service.rounds.getAll();
    if (!mounted) return;
    final next = NextInterview.next(rounds);
    Application? nextApp;
    if (next != null) {
      for (final app in apps) {
        if (app.id == next.applicationId) nextApp = app;
      }
    }
    setState(() {
      _applications = apps;
      _rounds = rounds;
      _nextInterview = next;
      _nextInterviewApp = nextApp;
      _loading = false;
    });
  }

  Future<void> _openAdd() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddEditApplicationScreen(
          service: widget.service,
        ),
      ),
    );
    if (created == true) {
      await _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application added')),
      );
    }
  }

  Future<void> _openDetail(Application app) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => ApplicationDetailScreen(
          application: app,
          service: widget.service,
        ),
      ),
    );
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardScreen(
        applications: _applications,
        onOpen: _openDetail,
        onAdd: _openAdd,
        onSeeAllApplications: () => setState(() => _index = 1),
        onSeeAllDeadlines: () => setState(() => _index = 2),
        nextInterview: _nextInterview,
        nextInterviewApp: _nextInterviewApp,
      ),
      ApplicationsScreen(
        applications: _applications,
        onOpen: _openDetail,
        onAdd: _openAdd,
      ),
      DeadlinesScreen(
        applications: _applications,
        onOpen: _openDetail,
      ),
      StatsScreen(applications: _applications, rounds: _rounds),
      SettingsScreen(
        applications: _applications,
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
        settings: widget.settings,
        service: widget.service,
      ),
    ];
    final titles = [
      'ApplyTrack',
      'Applications',
      'Deadlines',
      'Stats',
      'Settings',
    ];
    return Scaffold(
      appBar: AppBar(title: Text(titles[_index])),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : pages[_index],
      floatingActionButton: _index == 1 || _index == 0
          ? FloatingActionButton(
              onPressed: _openAdd,
              tooltip: 'Add application',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Applications',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Deadlines',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
