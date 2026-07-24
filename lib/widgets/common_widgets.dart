import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Callback used for bottom-nav / "Assess" taps. [studentName] is optional —
/// plain tab switches (bottom nav) omit it; tapping a specific student's
/// "Assess" button passes their name so the Assess screen can pre-select
/// them instead of always defaulting to the first student in the list.
typedef TabSelected = void Function(int index, {String? studentName});

/// Opens a bottom sheet with a student's profile details (name, age,
/// email, phone, address, gender). Fields that are missing show '—'.
void showStudentInfoSheet(BuildContext context, StudentModel student) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
              Row(
                children: [
                  ProfileAvatar(
                      name: student.name,
                      imageAsset: student.avatarAsset,
                      radius: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 17)),
                        const SizedBox(height: 2),
                        Text(student.course,
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _infoRow(Icons.cake_rounded, 'Age',
                  student.age != null ? '${student.age}' : '—'),
              _infoRow(Icons.email_rounded, 'Email', student.email ?? '—'),
              _infoRow(Icons.phone_rounded, 'Phone', student.phone ?? '—'),
              _infoRow(
                  Icons.location_on_rounded, 'Address', student.address ?? '—'),
              _infoRow(Icons.wc_rounded, 'Gender', student.gender ?? '—'),
            ],
          ),
        ),
      );
    },
  );
}

Widget _infoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 19, color: AppColors.primaryRed),
        const SizedBox(width: 12),
        SizedBox(
          width: 70,
          child: Text(label,
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: Text(value,
              style:
                  const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}

/// Small round "info" icon button placed before the Assess button.
class StudentInfoButton extends StatelessWidget {
  final StudentModel student;

  const StudentInfoButton({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showStudentInfoSheet(context, student),
      icon: Icon(Icons.info_outline_rounded, color: AppColors.textSecondary),
      tooltip: 'Student info',
      splashRadius: 20,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Circular profile photo. Shows a real local asset image when [imageAsset]
/// is given; falls back to the person's initial on a tinted background if
/// there's no photo (or the file is missing), so the UI never breaks.
class ProfileAvatar extends StatelessWidget {
  final String name;
  final String? imageAsset;
  final double radius;
  final bool ring; // subtle brand-colored ring, used in the header

  const ProfileAvatar({
    super.key,
    required this.name,
    this.imageAsset,
    this.radius = 22,
    this.ring = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryRed.withValues(alpha: 0.14),
      backgroundImage: imageAsset != null ? AssetImage(imageAsset!) : null,
      onBackgroundImageError: imageAsset != null ? (_, __) {} : null,
      child: imageAsset == null
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w800,
                fontSize: radius * 0.62,
              ),
            )
          : null,
    );

    if (!ring) return avatar;

    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryRed, width: 2),
      ),
      child: avatar,
    );
  }
}

/// Flat, borderless page header used in place of a classic solid-color
/// AppBar/navbar. Sits directly on the screen background so it reads as
/// part of the page rather than a separate bar.
class ModernHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  const ModernHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 10)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null) ...[
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}

/// Small circular back button used by pushed (non-tab) screens instead of
/// the default AppBar back arrow, so it matches the flat modern header.
class ModernBackButton extends StatelessWidget {
  const ModernBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            size: 18, color: AppColors.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
        splashRadius: 22,
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: iconColor.withValues(alpha: 0.16),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 10),
                Text(value,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String text;
  final Color color;

  const StatusPill({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800)),
            ],
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
