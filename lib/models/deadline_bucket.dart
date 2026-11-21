/// Which group a deadline falls into on the deadlines screen.
enum DeadlineBucket { overdue, today, thisWeek, later, none }

extension DeadlineBucketX on DeadlineBucket {
  String get label {
    switch (this) {
      case DeadlineBucket.overdue:
        return 'Overdue';
      case DeadlineBucket.today:
        return 'Today';
      case DeadlineBucket.thisWeek:
        return 'This week';
      case DeadlineBucket.later:
        return 'Later';
      case DeadlineBucket.none:
        return 'No deadline';
    }
  }
}
