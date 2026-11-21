import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../utils/csv_builder.dart';

/// "Rs.45,000 - Rs.60,000 per month" for an application card.
class SalaryText extends StatelessWidget {
  const SalaryText({super.key, required this.application});

  final Application application;

  @override
  Widget build(BuildContext context) {
    final label = salaryLabelFor(application);
    if (label.isEmpty) return const SizedBox.shrink();
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
