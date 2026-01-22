/// BREEZ Dialog Buttons - Dialog action buttons based on BreezButton
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _DialogButtonConstants {
  static const double fontSize = 14;
  static const double fontSizeSmall = 12;
  static const double subtitleGap = 2;
}

/// Компактная кнопка действия для диалогов (primary/secondary/danger)
///
/// Стандартная высота: `AppSizes.buttonHeightSmall` (36px)
/// Используется в модалках для действий: Сохранить, Удалить, Отмена и т.д.
///
/// Для размещения в Row с равной шириной оберните в Expanded:
/// ```dart
/// Row(children: [
///   Expanded(child: BreezDialogButton(label: 'Cancel', onTap: ...)),
///   SizedBox(width: AppSpacing.xs),
///   Expanded(child: BreezDialogButton(label: 'Save', isPrimary: true, onTap: ...)),
/// ])
/// ```
class BreezDialogButton extends StatelessWidget {

  const BreezDialogButton({
    required this.label,
    super.key,
    this.icon,
    this.onTap,
    this.isPrimary = false,
    this.isLoading = false,
    this.isDanger = false,
    this.semanticLabel,
    this.tooltip,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool isLoading;
  final bool isDanger;

  /// Semantic label for screen readers (defaults to label)
  final String? semanticLabel;

  /// Tooltip shown on hover
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    final Color bgColor;
    final Color contentColor;
    final Color hoverColor;

    if (isDanger) {
      // Danger: прозрачный красный фон, красный текст
      bgColor = AppColors.accentRed.withValues(alpha: AppColors.opacityVerySubtle);
      contentColor = AppColors.accentRed;
      hoverColor = AppColors.accentRed.withValues(alpha: AppColors.opacitySubtle);
    } else if (isPrimary) {
      // Primary: залитый accent фон, черный текст
      bgColor = AppColors.accent;
      contentColor = AppColors.black;
      hoverColor = AppColors.accentLight;
    } else {
      // Secondary: cardLight фон, muted текст
      bgColor = colors.cardLight;
      contentColor = colors.textMuted;
      hoverColor = colors.buttonHover;
    }

    return BreezButton(
      onTap: onTap,
      isLoading: isLoading,
      height: AppSizes.buttonHeightSmall,
      backgroundColor: bgColor,
      hoverColor: hoverColor,
      borderRadius: AppRadius.nested,
      showBorder: false,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      semanticLabel: semanticLabel ?? label,
      tooltip: tooltip,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppIconSizes.standard, color: contentColor),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: (isPrimary || isDanger) ? FontWeight.w600 : FontWeight.w500,
                color: contentColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Action button with icon and accent border
///
/// Use for secondary actions like "Edit Profile", "Change Password"
class BreezActionButton extends StatelessWidget {

  const BreezActionButton({
    required this.icon, required this.label, required this.onTap, super.key,
    this.semanticLabel,
    this.tooltip,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Semantic label for screen readers (defaults to label)
  final String? semanticLabel;

  /// Tooltip shown on hover
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezButton(
      onTap: onTap,
      height: AppSizes.buttonHeightSmall,
      backgroundColor: colors.cardLight,
      hoverColor: AppColors.accent.withValues(alpha: AppColors.opacityLight),
      borderRadius: AppRadius.nested,
      border: Border.all(color: AppColors.accent),
      semanticLabel: semanticLabel ?? label,
      tooltip: tooltip,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppIconSizes.standard, color: AppColors.accent),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
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

  const BreezSettingsButton({
    required this.icon, required this.label, required this.onTap, super.key,
    this.subtitle,
    this.isDanger = false,
    this.semanticLabel,
    this.tooltip,
  });
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDanger;

  /// Semantic label for screen readers
  final String? semanticLabel;

  /// Tooltip shown on hover
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final iconColor = isDanger ? AppColors.accentRed : colors.textMuted;
    final labelColor = isDanger ? AppColors.accentRed : colors.text;

    return BreezButton(
      onTap: onTap,
      backgroundColor: colors.buttonBg,
      hoverColor: isDanger
          ? AppColors.accentRed.withValues(alpha: AppColors.opacityLight)
          : colors.buttonHover,
      showBorder: false,
      enableScale: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      semanticLabel: semanticLabel ?? label,
      tooltip: tooltip,
      child: Row(
        children: [
          Icon(icon, size: AppIconSizes.standard, color: iconColor),
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
            size: AppIconSizes.standard,
            color: colors.textMuted,
          ),
        ],
      ),
    );
  }
}
