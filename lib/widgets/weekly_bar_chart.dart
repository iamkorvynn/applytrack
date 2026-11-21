import 'package:material_ui/material_ui.dart';

import '../models/app_stats.dart';
import '../utils/formatters.dart';

/// Simple bar chart of applications per week, built with plain widgets
/// (no heavy chart dependency).
class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({super.key, required this.weeks});

  final List<WeeklyCount> weeks;

  @override
  Widget build(BuildContext context) {
    if (weeks.isEmpty) {
      return const Text('No applications yet.');
    }
    var max = 0;
    for (final week in weeks) {
      if (week.count > max) max = week.count;
    }
    if (max == 0) return const Text('No applications yet.');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: weeks.map((week) {
        final height = 8.0 + (week.count / max) * 72.0;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${week.count}'),
                const SizedBox(height: 4),
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.shortDate(week.weekStart),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
