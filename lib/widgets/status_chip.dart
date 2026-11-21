import 'package:material_ui/material_ui.dart';

import '../models/application_status.dart';

/// Small coloured chip showing the pipeline stage.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.small = false});

  final ApplicationStatus status;
  final bool small;

  static Color colorFor(ApplicationStatus status, ColorScheme scheme) {
    switch (status) {
      case ApplicationStatus.wishlist:
        return scheme.surfaceContainerHighest;
      case ApplicationStatus.applied:
        return scheme.primaryContainer;
      case ApplicationStatus.assessment:
        return scheme.secondaryContainer;
      case ApplicationStatus.interview:
        return scheme.tertiaryContainer;
      case ApplicationStatus.offer:
        return Colors.green.shade100;
      case ApplicationStatus.rejected:
        return Colors.red.shade100;
      case ApplicationStatus.withdrawn:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      label: Text(
        status.label,
        style: TextStyle(fontSize: small ? 11 : 12),
      ),
      backgroundColor: colorFor(status, scheme),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
