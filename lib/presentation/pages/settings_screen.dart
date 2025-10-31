/// Settings Screen
///
/// Application settings and configuration
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection(
            context,
            title: 'Account',
            children: [
              _buildSettingTile(
                context,
                icon: Icons.person_outline,
                title: 'Profile',
                subtitle: 'Manage your profile',
                onTap: () {
                  // TODO: Navigate to profile
                },
              ),
              _buildSettingTile(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage notifications',
                onTap: () {
                  // TODO: Navigate to notifications settings
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSection(
            context,
            title: 'Preferences',
            children: [
              _buildSettingTile(
                context,
                icon: Icons.language_outlined,
                title: l10n.language,
                subtitle: 'English',
                onTap: () {
                  // TODO: Show language picker
                },
              ),
              _buildSettingTile(
                context,
                icon: Icons.thermostat_outlined,
                title: 'Temperature Unit',
                subtitle: 'Celsius',
                onTap: () {
                  // TODO: Toggle temperature unit
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSection(
            context,
            title: 'About',
            children: [
              _buildSettingTile(
                context,
                icon: Icons.info_outline,
                title: 'App Version',
                subtitle: '1.0.0',
              ),
              _buildSettingTile(
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  // TODO: Navigate to help
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Logout button
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement logout
            },
            icon: const Icon(Icons.logout),
            label: Text(l10n.logout),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: AppTheme.deviceCard(),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryOrange),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: AppTheme.textTertiary)
          : null,
      onTap: onTap,
    );
  }
}
