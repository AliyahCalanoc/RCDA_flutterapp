import '../models/models.dart';

/// Static mock data — mirrors the RC Driving Academy web instructor
/// dashboard (Mario Santos, 7 assigned students, PDC/TDC sessions).
class MockData {
  static const instructorName = 'Joel Barish';
  static const instructorRole = 'Instructor · RCDA';
  static const initials = 'JB';

  // Local asset photo — put the real file at this exact path in your project.
  static const instructorAvatarAsset =
      'assets/images/instructor/Joel_Barish.jpg';

  static const sessionsToday = 0;
  static const upcomingSessions = 3;

  static const List<StudentModel> students = [
    StudentModel(
        name: 'Clementine Kruczynski',
        course: 'TDC Face to Face',
        classification: '—',
        lastSession: 'Aug 3, 2026',
        avatarAsset: 'assets/images/students/Clementine_Kruczynski.jpg'),
    StudentModel(
        name: 'Niel Perry',
        course: 'TDC Face to Face',
        classification: '—',
        lastSession: 'Jul 27, 2026',
        avatarAsset: 'assets/images/students/Niel_Perry.jpg'),
    StudentModel(
        name: 'Todd_Anderson',
        course: 'PDC 4 Wheels',
        classification: 'average',
        lastSession: 'Jul 20, 2026',
        avatarAsset: 'assets/images/students/Todd_Anderson.jpg'),
    StudentModel(
        name: 'Steven Meeks',
        course: 'PDC 4 Wheels',
        classification: '—',
        lastSession: 'Jul 20, 2026',
        avatarAsset: 'assets/images/students/Steven_Meeks.jpg'),
    StudentModel(
        name: 'Charlie Dalton',
        course: 'Assigned',
        classification: '—',
        lastSession: '—',
        avatarAsset: 'assets/images/students/Charlie_Dalton.jpg'),
  ];

  static const List<ScheduleItem> schedule = [
    ScheduleItem(
        date: 'Jul 27, 2026',
        course: 'TDC Face to Face',
        time: '8:00 AM – 10:00 AM',
        venue: 'RC Driving Academy — Main Branch',
        status: 'Open'),
    ScheduleItem(
        date: 'Jul 29, 2026',
        course: 'PDC 4 Wheels',
        time: '11:00 AM – 1:00 PM',
        venue: 'RC Driving Academy — Driving Range',
        status: 'Open'),
    ScheduleItem(
        date: 'Aug 3, 2026',
        course: 'TDC Face to Face',
        time: '1:00 PM – 3:00 PM',
        venue: 'RC Driving Academy — Main Branch',
        status: 'Open'),
  ];

  static List<String> get sessionOptions =>
      schedule.map((s) => '${s.course} · ${s.date}').toList();

  static List<String> get studentNames => students.map((s) => s.name).toList();

  static List<SkillRating> defaultSkills() => [
        SkillRating(name: 'Steering Control', stars: 5),
        SkillRating(name: 'Speed Management', stars: 4),
        SkillRating(name: 'Lane Discipline', stars: 5),
        SkillRating(name: 'Parking', stars: 4),
        SkillRating(name: 'Safety Awareness', stars: 5),
        SkillRating(name: 'Mirror & Observation', stars: 4),
      ];

  // Mutable in-memory list so "Save Assessment" can append to it for the demo.
  static final List<AssessmentRecord> recentAssessments = [];
}
