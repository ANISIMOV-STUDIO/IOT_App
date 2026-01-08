/// BREEZ Settings Tiles - Settings UI components based on BreezButton
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import 'breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezSettingsTile
abstract class _SettingsTileConstants {
  static const double iconSize = 20.0;
  static const double titleFontSize = 14.0;
  static const double subtitleFontSize = 12.0;
  static const double tileVerticalPadding = 14.0;
  static const double switchTileVerticalPadding = 10.0;
  static const double switchActiveTrackAlpha = 0.5;
}

// =============================================================================
// WIDGETS
// =============================================================================

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
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: _SettingsTileConstants.tileVerticalPadding,
      ),
      semanticLabel: semanticLabel ?? title,
      tooltip: tooltip,
      child: Row(
        children: [
          Icon(icon, size: _SettingsTileConstants.iconSize, color: AppColors.accent),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: _SettingsTileConstants.titleFontSize,
                fontWeight: FontWeight.w500,
                color: colors.text,
              ),
            ),
          ),
          if (trailing != null) trailing!,
          SizedBox(width: AppSpacing.xxs),
          Icon(Icons.chevron_right, size: _SettingsTileConstants.iconSize, color: colors.textMuted),
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
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: _SettingsTileConstants.switchTileVerticalPadding,
      ),
      semanticLabel: semanticLabel ?? '$title, ${value ? 'enabled' : 'disabled'}',
      isButton: false, // This is a toggle, not a button
      child: Row(
        children: [
          Icon(icon, size: _SettingsTileConstants.iconSize, color: AppColors.accent),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: _SettingsTileConstants.titleFontSize,
                    fontWeight: FontWeight.w500,
                    color: colors.text,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: _SettingsTileConstants.subtitleFontSize,
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
              activeTrackColor: AppColors.accent.withValues(
                alpha: _SettingsTileConstants.switchActiveTrackAlpha,
              ),
              activeThumbColor: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
