import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/common_widgets.dart';

class StudentsScreen extends StatefulWidget {
  final TabSelected onTabSelected;

  const StudentsScreen({super.key, required this.onTabSelected});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

/// Small label shown above a form field, kept consistent for every field
/// (name, course, age, gender, etc.) instead of relying on Flutter's
/// floating InputDecoration label — which only "floats" once a field has
/// a value, making pre-filled fields like Gender look inconsistent with
/// empty ones.
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _query = '';

  void _openAddStudentSheet() {
    final nameCtrl = TextEditingController();
    final courseCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    String gender = 'Male';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const Text('Add Student',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 17)),
                    const SizedBox(height: 16),
                    _FieldLabel('Full name'),
                    TextFormField(
                      controller: nameCtrl,
                      decoration:
                          const InputDecoration(hintText: 'e.g. Jane Doe'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    _FieldLabel('Course / Program'),
                    TextFormField(
                      controller: courseCtrl,
                      decoration: const InputDecoration(
                          hintText: 'e.g. TDC Face to Face'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel('Age'),
                              TextFormField(
                                controller: ageCtrl,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(hintText: '—'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel('Gender'),
                              DropdownButtonFormField<String>(
                                initialValue: gender,
                                decoration: const InputDecoration(),
                                items: const ['Male', 'Female', 'Other']
                                    .map((g) => DropdownMenuItem(
                                        value: g, child: Text(g)))
                                    .toList(),
                                onChanged: (v) =>
                                    setSheetState(() => gender = v ?? gender),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FieldLabel('Email'),
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(hintText: 'name@example.com'),
                    ),
                    const SizedBox(height: 12),
                    _FieldLabel('Phone'),
                    TextFormField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration:
                          const InputDecoration(hintText: '+1 202-555-0100'),
                    ),
                    const SizedBox(height: 12),
                    _FieldLabel('Address'),
                    TextFormField(
                      controller: addressCtrl,
                      decoration:
                          const InputDecoration(hintText: 'Street, city'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          final newStudent = StudentModel(
                            name: nameCtrl.text.trim(),
                            course: courseCtrl.text.trim(),
                            classification: '—',
                            lastSession: '—',
                            age: int.tryParse(ageCtrl.text.trim()),
                            email: emailCtrl.text.trim().isEmpty
                                ? null
                                : emailCtrl.text.trim(),
                            phone: phoneCtrl.text.trim().isEmpty
                                ? null
                                : phoneCtrl.text.trim(),
                            address: addressCtrl.text.trim().isEmpty
                                ? null
                                : addressCtrl.text.trim(),
                            gender: gender,
                          );
                          setState(
                              () => MockData.students.insert(0, newStudent));
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${newStudent.name} added (static demo)')),
                          );
                        },
                        child: const Text('Add Student'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = MockData.students
        .where((s) => s.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return AppScaffold(
      title: '',
      currentIndex: 0,
      leading: const ModernBackButton(),
      onTabSelected: (i, {String? studentName}) {
        Navigator.of(context).pop();
        widget.onTabSelected(i, studentName: studentName);
      },
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Search students...',
                      prefixIcon: Icon(Icons.search_rounded,
                          color: AppColors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _openAddStudentSheet,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text('No students found',
                          style: TextStyle(color: AppColors.textSecondary)),
                    )
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final s = filtered[i];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                ProfileAvatar(
                                    name: s.name,
                                    imageAsset: s.avatarAsset,
                                    radius: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(s.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15)),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${s.course} · Last: ${s.lastSession}',
                                        style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12),
                                      ),
                                      if (s.classification != '—') ...[
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.accentOrange
                                                .withValues(alpha: 0.16),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            s.classification,
                                            style: const TextStyle(
                                                color: AppColors.accentOrange,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                StudentInfoButton(student: s),
                              ],
                            ),
                          ),
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
