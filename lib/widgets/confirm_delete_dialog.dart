import 'package:material_ui/material_ui.dart';

/// "Delete this application?" confirmation dialog.
class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key, required this.title});

  final String title;

  static Future<bool> show(BuildContext context, String title) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(title: title),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete?'),
      content: Text(title),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
