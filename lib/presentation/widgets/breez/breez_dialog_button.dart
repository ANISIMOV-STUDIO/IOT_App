/// BREEZ Dialog Buttons - Dialog action buttons based on BreezButton
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import 'breez_button.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      semanticLabel: semanticLabel ?? label,
      tooltip: tooltip,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      border: Border.all(color: AppColors.accent),
      semanticLabel: semanticLabel ?? label,
      tooltip: tooltip,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
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
      padding: const EdgeInsets.all(16),
      semanticLabel: semanticLabel ?? label,
      tooltip: tooltip,
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: colors.textMuted,
          ),
        ],
      ),
    );
  }
}
