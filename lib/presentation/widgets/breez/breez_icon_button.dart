/// BREEZ Icon Buttons - Icon-based button variants with accessibility
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_sizes.dart';
import 'breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezIconButton
abstract class _IconButtonConstants {
  static const double defaultIconSize = 20.0;
  static const double paddingNormal = 12.0;
  static const double paddingCompact = 4.0;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Icon button with consistent styling and optional badge
class BreezIconButton extends StatelessWidget {
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

  const BreezIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.isActive = false,
    this.size = _IconButtonConstants.defaultIconSize,
    this.badge,
    this.showBorder = true,
    this.compact = false,
    this.semanticLabel,
    this.tooltip,
  });

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

    final bg = backgroundColor ?? (isActive ? AppColors.accent : colors.card);
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
          hoverColor: isActive ? AppColors.accentLight : colors.cardLight,
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
  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  /// Semantic label for screen readers
  final String? semanticLabel;

  /// Tooltip text shown on hover
  final String? tooltip;

  const BreezCircleButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 56,
    this.semanticLabel,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size < AppSizes.minTouchTarget ? AppSizes.minTouchTarget : size;

    return BreezButton(
      onTap: onTap,
      width: buttonSize,
      height: buttonSize,
      padding: EdgeInsets.zero,
      borderRadius: buttonSize / 2,
      backgroundColor: AppColors.accent,
      hoverColor: AppColors.accentLight,
      border: Border.all(color: Colors.transparent),
      shadows: [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.4),
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
  final bool isPowered;
  final VoidCallback? onTap;
  final double size;

  /// Semantic label for screen readers
  final String? semanticLabel;

  /// Tooltip text shown on hover
  final String? tooltip;

  const BreezPowerButton({
    super.key,
    required this.isPowered,
    this.onTap,
    this.size = 56,
    this.semanticLabel,
    this.tooltip,
  });

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
