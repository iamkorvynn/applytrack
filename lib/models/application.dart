import 'application_status.dart';
import 'job_type.dart';
import 'salary_period.dart';
import 'source.dart';
import 'work_mode.dart';
import '../utils/app_dates.dart';

/// One job or internship application. Stored in SQLite, all local.
class Application {
  Application({
    this.id,
    required this.company,
    required this.role,
    this.jobType = JobType.fullTime,
    this.workMode = WorkMode.onsite,
    this.city = '',
    this.salaryMin = 0,
    this.salaryMax = 0,
    this.salaryPeriod = SalaryPeriod.monthly,
    this.jobUrl = '',
    this.source = ApplicationSource.other,
    this.dateApplied,
    this.deadline,
    this.status = ApplicationStatus.wishlist,
    this.followUpDate,
    this.contactName = '',
    this.contactEmail = '',
    this.resumeVersion = '',
    this.notes = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  final int? id;
  final String company;
  final String role;
  final JobType jobType;
  final WorkMode workMode;
  final String city;
  final int salaryMin;
  final int salaryMax;
  final SalaryPeriod salaryPeriod;
  final String jobUrl;
  final ApplicationSource source;
  final DateTime? dateApplied;
  final DateTime? deadline;
  final ApplicationStatus status;
  final DateTime? followUpDate;
  final String contactName;
  final String contactEmail;
  final String resumeVersion;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasSalary => salaryMin > 0 || salaryMax > 0;
  bool get hasDeadline => deadline != null;
  bool get hasJobUrl => jobUrl.trim().isNotEmpty;
  bool get hasContact => contactName.trim().isNotEmpty;

  /// Whole days until the deadline. Negative when overdue.
  int? daysUntilDeadline({DateTime? now}) {
    if (deadline == null) return null;
    return AppDates.daysBetween(now ?? DateTime.now(), deadline!);
  }

  bool isDeadlineOverdue({DateTime? now}) {
    final days = daysUntilDeadline(now: now);
    return days != null && days < 0 && !status.isTerminal;
  }

  bool isFollowUpDue({DateTime? now}) {
    if (followUpDate == null) return false;
    if (status.isTerminal) return false;
    return AppDates.daysBetween(now ?? DateTime.now(), followUpDate!) <= 0;
  }

  /// "Bengaluru · Hybrid" or just "Remote".
  String get displayLocation {
    if (workMode == WorkMode.remote) return 'Remote';
    if (city.trim().isEmpty) return workMode.label;
    return '${city.trim()} \u00b7 ${workMode.label}';
  }

  Application copyWith({
    int? id,
    String? company,
    String? role,
    JobType? jobType,
    WorkMode? workMode,
    String? city,
    int? salaryMin,
    int? salaryMax,
    SalaryPeriod? salaryPeriod,
    String? jobUrl,
    ApplicationSource? source,
    DateTime? dateApplied,
    DateTime? deadline,
    ApplicationStatus? status,
    DateTime? followUpDate,
    String? contactName,
    String? contactEmail,
    String? resumeVersion,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Application(
      id: id ?? this.id,
      company: company ?? this.company,
      role: role ?? this.role,
      jobType: jobType ?? this.jobType,
      workMode: workMode ?? this.workMode,
      city: city ?? this.city,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      jobUrl: jobUrl ?? this.jobUrl,
      source: source ?? this.source,
      dateApplied: dateApplied ?? this.dateApplied,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      followUpDate: followUpDate ?? this.followUpDate,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      resumeVersion: resumeVersion ?? this.resumeVersion,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'company': company,
      'role': role,
      'job_type': jobType.name,
      'work_mode': workMode.name,
      'city': city,
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'salary_period': salaryPeriod.name,
      'job_url': jobUrl,
      'source': source.name,
      'date_applied': dateApplied?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'status': status.name,
      'follow_up_date': followUpDate?.toIso8601String(),
      'contact_name': contactName,
      'contact_email': contactEmail,
      'resume_version': resumeVersion,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Application.fromMap(Map<String, Object?> map) {
    T enumByName<T>(List<T> values, Object? raw, T fallback) {
      if (raw is String) {
        for (final value in values) {
          if ((value as Enum).name == raw) return value;
        }
      }
      return fallback;
    }

    DateTime? parseDate(Object? raw) {
      if (raw is String && raw.isNotEmpty) {
        return DateTime.tryParse(raw);
      }
      return null;
    }

    return Application(
      id: map['id'] as int?,
      company: (map['company'] as String?) ?? '',
      role: (map['role'] as String?) ?? '',
      jobType: enumByName(JobType.values, map['job_type'], JobType.fullTime),
      workMode:
          enumByName(WorkMode.values, map['work_mode'], WorkMode.onsite),
      city: (map['city'] as String?) ?? '',
      salaryMin: (map['salary_min'] as int?) ?? 0,
      salaryMax: (map['salary_max'] as int?) ?? 0,
      salaryPeriod: enumByName(
        SalaryPeriod.values,
        map['salary_period'],
        SalaryPeriod.monthly,
      ),
      jobUrl: (map['job_url'] as String?) ?? '',
      source: enumByName(
        ApplicationSource.values,
        map['source'],
        ApplicationSource.other,
      ),
      dateApplied: parseDate(map['date_applied']),
      deadline: parseDate(map['deadline']),
      status: enumByName(
        ApplicationStatus.values,
        map['status'],
        ApplicationStatus.wishlist,
      ),
      followUpDate: parseDate(map['follow_up_date']),
      contactName: (map['contact_name'] as String?) ?? '',
      contactEmail: (map['contact_email'] as String?) ?? '',
      resumeVersion: (map['resume_version'] as String?) ?? '',
      notes: (map['notes'] as String?) ?? '',
      createdAt: parseDate(map['created_at']) ?? DateTime.now(),
      updatedAt: parseDate(map['updated_at']) ?? DateTime.now(),
    );
  }
}
