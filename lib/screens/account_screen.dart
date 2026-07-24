import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/common_widgets.dart';

class AccountScreen extends StatelessWidget {
  final TabSelected onTabSelected;

  const AccountScreen({super.key, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.isDark.value;

    return AppScaffold(
      title: 'Account',
      currentIndex: 4,
      onTabSelected: onTabSelected,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const ProfileAvatar(
                    name: MockData.instructorName,
                    imageAsset: MockData.instructorAvatarAsset,
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          MockData.instructorName,
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          MockData.instructorRole,
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Preferences'),
          Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: AppColors.primaryRed,
              ),
              title: const Text('Appearance',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(isDark ? 'Dark mode' : 'Light mode'),
              trailing: Switch(
                value: isDark,
                activeThumbColor: AppColors.primaryRed,
                onChanged: (_) => ThemeController.toggle(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Account'),
          Card(
            child: Column(
              children: [
                _accountTile(context, Icons.edit_rounded, 'Edit Profile'),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _accountTile(
                    context, Icons.notifications_rounded, 'Notifications'),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _accountTile(
                    context, Icons.privacy_tip_rounded, 'Privacy Policy'),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _accountTile(context, Icons.help_rounded, 'Help & Support'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Static demo — Log Out goes here')),
                );
              },
              icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
              label: const Text('Log Out',
                  style: TextStyle(color: AppColors.danger)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.danger),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _accountTile(BuildContext context, IconData icon, String label) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Static demo — $label goes here')),
        );
      },
    );
  }
}
