import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/common_widgets.dart';

class AttendanceScreen extends StatefulWidget {
  final TabSelected onTabSelected;

  const AttendanceScreen({super.key, required this.onTabSelected});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  ScheduleItem? _selectedSession;
  final Map<String, String> _attendance =
      {}; // studentName -> Present/Late/Absent

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Attendance',
      currentIndex: 3,
      onTabSelected: widget.onTabSelected,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select one of your sessions to mark your students present, late, or absent.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Your Sessions'),
            ...MockData.schedule.map((s) {
              final selected = s == _selectedSession;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _selectedSession = selected ? null : s),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primaryRed.withValues(alpha: 0.14)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: selected
                              ? AppColors.primaryRed
                              : AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.course,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text(s.date,
                                  style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        StatusPill(text: s.status, color: AppColors.success),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Students'),
            if (_selectedSession == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'Select a session to mark attendance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else ...[
              ...MockData.students.map((s) {
                final current = _attendance[s.name] ?? 'Present';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(s.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700))),
                          Wrap(
                            spacing: 6,
                            children:
                                ['Present', 'Late', 'Absent'].map((status) {
                              final sel = current == status;
                              final color = status == 'Present'
                                  ? AppColors.success
                                  : (status == 'Late'
                                      ? AppColors.warning
                                      : AppColors.danger);
                              return ChoiceChip(
                                label: Text(status),
                                selected: sel,
                                onSelected: (_) => setState(
                                    () => _attendance[s.name] = status),
                                selectedColor: color.withValues(alpha: 0.22),
                                backgroundColor: AppColors.surfaceElevated,
                                labelStyle: TextStyle(
                                    color:
                                        sel ? color : AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                                side: BorderSide(
                                    color: sel ? color : AppColors.border),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Attendance saved (static demo)')),
                    );
                  },
                  child: const Text('Save Attendance'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
