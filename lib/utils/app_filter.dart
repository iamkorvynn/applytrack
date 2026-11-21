import '../models/application.dart';
import '../models/application_status.dart';
import '../models/job_type.dart';
import '../models/source.dart';
import 'sort_options.dart';

/// Search + filter state for the applications list.
class AppFilter {
  AppFilter({
    this.query = '',
    this.statuses = const {},
    this.types = const {},
    this.sources = const {},
    this.sort = SortOption.deadlineAsc,
  });

  final String query;
  final Set<ApplicationStatus> statuses;
  final Set<JobType> types;
  final Set<ApplicationSource> sources;
  final SortOption sort;

  bool get isEmpty =>
      query.trim().isEmpty &&
      statuses.isEmpty &&
      types.isEmpty &&
      sources.isEmpty;

  AppFilter copyWith({
    String? query,
    Set<ApplicationStatus>? statuses,
    Set<JobType>? types,
    Set<ApplicationSource>? sources,
    SortOption? sort,
  }) {
    return AppFilter(
      query: query ?? this.query,
      statuses: statuses ?? this.statuses,
      types: types ?? this.types,
      sources: sources ?? this.sources,
      sort: sort ?? this.sort,
    );
  }

  List<Application> apply(List<Application> applications) {
    final q = query.trim().toLowerCase();
    final filtered = applications.where((app) {
      if (q.isNotEmpty) {
        final haystack =
            '${app.company} ${app.role} ${app.city}'.toLowerCase();
        if (!haystack.contains(q)) return false;
      }
      if (statuses.isNotEmpty && !statuses.contains(app.status)) {
        return false;
      }
      if (types.isNotEmpty && !types.contains(app.jobType)) return false;
      if (sources.isNotEmpty && !sources.contains(app.source)) return false;
      return true;
    }).toList();
    filtered.sort(sort.compare);
    return filtered;
  }
}
