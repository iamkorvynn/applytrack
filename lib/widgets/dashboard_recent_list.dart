import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import 'application_card.dart';
import 'section_header.dart';

/// "Recent applications" preview on the dashboard (max 3).
class DashboardRecentList extends StatelessWidget {
  const DashboardRecentList({
    super.key,
    required this.applications,
    this.onSeeAll,
    this.onOpen,
  });

  final List<Application> applications;
  final VoidCallback? onSeeAll;
  final ValueChanged<Application>? onOpen;

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent applications',
          actionLabel: 'See all',
          onAction: onSeeAll,
        ),
        ...applications.take(3).map(
              (app) => ApplicationCard(
                application: app,
                onTap: onOpen == null ? null : () => onOpen!(app),
              ),
            ),
      ],
    );
  }
}
