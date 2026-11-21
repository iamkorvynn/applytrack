import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../models/interview_round.dart';
import '../utils/formatters.dart';

/// Card showing the next scheduled interview, if there is one.
class NextInterviewCard extends StatelessWidget {
  const NextInterviewCard({
    super.key,
    required this.round,
    required this.application,
    this.onTap,
  });

  final InterviewRound round;
  final Application application;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.video_call),
        title: Text(
          'Next interview: ${application.company}',
        ),
        subtitle: Text(
          '${round.type.label} · ${Formatters.dateTime(round.scheduledAt)}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
