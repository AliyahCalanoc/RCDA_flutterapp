# RCDA Instructor App (Static Prototype)

A single-role Flutter app for RC Driving Academy — **Instructor only**.
This is a **static/UI-only prototype**: all data comes from
`lib/data/mock_data.dart`, there is no backend, and "Save" actions just
show a confirmation snackbar (or append to an in-memory list) for demo
purposes. No API calls, no persistence, nothing that needs Laravel.

## Screens
- **Dashboard** — welcome header, 3 stat cards (assigned students,
  sessions today, upcoming sessions), assigned-students list, upcoming
  sessions list.
- **My Students** — searchable student list, static "Add Student" button.
- **My Schedule** — session cards with date, time, venue, status pill.
- **Assess Students** — session/student dropdowns, 6 skill categories
  with tappable star ratings + Perfect/Average/Low quick-note chips,
  qualitative feedback box, Save Assessment (appends to Recent
  Assessments list on screen, in-memory only).
- **Attendance** — pick a session, mark each student Present/Late/Absent
  via chips, Save Attendance (static confirmation).

Navigation is a bottom nav bar (5 tabs, pill-style active state) plus a
side drawer, both styled after the reference dark-mode app you sent —
not copied, just similarly clean.

## How to run

1. Install the Flutter SDK if you haven't: https://docs.flutter.dev/get-started/install
2. Copy this whole `rcda_instructor_app` folder next to (or replacing)
   your `try_lang` project folder.
3. In VS Code terminal:
   ```
   cd rcda_instructor_app
   flutter pub get
   flutter run
   ```
   (Chrome works fine since you're already running via Chrome for `try_lang`.)

## File structure
```
lib/
  main.dart                 # app entry + tab switcher (RootShell)
  theme/app_theme.dart       # RCDA red/orange dark theme
  models/models.dart         # StudentModel, ScheduleItem, SkillRating, AssessmentRecord
  data/mock_data.dart        # all static/mock data — edit values here
  widgets/app_scaffold.dart  # shared app bar + drawer + bottom nav
  widgets/common_widgets.dart# StatCard, StatusPill, SectionHeader
  screens/
    dashboard_screen.dart
    students_screen.dart
    schedule_screen.dart
    assess_screen.dart
    attendance_screen.dart
```

## Customizing
- **Colors/branding**: `lib/theme/app_theme.dart` — `AppColors.primaryRed`
  is set to match your web dashboard header; swap it if your final logo
  uses a different red.
- **Content**: everything display-side lives in `lib/data/mock_data.dart`
  — instructor name, student list, schedule, default skill ratings.
- **Logo**: there's a commented-out `assets:` block in `pubspec.yaml` —
  drop your RCDA logo into `assets/images/` and uncomment it, then swap
  the `Icons.directions_car_rounded` placeholder in the drawer
  (`lib/widgets/app_scaffold.dart`) for an `Image.asset(...)`.
