import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/common_widgets.dart';

class AssessScreen extends StatefulWidget {
  final void Function(int) onTabSelected;

  const AssessScreen({super.key, required this.onTabSelected});

  @override
  State<AssessScreen> createState() => _AssessScreenState();
}

class _AssessScreenState extends State<AssessScreen> {
  late String _session = MockData.sessionOptions.first;
  late String _student = MockData.studentNames.first;
  late final List<SkillRating> _skills = MockData.defaultSkills();
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _saveAssessment() {
    final avg =
        _skills.map((s) => s.stars).reduce((a, b) => a + b) / _skills.length;
    setState(() {
      MockData.recentAssessments.insert(
        0,
        AssessmentRecord(
          student: _student,
          date: 'Jul 23, 2026',
          score: '${avg.toStringAsFixed(1)} / 5.0',
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Assess Students',
      currentIndex: 3,
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
            children: [
              Expanded(
                child: _Dropdown(
                  label: 'Session',
                  value: _session,
                  items: MockData.sessionOptions,
                  onChanged: (v) => setState(() => _session = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Dropdown(
                  label: 'Student',
                  value: _student,
                  items: MockData.studentNames,
                  onChanged: (v) => setState(() => _student = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Skills Rating'),
          ..._skills.map((skill) => _SkillRow(
                skill: skill,
                onStarsChanged: (v) => setState(() => skill.stars = v),
                onNoteChanged: (v) => setState(() => skill.note = v),
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
              onPressed: _saveAssessment,
              child: const Text('Save Assessment  →'),
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

class _SkillRow extends StatelessWidget {
  final SkillRating skill;
  final void Function(double) onStarsChanged;
  final void Function(String) onNoteChanged;

  const _SkillRow(
      {required this.skill,
      required this.onStarsChanged,
      required this.onNoteChanged});

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
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: ['Perfect', 'Average', 'Low'].map((note) {
              final selected = skill.note == note;
              return ChoiceChip(
                label: Text(note),
                selected: selected,
                onSelected: (_) => onNoteChanged(note),
                selectedColor: AppColors.primaryRed.withValues(alpha: 0.24),
                backgroundColor: AppColors.surfaceElevated,
                labelStyle: TextStyle(
                    color: selected
                        ? AppColors.primaryRed
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600),
                side: BorderSide(
                    color: selected ? AppColors.primaryRed : AppColors.border),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const _Dropdown(
      {required this.label,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.surfaceElevated,
              items: items
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, overflow: TextOverflow.ellipsis)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
