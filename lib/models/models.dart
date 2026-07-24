// Simple static data models — no backend, everything is mock/in-memory
// since this app is a static UI prototype for presentation purposes.

class StudentModel {
  final String name;
  final String course;
  final String classification; // '', 'average', 'fast', 'needs improvement'
  final String lastSession;
  final String?
      avatarAsset; // local asset image path — null falls back to initials

  const StudentModel({
    required this.name,
    required this.course,
    required this.classification,
    required this.lastSession,
    this.avatarAsset,
  });
}

class ScheduleItem {
  final String date;
  final String course;
  final String time;
  final String venue;
  final String status; // Open / Closed

  const ScheduleItem({
    required this.date,
    required this.course,
    required this.time,
    required this.venue,
    required this.status,
  });
}

class SkillRating {
  final String name;
  double stars; // 0-5
  String note; // Perfect / Average / Low

  SkillRating({required this.name, this.stars = 3, this.note = ''});
}

class AssessmentRecord {
  final String student;
  final String date;
  final String score;
  final String level;

  const AssessmentRecord({
    required this.student,
    required this.date,
    required this.score,
    required this.level,
  });
}
