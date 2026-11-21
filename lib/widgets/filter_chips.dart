import 'package:material_ui/material_ui.dart';

import '../models/application_status.dart';

/// One selectable chip per pipeline status.
class StatusFilterChips extends StatelessWidget {
  const StatusFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<ApplicationStatus> selected;
  final ValueChanged<Set<ApplicationStatus>> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ApplicationStatus.values.map((status) {
          final isSelected = selected.contains(status);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(status.label),
              selected: isSelected,
              onSelected: (value) {
                final next = Set<ApplicationStatus>.from(selected);
                if (value) {
                  next.add(status);
                } else {
                  next.remove(status);
                }
                onChanged(next);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
