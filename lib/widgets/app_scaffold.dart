import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

/// Shared shell for the app: a flat modern header (no solid navbar block)
/// and a floating rounded bottom nav with the 5 top-level instructor
/// sections. Pushed (non-tab) screens can set [showNavBar] to false and
/// pass a [leading] back button instead.
class AppScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final int currentIndex;
  final void Function(int) onTabSelected;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showNavBar;

  /// 0.0–1.0 opacity applied to the header. Screens that want the header
  /// to fade as the user scrolls (e.g. Dashboard) pass a value derived
  /// from their ScrollController; everything else defaults to fully
  /// opaque and is unaffected.
  final double headerOpacity;

  const AppScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    required this.currentIndex,
    required this.onTabSelected,
    this.actions,
    this.leading,
    this.showNavBar = true,
    this.headerOpacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: headerOpacity,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: ModernHeader(
                title: title,
                subtitle: subtitle,
                leading: leading,
                trailing: actions != null
                    ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
                    : ProfileAvatar(
                        name: MockData.instructorName,
                        imageAsset: MockData.instructorAvatarAsset,
                        radius: 19,
                        ring: true,
                      ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: showNavBar
          ? _FloatingNavBar(
              currentIndex: currentIndex,
              onTabSelected: onTabSelected,
            )
          : null,
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTabSelected;

  const _FloatingNavBar(
      {required this.currentIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            height: 64,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: currentIndex,
            onDestinationSelected: onTabSelected,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
              NavigationDestination(
                  icon: Icon(Icons.calendar_month_rounded), label: 'Schedule'),
              NavigationDestination(
                  icon: Icon(Icons.star_rounded), label: 'Assess'),
              NavigationDestination(
                  icon: Icon(Icons.checklist_rounded), label: 'Attendance'),
              NavigationDestination(
                  icon: Icon(Icons.person_rounded), label: 'Account'),
            ],
          ),
        ),
      ),
    );
  }
}
