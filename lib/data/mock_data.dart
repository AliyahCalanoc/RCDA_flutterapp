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
        avatarAsset: 'assets/images/students/Clementine_Kruczynski.jpg',
        age: 22,
        email: 'clementine.k@example.com',
        phone: '+1 202-555-0143',
        address: '12 Lacuna St, Montauk, NY',
        gender: 'Female'),
    StudentModel(
        name: 'Niel Perry',
        course: 'TDC Face to Face',
        classification: '—',
        lastSession: 'Jul 27, 2026',
        avatarAsset: 'assets/images/students/Niel_Perry.jpg',
        age: 24,
        email: 'niel.perry@example.com',
        phone: '+1 202-555-0187',
        address: '45 Welton Ave, Springfield',
        gender: 'Male'),
    StudentModel(
        name: 'Todd Anderson',
        course: 'PDC 4 Wheels',
        classification: 'average',
        lastSession: 'Jul 20, 2026',
        avatarAsset: 'assets/images/students/Todd_Anderson.jpg',
        age: 19,
        email: 'todd.anderson@example.com',
        phone: '+1 202-555-0122',
        address: '9 Welton Ave, Springfield',
        gender: 'Male'),
    StudentModel(
        name: 'Steven Meeks',
        course: 'PDC 4 Wheels',
        classification: 'good',
        lastSession: 'Jul 20, 2026',
        avatarAsset: 'assets/images/students/Steven_Meeks.jpg',
        age: 20,
        email: 'steven.meeks@example.com',
        phone: '+1 202-555-0199',
        address: '77 Welton Ave, Springfield',
        gender: 'Male'),
    StudentModel(
        name: 'Charlie Dalton',
        course: 'TDC Face to Face',
        classification: '—',
        lastSession: 'Jul 22, 2026',
        avatarAsset: 'assets/images/students/Charlie_Dalton.jpg',
        age: 21,
        email: 'charlie.dalton@example.com',
        phone: '+1 202-555-0111',
        address: '3 Welton Ave, Springfield',
        gender: 'Male'),
    StudentModel(
        name: 'Kat Stratford',
        course: 'TDC Face to Face',
        classification: '—',
        lastSession: 'Jul 22, 2026',
        avatarAsset: 'assets/images/students/Kat_Stratford.jpg',
        age: 21,
        email: 'kat.stratford@example.com',
        phone: '(206) 555-0199',
        address: '2715 N Junett St, Tacoma, WA 98407',
        gender: 'Female'),
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
