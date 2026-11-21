import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../utils/money.dart';
import '../utils/salary_insights.dart';

/// Median / min / max pay card for the stats screen.
class SalaryInsightsCard extends StatelessWidget {
  const SalaryInsightsCard({super.key, required this.applications});

  final List<Application> applications;

  @override
  Widget build(BuildContext context) {
    final median = SalaryInsights.medianAnnual(applications);
    final min = SalaryInsights.minAnnual(applications);
    final max = SalaryInsights.maxAnnual(applications);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: median == null
            ? const Text('Add salaries to your applications to see pay insights.')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Median top pay: ${Money.formatINR(median)} / year',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Range: ${Money.formatINR(min!)} — ${Money.formatINR(max!)} / year',
                  ),
                ],
              ),
      ),
    );
  }
}
