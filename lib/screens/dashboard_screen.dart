import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../services/deadline_service.dart';
import '../services/stats_service.dart';
import '../widgets/dashboard_deadline_preview.dart';
import '../widgets/dashboard_recent_list.dart';
import '../widgets/dashboard_stats_row.dart';
import '../widgets/empty_state.dart';

/// Overview: headline numbers, upcoming deadlines, recent applications.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.applications,
    this.onOpen,
    this.onAdd,
    this.onSeeAllApplications,
    this.onSeeAllDeadlines,
  });

  final List<Application> applications;
  final ValueChanged<Application>? onOpen;
  final VoidCallback? onAdd;
  final VoidCallback? onSeeAllApplications;
  final VoidCallback? onSeeAllDeadlines;

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) {
      return EmptyState(
        icon: Icons.work_outline,
        title: 'No applications yet',
        message: 'Add your first real application to start tracking '
            'jobs and internships. Nothing here is demo data.',
        actionLabel: 'Add application',
        onAction: onAdd,
      );
    }
    final stats = StatsService.compute(applications);
    final upcoming = DeadlineService.upcoming(applications);
    final recent = List<Application>.from(applications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return ListView(
      children: [
        const SizedBox(height: 12),
        DashboardStatsRow(stats: stats),
        DashboardDeadlinePreview(
          upcoming: upcoming,
          onSeeAll: onSeeAllDeadlines,
          onOpen: onOpen,
        ),
        DashboardRecentList(
          applications: recent,
          onSeeAll: onSeeAllApplications,
          onOpen: onOpen,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
