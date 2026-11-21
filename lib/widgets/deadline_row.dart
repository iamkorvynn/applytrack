import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../utils/formatters.dart';

/// One deadline line: company, role, relative day.
class DeadlineRow extends StatelessWidget {
  const DeadlineRow({
    super.key,
    required this.application,
    this.onTap,
  });

  final Application application;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final overdue = application.isDeadlineOverdue();
    return ListTile(
      leading: Icon(
        Icons.event,
        color: overdue ? Theme.of(context).colorScheme.error : null,
      ),
      title: Text('${application.company} — ${application.role}'),
      subtitle: Text(
        application.deadline == null
            ? 'No deadline'
            : Formatters.relativeDay(application.deadline!),
      ),
      trailing: overdue
          ? const Icon(Icons.warning_amber_rounded)
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
