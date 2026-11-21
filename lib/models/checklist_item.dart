/// One interview-prep task attached to an application.
class ChecklistItem {
  ChecklistItem({
    this.id,
    required this.applicationId,
    required this.title,
    this.isDone = false,
    this.sortOrder = 0,
  });

  final int? id;
  final int applicationId;
  final String title;
  final bool isDone;
  final int sortOrder;

  ChecklistItem copyWith({
    int? id,
    int? applicationId,
    String? title,
    bool? isDone,
    int? sortOrder,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'application_id': applicationId,
      'title': title,
      'is_done': isDone ? 1 : 0,
      'sort_order': sortOrder,
    };
  }

  factory ChecklistItem.fromMap(Map<String, Object?> map) {
    return ChecklistItem(
      id: map['id'] as int?,
      applicationId: (map['application_id'] as int?) ?? 0,
      title: (map['title'] as String?) ?? '',
      isDone: (map['is_done'] as int? ?? 0) == 1,
      sortOrder: (map['sort_order'] as int?) ?? 0,
    );
  }
}
