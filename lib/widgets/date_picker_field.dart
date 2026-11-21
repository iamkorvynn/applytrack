import 'package:material_ui/material_ui.dart';

import '../utils/formatters.dart';

/// A date row used in forms: label, current value, pick/clear buttons.
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onPick,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onPick;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(Formatters.date(value)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear $label',
              onPressed: () => onPick(null),
            ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Pick $label',
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: value ?? now,
                firstDate: DateTime(now.year - 2),
                lastDate: DateTime(now.year + 2),
              );
              if (picked != null) onPick(picked);
            },
          ),
        ],
      ),
    );
  }
}
