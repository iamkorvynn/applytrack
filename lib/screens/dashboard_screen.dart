import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../models/interview_round.dart';
import '../services/deadline_service.dart';
import '../services/follow_up_helper.dart';
import '../services/stats_service.dart';
import '../widgets/dashboard_deadline_preview.dart';
import '../widgets/dashboard_recent_list.dart';
import '../widgets/dashboard_stats_row.dart';
import '../widgets/empty_state.dart';
import '../widgets/follow_up_preview.dart';
import '../widgets/next_interview_card.dart';

/// Overview: headline numbers, upcoming deadlines, recent applications.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.applications,
    this.onOpen,
    this.onAdd,
    this.onSeeAllApplications,
    this.onSeeAllDeadlines,
    this.nextInterview,
    this.nextInterviewApp,
  });

  final List<Application> applications;
  final ValueChanged<Application>? onOpen;
  final VoidCallback? onAdd;
  final VoidCallback? onSeeAllApplications;
  final VoidCallback? onSeeAllDeadlines;
  final InterviewRound? nextInterview;
  final Application? nextInterviewApp;

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
    final followUps = FollowUpHelper.needingFollowUp(applications);
    final recent = List<Application>.from(applications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return ListView(
      children: [
        const SizedBox(height: 12),
        DashboardStatsRow(stats: stats),
        if (nextInterview != null && nextInterviewApp != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: NextInterviewCard(
              round: nextInterview!,
              application: nextInterviewApp!,
              onTap: onOpen == null
                  ? null
                  : () => onOpen!(nextInterviewApp!),
            ),
          ),
        FollowUpPreview(applications: followUps, onOpen: onOpen),
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
