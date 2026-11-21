/// One round in an application's interview process.
enum RoundType { hr, technical, managerial, assignment, finalRound }

extension RoundTypeX on RoundType {
  String get label {
    switch (this) {
      case RoundType.hr:
        return 'HR round';
      case RoundType.technical:
        return 'Technical round';
      case RoundType.managerial:
        return 'Managerial round';
      case RoundType.assignment:
        return 'Assignment';
      case RoundType.finalRound:
        return 'Final round';
    }
  }
}

enum RoundOutcome { scheduled, completed, cleared, rejected }

extension RoundOutcomeX on RoundOutcome {
  String get label {
    switch (this) {
      case RoundOutcome.scheduled:
        return 'Scheduled';
      case RoundOutcome.completed:
        return 'Completed';
      case RoundOutcome.cleared:
        return 'Cleared';
      case RoundOutcome.rejected:
        return 'Rejected';
    }
  }
}

class InterviewRound {
  InterviewRound({
    this.id,
    required this.applicationId,
    this.type = RoundType.hr,
    this.scheduledAt,
    this.notes = '',
    this.outcome = RoundOutcome.scheduled,
  });

  final int? id;
  final int applicationId;
  final RoundType type;
  final DateTime? scheduledAt;
  final String notes;
  final RoundOutcome outcome;

  bool get isDone =>
      outcome == RoundOutcome.completed ||
      outcome == RoundOutcome.cleared ||
      outcome == RoundOutcome.rejected;

  bool get isUpcoming {
    if (scheduledAt == null) return false;
    return scheduledAt!.isAfter(DateTime.now()) &&
        outcome == RoundOutcome.scheduled;
  }

  InterviewRound copyWith({
    int? id,
    int? applicationId,
    RoundType? type,
    DateTime? scheduledAt,
    String? notes,
    RoundOutcome? outcome,
  }) {
    return InterviewRound(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      type: type ?? this.type,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      notes: notes ?? this.notes,
      outcome: outcome ?? this.outcome,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'application_id': applicationId,
      'type': type.name,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'notes': notes,
      'outcome': outcome.name,
    };
  }

  factory InterviewRound.fromMap(Map<String, Object?> map) {
    T byName<T>(List<T> values, Object? raw, T fallback) {
      if (raw is String) {
        for (final value in values) {
          if ((value as Enum).name == raw) return value;
        }
      }
      return fallback;
    }

    DateTime? parseDate(Object? raw) {
      if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
      return null;
    }

    return InterviewRound(
      id: map['id'] as int?,
      applicationId: (map['application_id'] as int?) ?? 0,
      type: byName(RoundType.values, map['type'], RoundType.hr),
      scheduledAt: parseDate(map['scheduled_at']),
      notes: (map['notes'] as String?) ?? '',
      outcome:
          byName(RoundOutcome.values, map['outcome'], RoundOutcome.scheduled),
    );
  }
}
