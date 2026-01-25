/// BREEZ Settings Tiles - Settings UI components based on BreezButton
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezSettingsTile
abstract class _SettingsTileConstants {
  static const double tileVerticalPadding = 10;
  static const double switchTileVerticalPadding = 6;
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

  const BreezSettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
    this.trailing,
    this.semanticLabel,
    this.tooltip,
  });
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  /// Semantic label for screen readers
  final String? semanticLabel;

  /// Tooltip shown on hover
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: onTap,
      backgroundColor: colors.cardLight,
      hoverColor: colors.buttonHover,
      showBorder: false,
      enableScale: false,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: _SettingsTileConstants.tileVerticalPadding,
      ),
      semanticLabel: semanticLabel ?? title,
      tooltip: tooltip,
      child: Row(
        children: [
          Icon(icon, size: AppIconSizes.standard, color: colors.accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: FontWeight.w500,
                color: colors.text,
              ),
            ),
          ),
          if (trailing != null) trailing!,
          const SizedBox(width: AppSpacing.xxs),
          Icon(Icons.chevron_right, size: AppIconSizes.standard, color: colors.textMuted),
        ],
      ),
    );
  }
}

/// Switch tile for boolean settings
///
/// Use for toggle settings like "Push Notifications", "Dark Mode"
class BreezSwitchTile extends StatelessWidget {

  const BreezSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
    this.semanticLabel,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  /// Semantic label for screen readers
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: () => onChanged(!value),
      backgroundColor: colors.cardLight,
      hoverColor: colors.buttonHover,
      showBorder: false,
      enableScale: false,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: _SettingsTileConstants.switchTileVerticalPadding,
      ),
      semanticLabel: semanticLabel ?? '$title, ${value ? 'enabled' : 'disabled'}',
      isButton: false, // This is a toggle, not a button
      child: Row(
        children: [
          Icon(icon, size: AppIconSizes.standard, color: colors.accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: FontWeight.w500,
                    color: colors.text,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      color: colors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          Semantics(
            toggled: value,
            child: Transform.scale(
              scale: 0.85,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: colors.accent.withValues(
                  alpha: _SettingsTileConstants.switchActiveTrackAlpha,
                ),
                activeThumbColor: colors.accent,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// BreezSectionTitle removed - use BreezSectionHeader.settings() instead
