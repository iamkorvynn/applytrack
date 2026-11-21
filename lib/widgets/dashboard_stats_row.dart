import 'package:material_ui/material_ui.dart';

import '../models/app_stats.dart';
import 'stat_card.dart';

/// Four headline numbers on the dashboard.
class DashboardStatsRow extends StatelessWidget {
  const DashboardStatsRow({super.key, required this.stats});

  final AppStats stats;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              label: 'Applied',
              value: '${stats.total}',
              icon: Icons.send,
            ),
          ),
          Expanded(
            child: StatCard(
              label: 'Interviews',
              value: '${stats.interviews}',
              icon: Icons.people,
            ),
          ),
          Expanded(
            child: StatCard(
              label: 'Offers',
              value: '${stats.offers}',
              icon: Icons.emoji_events,
            ),
          ),
          Expanded(
            child: StatCard(
              label: 'This week',
              value: '${stats.appliedThisWeek}',
              icon: Icons.calendar_today,
            ),
          ),
        ],
      ),
    );
  }
}
