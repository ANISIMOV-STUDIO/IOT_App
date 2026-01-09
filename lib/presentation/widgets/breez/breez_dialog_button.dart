/// BREEZ Dialog Buttons - Dialog action buttons based on BreezButton
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import 'breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _DialogButtonConstants {
  static const double fontSize = 14.0;
  static const double fontSizeSmall = 12.0;
  static const double iconSize = 18.0;
  static const double iconSizeMedium = 20.0;
  static const double verticalPadding = 12.0;
  static const double horizontalPadding = 20.0;
  static const double subtitleGap = 2.0;
}

/// Dialog action button (primary/secondary/danger)
///
/// Использует базовый BreezButton для единообразия анимаций и accessibility.
class BreezDialogButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool isLoading;
  final bool isDanger;

  /// Semantic label for screen readers (defaults to label)
  final String? semanticLabel;

  /// Tooltip shown on hover
  final String? tooltip;

  const BreezDialogButton({
    super.key,
    required this.label,
    this.onTap,
    this.isPrimary = false,
    this.isLoading = false,
    this.isDanger = false,
    this.semanticLabel,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    final Color bgColor;
    final Color textColor;
    final Color hoverColor;

    if (isDanger) {
      bgColor = AppColors.accentRed;
      textColor = Colors.white;
      hoverColor = AppColors.accentRed.withValues(alpha: 0.8);
    } else if (isPrimary) {
      bgColor = AppColors.accent;
      textColor = Colors.white;
      hoverColor = AppColors.accentLight;
    } else {
      bgColor = Colors.transparent;
      textColor = colors.textMuted;
      hoverColor = colors.text.withValues(alpha: 0.05);
    }

    return BreezButton(
      onTap: onTap,
      isLoading: isLoading,
      backgroundColor: bgColor,
      hoverColor: hoverColor,
      borderRadius: AppRadius.button,
      showBorder: !isPrimary && !isDanger,
      enableScale: true,
      enableGlow: isPrimary || isDanger,
      padding: const EdgeInsets.symmetric(
        horizontal: _DialogButtonConstants.horizontalPadding,
        vertical: _DialogButtonConstants.verticalPadding,
      ),
      semanticLabel: semanticLabel ?? label,
      tooltip: tooltip,
      child: Text(
        label,
        style: TextStyle(
          fontSize: _DialogButtonConstants.fontSize,
          fontWeight: (isPrimary || isDanger) ? FontWeight.w600 : FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

/// Action button with icon and accent border
///
/// Use for secondary actions like "Edit Profile", "Change Password"
class BreezActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Semantic label for screen readers (defaults to label)
  final String? semanticLabel;

  /// Tooltip shown on hover
  final String? tooltip;

  const BreezActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.semanticLabel,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return BreezButton(
      onTap: onTap,
      backgroundColor: Colors.transparent,
      hoverColor: AppColors.accent.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(
        vertical: _DialogButtonConstants.verticalPadding,
      ),
      border: Border.all(color: AppColors.accent),
      semanticLabel: semanticLabel ?? label,
      tooltip: tooltip,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _DialogButtonConstants.iconSize, color: AppColors.accent),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              fontSize: _DialogButtonConstants.fontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings list button with icon, label and optional subtitle
class BreezSettingsButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDanger;

  /// Semantic label for screen readers
  final String? semanticLabel;

  /// Tooltip shown on hover
  final String? tooltip;

  const BreezSettingsButton({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.isDanger = false,
    this.semanticLabel,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final iconColor = isDanger ? AppColors.accentRed : colors.textMuted;
    final labelColor = isDanger ? AppColors.accentRed : colors.text;

    return BreezButton(
      onTap: onTap,
      backgroundColor: colors.buttonBg,
      hoverColor: isDanger
          ? AppColors.accentRed.withValues(alpha: 0.1)
          : colors.buttonHover,
      showBorder: false,
      enableScale: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      semanticLabel: semanticLabel ?? label,
      tooltip: tooltip,
      child: Row(
        children: [
          Icon(icon, size: _DialogButtonConstants.iconSizeMedium, color: iconColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: _DialogButtonConstants.fontSize,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: _DialogButtonConstants.subtitleGap),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: _DialogButtonConstants.fontSizeSmall,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: _DialogButtonConstants.iconSizeMedium,
            color: colors.textMuted,
          ),
        ],
      ),
    );
  }
}
