import 'package:material_ui/material_ui.dart';

import '../models/application_status.dart';

/// Dropdown to change an application's pipeline stage.
class StatusPicker extends StatelessWidget {
  const StatusPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ApplicationStatus value;
  final ValueChanged<ApplicationStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ApplicationStatus>(
      key: ValueKey(value),
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Status'),
      items: ApplicationStatus.values
          .map(
            (status) => DropdownMenuItem(
              value: status,
              child: Text(status.label),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
