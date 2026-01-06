/// BREEZ Settings Tiles - Settings UI components based on BreezButton
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import 'breez_button.dart';

// Note: BreezSettingsButton moved to breez_dialog_button.dart

/// Settings tile with icon, title, optional trailing widget and chevron
///
/// Use for navigation items in settings screens
class BreezSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  /// Semantic label for screen readers
  final String? semanticLabel;

  /// Tooltip shown on hover
  final String? tooltip;

  const BreezSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    required this.onTap,
    this.semanticLabel,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: onTap,
      backgroundColor: colors.cardLight,
      hoverColor: colors.buttonHover,
      showBorder: false,
      enableScale: false,
      borderRadius: AppRadius.button,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      semanticLabel: semanticLabel ?? title,
      tooltip: tooltip,
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.text,
              ),
            ),
          ),
          if (trailing != null) trailing!,
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 20, color: colors.textMuted),
        ],
      ),
    );
  }
}

/// Switch tile for boolean settings
///
/// Use for toggle settings like "Push Notifications", "Dark Mode"
class BreezSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  /// Semantic label for screen readers
  final String? semanticLabel;

  const BreezSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: () => onChanged(!value),
      backgroundColor: colors.cardLight,
      hoverColor: colors.buttonHover,
      showBorder: false,
      enableScale: false,
      borderRadius: AppRadius.button,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      semanticLabel: semanticLabel ?? '$title, ${value ? 'enabled' : 'disabled'}',
      isButton: false, // This is a toggle, not a button
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.text,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          Semantics(
            toggled: value,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.accent.withValues(alpha: 0.5),
              activeThumbColor: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
