import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../models/deadline_bucket.dart';
import '../services/deadline_service.dart';
import '../widgets/deadline_row.dart';
import '../widgets/empty_state.dart';

/// Deadlines grouped: overdue, today, this week, later, no deadline.
class DeadlinesScreen extends StatelessWidget {
  const DeadlinesScreen({
    super.key,
    required this.applications,
    this.onOpen,
  });

  final List<Application> applications;
  final ValueChanged<Application>? onOpen;

  @override
  Widget build(BuildContext context) {
    final grouped = DeadlineService.group(applications);
    final hasAny = grouped.values.any((list) => list.isNotEmpty);
    if (!hasAny) {
      return const EmptyState(
        icon: Icons.event_available,
        title: 'No deadlines',
        message: 'Add a deadline to an application and it will show up '
            'here, with a reminder before it closes.',
      );
    }
    final sections = <Widget>[];
    for (final bucket in DeadlineBucket.values) {
      final list = grouped[bucket]!;
      if (list.isEmpty) continue;
      sections.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            '${bucket.label} (${list.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
      for (final app in list) {
        sections.add(
          DeadlineRow(
            application: app,
            onTap: onOpen == null ? null : () => onOpen!(app),
          ),
        );
      }
    }
    return ListView(children: sections);
  }
}
