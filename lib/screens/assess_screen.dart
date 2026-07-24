import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/common_widgets.dart';

class AssessScreen extends StatefulWidget {
  final TabSelected onTabSelected;
  final String? initialStudent;

  const AssessScreen({
    super.key,
    required this.onTabSelected,
    this.initialStudent,
  });

  @override
  State<AssessScreen> createState() => _AssessScreenState();
}

class _AssessScreenState extends State<AssessScreen> {
  late ScheduleItem _session;
  late List<StudentModel> _studentsForSession;
  StudentModel? _student;
  late final List<SkillRating> _skills = MockData.defaultSkills();
  final _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSelection();
  }

  void _initSelection() {
    StudentModel? preselected;
    if (widget.initialStudent != null) {
      final matches =
          MockData.students.where((s) => s.name == widget.initialStudent);
      if (matches.isNotEmpty) preselected = matches.first;
    }

    if (preselected != null) {
      final sessionMatches =
          MockData.schedule.where((s) => s.course == preselected!.course);
      _session = sessionMatches.isNotEmpty
          ? sessionMatches.first
          : MockData.schedule.first;
    } else {
      _session = MockData.schedule.first;
    }

    _studentsForSession = _studentsFor(_session);
    _student = preselected ??
        (_studentsForSession.isNotEmpty ? _studentsForSession.first : null);
  }

  List<StudentModel> _studentsFor(ScheduleItem session) =>
      MockData.students.where((s) => s.course == session.course).toList();

  void _onSessionChanged(ScheduleItem session) {
    final matches = _studentsFor(session);
    setState(() {
      _session = session;
      _studentsForSession = matches;
      _student = matches.isNotEmpty ? matches.first : null;
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _saveAssessment() {
    if (_student == null) return;
    final avg =
        _skills.map((s) => s.stars).reduce((a, b) => a + b) / _skills.length;
    setState(() {
      MockData.recentAssessments.insert(
        0,
        AssessmentRecord(
          student: _student!.name,
          date: 'Jul 23, 2026',
          score: '${((avg / 5) * 100).round()}%',
          level: avg >= 4.3
              ? 'fast'
              : (avg >= 3 ? 'average' : 'needs improvement'),
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assessment saved (static demo)')),
    );
  }

  Future<void> _pickSession() async {
    final picked = await showModalBottomSheet<ScheduleItem>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PickerSheet<ScheduleItem>(
        title: 'Select Session',
        items: MockData.schedule,
        selected: _session,
        labelBuilder: (s) => '${s.course} · ${s.date}',
      ),
    );
    if (picked != null) _onSessionChanged(picked);
  }

  Future<void> _pickStudent() async {
    if (_studentsForSession.isEmpty) return;
    final picked = await showModalBottomSheet<StudentModel>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PickerSheet<StudentModel>(
        title: 'Select Student',
        items: _studentsForSession,
        selected: _student,
        labelBuilder: (s) => s.name,
      ),
    );
    if (picked != null) setState(() => _student = picked);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Assess Students',
      currentIndex: 2,
      onTabSelected: widget.onTabSelected,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Rate each driving skill, then pick a quick note per category.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PickerField(
                  label: 'Session',
                  value: '${_session.course} · ${_session.date}',
                  onTap: _pickSession,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerField(
                  label: 'Student',
                  value: _student?.name ?? 'No students',
                  onTap: _pickStudent,
                  enabled: _studentsForSession.isNotEmpty,
                ),
              ),
            ],
          ),
          if (_studentsForSession.isEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'No students enrolled in this session.',
              style: TextStyle(color: AppColors.danger, fontSize: 12.5),
            ),
          ],
          const SizedBox(height: 20),
          const SectionHeader(title: 'Skills Rating'),
          ..._skills.map((skill) => _SkillRow(
                skill: skill,
                onStarsChanged: (v) => setState(() => skill.stars = v),
              )),
          const SizedBox(height: 16),
          const Text('Qualitative Feedback',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: const InputDecoration(
                hintText: "Describe the student's performance in detail..."),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _student == null ? null : _saveAssessment,
              child: const Text('Save Assessment'),
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Recent Assessments'),
          if (MockData.recentAssessments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('Assessments you save will appear here.',
                  style: TextStyle(color: AppColors.textSecondary)),
            )
          else
            Card(
              child: Column(
                children: List.generate(MockData.recentAssessments.length, (i) {
                  final a = MockData.recentAssessments[i];
                  final isLast = i == MockData.recentAssessments.length - 1;
                  return Column(
                    children: [
                      ListTile(
                        title: Text(a.student,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text('${a.date} · Score: ${a.score}'),
                        trailing: StatusPill(
                          text: a.level,
                          color: a.level == 'fast'
                              ? AppColors.success
                              : (a.level == 'average'
                                  ? AppColors.warning
                                  : AppColors.danger),
                        ),
                      ),
                      if (!isLast)
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    ],
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

/// A tappable field styled like the old dropdown, but opens a bottom
/// sheet instead of a DropdownButton overlay — avoids the overlay
/// mispositioning that DropdownButton has when embedded in scroll views.
class _PickerField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool enabled;

  const _PickerField({
    required this.label,
    required this.value,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 6),
        Material(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: enabled ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: enabled
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.expand_more_rounded,
                      color: AppColors.textSecondary, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Generic bottom-sheet list picker shared by both fields above.
class _PickerSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T? selected;
  final String Function(T) labelBuilder;

  const _PickerSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 20, endIndent: 20),
                itemBuilder: (context, i) {
                  final item = items[i];
                  final isSelected = item == selected;
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    title: Text(
                      labelBuilder(item),
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryRed
                            : AppColors.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_rounded,
                            color: AppColors.primaryRed)
                        : null,
                    onTap: () => Navigator.of(context).pop(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  final SkillRating skill;
  final void Function(double) onStarsChanged;

  const _SkillRow({required this.skill, required this.onStarsChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(skill.name, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              final filled = i < skill.stars.round();
              return GestureDetector(
                onTap: () => onStarsChanged((i + 1).toDouble()),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_border_rounded,
                  color: AppColors.accentOrange,
                  size: 26,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
