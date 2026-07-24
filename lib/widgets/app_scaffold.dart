import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';
import 'package:flutter/rendering.dart';

/// Shared shell for the app: a flat modern header (no solid navbar block)
/// and a floating rounded bottom nav with the 5 top-level instructor
/// sections. Pushed (non-tab) screens can set [showNavBar] to false and
/// pass a [leading] back button instead.
class AppScaffold extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final int currentIndex;
  final TabSelected onTabSelected;
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
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  bool _headerVisible = true;

  double get _headerHeight => widget.subtitle != null ? 84 : 66;

  bool _handleScroll(ScrollNotification notification) {
    final offset = notification.metrics.pixels;

    // Always show the header once scrolled back to (or near) the top,
    // regardless of direction — avoids it staying hidden after a bounce.
    if (offset <= 4) {
      if (!_headerVisible) setState(() => _headerVisible = true);
      return false;
    }

    // React to genuine direction changes (UserScrollNotification) rather
    // than every tiny pixel delta — raw deltas flicker during momentum
    // scrolling because direction briefly reverses between frames.
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse && _headerVisible) {
        setState(() => _headerVisible = false); // scrolling down
      } else if (notification.direction == ScrollDirection.forward &&
          !_headerVisible) {
        setState(() => _headerVisible = true); // scrolling up
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              height: _headerVisible ? _headerHeight : 0,
              child: ClipRect(
                child: OverflowBox(
                  minHeight: 0,
                  maxHeight: _headerHeight,
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    opacity: widget.headerOpacity * (_headerVisible ? 1 : 0),
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeOut,
                    child: ModernHeader(
                      title: widget.title,
                      subtitle: widget.subtitle,
                      leading: widget.leading,
                      trailing: widget.actions != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: widget.actions!)
                          : ProfileAvatar(
                              name: MockData.instructorName,
                              imageAsset: MockData.instructorAvatarAsset,
                              radius: 19,
                              ring: true,
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScroll,
                child: widget.body,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showNavBar
          ? _FloatingNavBar(
              currentIndex: widget.currentIndex,
              onTabSelected: widget.onTabSelected,
            )
          : null,
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final TabSelected onTabSelected;

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
            onDestinationSelected: (i) => onTabSelected(i),
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
