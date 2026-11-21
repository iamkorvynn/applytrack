import 'package:material_ui/material_ui.dart';

import '../models/application.dart';
import '../utils/app_filter.dart';
import '../utils/sort_options.dart';
import '../widgets/app_search_field.dart';
import '../widgets/application_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/filter_chips.dart';

/// Searchable, filterable, sortable list of all applications.
class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({
    super.key,
    required this.applications,
    this.onOpen,
    this.onAdd,
  });

  final List<Application> applications;
  final ValueChanged<Application>? onOpen;
  final VoidCallback? onAdd;

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  final _searchController = TextEditingController();
  var _filter = AppFilter();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filter.apply(widget.applications);
    return Column(
      children: [
        AppSearchField(
          controller: _searchController,
          onChanged: (value) {
            setState(() => _filter = _filter.copyWith(query: value));
          },
        ),
        StatusFilterChips(
          selected: _filter.statuses,
          onChanged: (statuses) {
            setState(() => _filter = _filter.copyWith(statuses: statuses));
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Text('${visible.length} application(s)'),
              const Spacer(),
              DropdownButton<SortOption>(
                value: _filter.sort,
                items: SortOption.values
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
                onChanged: (option) {
                  if (option == null) return;
                  setState(() => _filter = _filter.copyWith(sort: option));
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? EmptyState(
                  icon: Icons.search_off,
                  title: widget.applications.isEmpty
                      ? 'No applications yet'
                      : 'Nothing matches',
                  message: widget.applications.isEmpty
                      ? 'Add your first real application.'
                      : 'Try a different search or clear the filters.',
                  actionLabel: widget.applications.isEmpty
                      ? 'Add application'
                      : null,
                  onAction: widget.onAdd,
                )
              : ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (context, index) {
                    final app = visible[index];
                    return ApplicationCard(
                      application: app,
                      onTap:
                          widget.onOpen == null ? null : () => widget.onOpen!(app),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
