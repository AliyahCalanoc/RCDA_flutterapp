import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/common_widgets.dart';
import 'students_screen.dart';

class DashboardScreen extends StatelessWidget {
  final TabSelected onTabSelected;

  const DashboardScreen({super.key, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Let's see what's on today",
      subtitle: 'Welcome back, ${MockData.instructorName.split(' ').first}!',
      currentIndex: 0,
      onTabSelected: onTabSelected,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.people_alt_rounded,
                  iconColor: AppColors.accentOrange,
                  value: '${MockData.students.length}',
                  label: 'Assigned to me',
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: StatCard(
                  icon: Icons.today_rounded,
                  iconColor: AppColors.success,
                  value: '${MockData.sessionsToday}',
                  label: 'Sessions today',
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: StatCard(
                  icon: Icons.trending_up_rounded,
                  iconColor: AppColors.primaryRed,
                  value: '${MockData.upcomingSessions}',
                  label: 'Scheduled ahead',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SectionHeader(
            title: 'My Assigned Students',
            trailing: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StudentsScreen(onTabSelected: onTabSelected),
                ),
              ),
              child: const Text('View All'),
            ),
          ),
          Card(
            child: Column(
              children: List.generate(MockData.students.take(4).length, (i) {
                final s = MockData.students[i];
                final isLast = i == MockData.students.take(4).length - 1;
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      leading: ProfileAvatar(
                          name: s.name, imageAsset: s.avatarAsset, radius: 20),
                      title: Text(s.name,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${s.course} · Last: ${s.lastSession}'),
                    ),
                    if (!isLast)
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Upcoming Sessions'),
          Card(
            child: Column(
              children: List.generate(MockData.schedule.length, (i) {
                final s = MockData.schedule[i];
                final isLast = i == MockData.schedule.length - 1;
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor:
                            AppColors.primaryRed.withValues(alpha: 0.14),
                        child: const Icon(Icons.event_rounded,
                            color: AppColors.primaryRed, size: 20),
                      ),
                      title: Text(s.course,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${s.date} · ${s.time}'),
                      trailing:
                          StatusPill(text: s.status, color: AppColors.success),
                    ),
                    if (!isLast)
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
