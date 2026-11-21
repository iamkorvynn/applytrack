import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../utils/formatters.dart';
import '../utils/string_utils.dart';
import 'salary_text.dart';
import 'status_chip.dart';

/// One application in a list. Tap opens the detail screen.
class ApplicationCard extends StatelessWidget {
  const ApplicationCard({
    super.key,
    required this.application,
    this.onTap,
  });

  final Application application;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final overdue = application.isDeadlineOverdue();
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                child: Text(StringUtils.initials(application.company)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.role,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${application.company} · ${application.displayLocation}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        StatusChip(status: application.status, small: true),
                        const SizedBox(width: 8),
                        if (application.hasSalary)
                          SalaryText(application: application),
                      ],
                    ),
                    if (application.deadline != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          overdue
                              ? 'Deadline was ${Formatters.relativeDay(application.deadline!)}'
                              : 'Deadline ${Formatters.relativeDay(application.deadline!)}',
                          style: TextStyle(
                            color: overdue
                                ? Theme.of(context).colorScheme.error
                                : null,
                            fontWeight:
                                overdue ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
