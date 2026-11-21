import '../models/application.dart';
import '../models/application_status.dart';
import 'application_age.dart';
import '../models/job_type.dart';
import '../models/salary_period.dart';
import '../models/source.dart';
import '../models/work_mode.dart';
import 'money.dart';

/// Build a CSV export of applications. Fields with commas, quotes or
/// newlines are quoted per RFC 4180.
class CsvBuilder {
  static const List<String> headers = [
    'Company',
    'Role',
    'Type',
    'Work mode',
    'City',
    'Salary min (INR)',
    'Salary max (INR)',
    'Salary period',
    'Source',
    'Status',
    'Date applied',
    'Deadline',
    'Follow-up date',
    'Contact',
    'Job link',
    'Resume version',
    'Notes',
    'Days since applied',
  ];

  static String escape(String value) {
    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String _date(DateTime? date) {
    if (date == null) return '';
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String build(List<Application> applications) {
    final lines = <String>[headers.map(escape).join(',')];
    for (final app in applications) {
      final row = [
        app.company,
        app.role,
        app.jobType.label,
        app.workMode.label,
        app.city,
        app.salaryMin.toString(),
        app.salaryMax.toString(),
        app.salaryPeriod.label,
        app.source.label,
        app.status.label,
        _date(app.dateApplied),
        _date(app.deadline),
        _date(app.followUpDate),
        app.contactName,
        app.jobUrl,
        app.resumeVersion,
        app.notes,
        ApplicationAge.daysSinceApplied(app)?.toString() ?? '',
      ];
      lines.add(row.map(escape).join(','));
    }
    return lines.join('\n');
  }

  /// One-line summary used on the export screen.
  static String summary(List<Application> applications) {
    if (applications.isEmpty) return 'No applications to export yet.';
    return '${applications.length} application(s) ready to export as CSV.';
  }
}

/// Re-exported helper so screens can format a salary without importing
/// the whole money module twice in tests.
String salaryLabelFor(Application app) => Money.formatSalaryRange(
      app.salaryMin,
      app.salaryMax,
      app.salaryPeriod.label,
    );
