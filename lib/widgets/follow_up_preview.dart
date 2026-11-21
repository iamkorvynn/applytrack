import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../utils/formatters.dart';
import 'section_header.dart';

/// Applications that need a follow-up nudge.
class FollowUpPreview extends StatelessWidget {
  const FollowUpPreview({
    super.key,
    required this.applications,
    this.onOpen,
  });

  final List<Application> applications;
  final ValueChanged<Application>? onOpen;

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Needs a follow-up'),
        ...applications.take(3).map(
              (app) => ListTile(
                leading: const Icon(Icons.reply),
                title: Text('${app.company} — ${app.role}'),
                subtitle: Text(
                  app.followUpDate == null
                      ? 'Applied ${Formatters.date(app.dateApplied)}'
                      : 'Follow-up was ${Formatters.date(app.followUpDate)}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: onOpen == null ? null : () => onOpen!(app),
              ),
            ),
      ],
    );
  }
}
