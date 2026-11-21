import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import 'deadline_row.dart';
import 'section_header.dart';

/// "Upcoming deadlines" preview on the dashboard (max 3).
class DashboardDeadlinePreview extends StatelessWidget {
  const DashboardDeadlinePreview({
    super.key,
    required this.upcoming,
    this.onSeeAll,
    this.onOpen,
  });

  final List<Application> upcoming;
  final VoidCallback? onSeeAll;
  final ValueChanged<Application>? onOpen;

  @override
  Widget build(BuildContext context) {
    if (upcoming.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Upcoming deadlines',
          actionLabel: 'See all',
          onAction: onSeeAll,
        ),
        ...upcoming.take(3).map(
              (app) => DeadlineRow(
                application: app,
                onTap: onOpen == null ? null : () => onOpen!(app),
              ),
            ),
      ],
    );
  }
}
