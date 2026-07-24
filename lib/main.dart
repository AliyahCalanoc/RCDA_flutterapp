import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/assess_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/account_screen.dart';

void main() {
  runApp(const RCDAInstructorApp());
}

class RCDAInstructorApp extends StatelessWidget {
  const RCDAInstructorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDark,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'RCDA Instructor',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.current,
          home: const _AppFlow(),
        );
      },
    );
  }
}

class _AppFlow extends StatefulWidget {
  const _AppFlow();

  @override
  State<_AppFlow> createState() => _AppFlowState();
}

class _AppFlowState extends State<_AppFlow> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: _showSplash
          ? SplashScreen(
              key: const ValueKey('splash'),
              onFinished: () => setState(() => _showSplash = false),
            )
          : const RootShell(key: ValueKey('root')),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  // Which student the Assess tab should default to. Set whenever a
  // student's "Assess" button is tapped directly (dashboard or My
  // Students); left as-is for plain bottom-nav taps so the Assess tab
  // just keeps showing whoever was selected last.
  String? _assessStudent;

  void _onTabSelected(int i, {String? studentName}) {
    setState(() {
      _index = i;
      if (studentName != null) _assessStudent = studentName;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listening here means any screen currently on-screen rebuilds the
    // instant ThemeController.isDark changes — no need to switch tabs
    // for the new colors to take effect.
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDark,
      builder: (context, isDark, _) {
        switch (_index) {
          case 1:
            return ScheduleScreen(onTabSelected: _onTabSelected);
          case 2:
            return AssessScreen(
              key: ValueKey('assess-$_assessStudent'),
              onTabSelected: _onTabSelected,
              initialStudent: _assessStudent,
            );
          case 3:
            return AttendanceScreen(onTabSelected: _onTabSelected);
          case 4:
            return AccountScreen(onTabSelected: _onTabSelected);
          case 0:
          default:
            return DashboardScreen(onTabSelected: _onTabSelected);
        }
      },
    );
  }
}
