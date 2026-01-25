/// BREEZ Icon Buttons - Icon-based button variants with accessibility
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezIconButton
abstract class _IconButtonConstants {
  static const double paddingNormal = 12;
  static const double paddingCompact = 4;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Icon button with consistent styling and optional badge
class BreezIconButton extends StatelessWidget {

  const BreezIconButton({
    required this.icon, super.key,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.isActive = false,
    this.size = AppIconSizes.standard,
    this.badge,
    this.showBorder = true,
    this.compact = false,
    this.semanticLabel,
    this.tooltip,
  });
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool isActive;
  final double size;
  final String? badge;
  final bool showBorder;

  /// Compact mode - smaller padding, no min touch target
  final bool compact;

  /// Semantic label for screen readers (required for accessibility)
  final String? semanticLabel;

  /// Tooltip text shown on hover/long-press
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final padding = compact
        ? _IconButtonConstants.paddingCompact
        : _IconButtonConstants.paddingNormal;
    final minSize = compact ? 0.0 : AppSizes.minTouchTarget;
    final buttonSize = (size + padding * 2) < minSize
        ? minSize
        : (size + padding * 2);
    final iconPadding = (buttonSize - size) / 2;

    final bg = backgroundColor ?? (isActive ? colors.accent : colors.card);
    final effectiveIconColor =
        iconColor ?? (isActive ? AppColors.white : colors.textMuted);

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        BreezButton(
          onTap: onTap,
          width: buttonSize,
          height: buttonSize,
          padding: EdgeInsets.all(iconPadding),
          backgroundColor: bg,
          hoverColor: isActive ? colors.accentLight : colors.cardLight,
          showBorder: showBorder,
          enableGlow: isActive,
          semanticLabel: semanticLabel,
          tooltip: tooltip,
          child: Icon(
            icon,
            size: size,
            color: effectiveIconColor,
          ),
        ),
        // Badge
        if (badge != null)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: AppColors.critical,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: AppFontSizes.captionSmall,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Circular action button (for +/- temperature controls)
class BreezCircleButton extends StatelessWidget {

  const BreezCircleButton({
    required this.icon, super.key,
    this.onTap,
    this.size = 56,
    this.semanticLabel,
    this.tooltip,
  });
  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  /// Semantic label for screen readers
  final String? semanticLabel;

  /// Tooltip text shown on hover
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final buttonSize = size < AppSizes.minTouchTarget ? AppSizes.minTouchTarget : size;

    return BreezButton(
      onTap: onTap,
      width: buttonSize,
      height: buttonSize,
      padding: EdgeInsets.zero,
      borderRadius: buttonSize / 2,
      backgroundColor: colors.accent,
      hoverColor: colors.accentLight,
      border: Border.all(color: Colors.transparent),
      shadows: [
        BoxShadow(
          color: colors.accent.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      child: Center(
        child: Icon(
          icon,
          color: AppColors.white,
          size: buttonSize * 0.5,
        ),
      ),
    );
  }
}

/// Power toggle button
class BreezPowerButton extends StatelessWidget {

  const BreezPowerButton({
    required this.isPowered, super.key,
    this.onTap,
    this.size = 56,
    this.semanticLabel,
    this.tooltip,
  });
  final bool isPowered;
  final VoidCallback? onTap;
  final double size;

  /// Semantic label for screen readers
  final String? semanticLabel;

  /// Tooltip text shown on hover
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final buttonSize = size < AppSizes.minTouchTarget ? AppSizes.minTouchTarget : size;

    return BreezButton(
      onTap: onTap,
      width: buttonSize,
      height: buttonSize,
      padding: EdgeInsets.zero,
      borderRadius: buttonSize / 2,
      backgroundColor: isPowered
          ? AppColors.accentGreen.withValues(alpha: 0.15)
          : colors.buttonBg,
      hoverColor: isPowered
          ? AppColors.accentGreen.withValues(alpha: 0.25)
          : colors.cardLight,
      border: Border.all(
        color: isPowered
            ? AppColors.accentGreen.withValues(alpha: 0.3)
            : colors.border,
      ),
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      child: Center(
        child: Icon(
          Icons.power_settings_new,
          size: buttonSize * 0.45,
          color: isPowered ? AppColors.accentGreen : colors.textMuted,
        ),
      ),
    );
  }
}
