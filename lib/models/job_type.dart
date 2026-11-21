/// Full-time job, internship, or part-time role.
enum JobType { fullTime, internship, partTime }

extension JobTypeX on JobType {
  String get label {
    switch (this) {
      case JobType.fullTime:
        return 'Full-time';
      case JobType.internship:
        return 'Internship';
      case JobType.partTime:
        return 'Part-time';
    }
  }
}
