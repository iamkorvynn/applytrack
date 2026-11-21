import 'package:material_ui/material_ui.dart';

import '../models/application_status.dart';

/// One horizontal bar of the pipeline funnel.
class FunnelBar extends StatelessWidget {
  const FunnelBar({
    super.key,
    required this.status,
    required this.count,
    required this.total,
  });

  final ApplicationStatus status;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : count / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(status.label),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 32,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
