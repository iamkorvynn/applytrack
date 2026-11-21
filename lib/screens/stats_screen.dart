import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../models/application_status.dart';
import '../models/source.dart';
import '../services/stats_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/funnel_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/weekly_bar_chart.dart';

/// Funnel, weekly chart, response rate, top sources.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key, required this.applications});

  final List<Application> applications;

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) {
      return const EmptyState(
        icon: Icons.bar_chart,
        title: 'No stats yet',
        message: 'Stats appear once you add applications and move them '
            'through the pipeline.',
      );
    }
    final stats = StatsService.compute(applications);
    final rate = (stats.responseRate * 100).round();
    return ListView(
      children: [
        const SectionHeader(title: 'Pipeline funnel'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: ApplicationStatus.values
                .where((status) => !status.isTerminal)
                .map(
                  (status) => FunnelBar(
                    status: status,
                    count: stats.countFor(status),
                    total: stats.total,
                  ),
                )
                .toList(),
          ),
        ),
        const SectionHeader(title: 'Applications per week'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: WeeklyBarChart(weeks: stats.weeklyCounts),
        ),
        const SectionHeader(title: 'Response rate'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$rate% of applications moved past the Applied stage. '
            '${stats.interviews} reached interview, '
            '${stats.offers} became offers.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SectionHeader(title: 'Top sources'),
        ...stats.topSources.map(
          (entry) => ListTile(
            leading: const Icon(Icons.public),
            title: Text(entry.source.label),
            trailing: Text('${entry.count}'),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
