import 'package:material_ui/material_ui.dart';

/// First-run welcome: what ApplyTrack does, in three lines.
class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const WelcomeDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Welcome to ApplyTrack'),
      content: const Text(
        'Track every job and internship application in one place: '
        'the pipeline, deadlines with reminders, interview rounds '
        'with prep checklists, and stats. Your data stays on this '
        'device — there are no accounts and no demo data. Add your '
        'first real application to get started.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Start tracking'),
        ),
      ],
    );
  }
}
