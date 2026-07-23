import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/students_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/assess_screen.dart';
import 'screens/attendance_screen.dart';

void main() {
  runApp(const RCDAInstructorApp());
}

class RCDAInstructorApp extends StatelessWidget {
  const RCDAInstructorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds the whole app whenever ThemeController.isDark changes,
    // so every screen (which reads AppColors.* directly) re-themes too.
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDark,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'RCDA Instructor',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.current,
          home: _AppFlow(),
        );
      },
    );
  }
}

/// Shows the opening/splash section briefly, then fades automatically
/// into the main tabbed shell — no tap required.
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
          : RootShell(key: const ValueKey('root')),
    );
  }
}

/// Root shell holds the current tab index so switching tabs (via bottom
/// nav OR via "Assess" shortcuts elsewhere in the app) doesn't rebuild
/// the whole navigation stack — this is a static, single-role app so a
/// simple index switch is enough.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  void _onTabSelected(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    switch (_index) {
      case 1:
        return StudentsScreen(onTabSelected: _onTabSelected);
      case 2:
        return ScheduleScreen(onTabSelected: _onTabSelected);
      case 3:
        return AssessScreen(onTabSelected: _onTabSelected);
      case 4:
        return AttendanceScreen(onTabSelected: _onTabSelected);
      case 0:
      default:
        return DashboardScreen(onTabSelected: _onTabSelected);
    }
  }
}
