import 'package:material_ui/material_ui.dart';

import '../models/checklist_item.dart';

/// One prep task with a checkbox.
class ChecklistTile extends StatelessWidget {
  const ChecklistTile({
    super.key,
    required this.item,
    this.onToggle,
    this.onDelete,
  });

  final ChecklistItem item;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: item.isDone,
      onChanged: onToggle == null ? null : (_) => onToggle!(),
      title: Text(
        item.title,
        style: item.isDone
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      secondary: onDelete == null
          ? null
          : IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
    );
  }
}
