import 'package:material_ui/material_ui.dart';

import '../models/interview_round.dart';
import '../utils/formatters.dart';

/// One interview round in the detail screen.
class RoundTile extends StatelessWidget {
  const RoundTile({
    super.key,
    required this.round,
    this.onTap,
    this.onDelete,
  });

  final InterviewRound round;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.video_call),
      title: Text(round.type.label),
      subtitle: Text(
        [
          if (round.scheduledAt != null)
            Formatters.dateTime(round.scheduledAt),
          round.outcome.label,
          if (round.notes.isNotEmpty) round.notes,
        ].join(' · '),
      ),
      trailing: onDelete == null
          ? null
          : IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
      onTap: onTap,
    );
  }
}
