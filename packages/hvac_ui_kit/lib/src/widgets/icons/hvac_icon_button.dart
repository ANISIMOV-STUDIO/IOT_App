/// Icon Button Component
/// Provides Material 3 icon buttons with HVAC theming
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// HVAC-themed icon button variants
enum HvacIconButtonVariant {
  standard,
  filled,
  filledTonal,
  outlined,
}

/// Material 3 icon button with HVAC theming
class HvacIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final HvacIconButtonVariant variant;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final String? tooltip;
  final bool enabled;

  const HvacIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = HvacIconButtonVariant.standard,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
    this.tooltip,
    this.enabled = true,
  });

  /// Standard icon button
  const HvacIconButton.standard({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 24.0,
    this.color,
    this.tooltip,
    this.enabled = true,
  })  : variant = HvacIconButtonVariant.standard,
        backgroundColor = null;

  /// Filled icon button
  const HvacIconButton.filled({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
    this.tooltip,
    this.enabled = true,
  }) : variant = HvacIconButtonVariant.filled;

  /// Filled tonal icon button
  const HvacIconButton.filledTonal({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
    this.tooltip,
    this.enabled = true,
  }) : variant = HvacIconButtonVariant.filledTonal;

  /// Outlined icon button
  const HvacIconButton.outlined({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 24.0,
    this.color,
    this.tooltip,
    this.enabled = true,
  })  : variant = HvacIconButtonVariant.outlined,
        backgroundColor = null;

  @override
  Widget build(BuildContext context) {
    final iconColor = enabled
        ? (color ?? HvacColors.textSecondary)
        : HvacColors.textSecondary.withValues(alpha: 0.3);

    Widget button;

    switch (variant) {
      case HvacIconButtonVariant.standard:
        button = IconButton(
          icon: Icon(icon),
          iconSize: size,
          color: iconColor,
          onPressed: enabled ? onPressed : null,
        );
        break;

      case HvacIconButtonVariant.filled:
        button = IconButton.filled(
          icon: Icon(icon),
          iconSize: size,
          color: color ?? HvacColors.textPrimary,
          style: IconButton.styleFrom(
            backgroundColor:
                backgroundColor ?? HvacColors.primaryOrange,
            disabledBackgroundColor:
                HvacColors.backgroundCardBorder.withValues(alpha: 0.2),
          ),
          onPressed: enabled ? onPressed : null,
        );
        break;

      case HvacIconButtonVariant.filledTonal:
        button = IconButton.filledTonal(
          icon: Icon(icon),
          iconSize: size,
          color: color ?? HvacColors.primaryOrange,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ??
                HvacColors.primaryOrange.withValues(alpha: 0.2),
            disabledBackgroundColor:
                HvacColors.backgroundCardBorder.withValues(alpha: 0.1),
          ),
          onPressed: enabled ? onPressed : null,
        );
        break;

      case HvacIconButtonVariant.outlined:
        button = IconButton.outlined(
          icon: Icon(icon),
          iconSize: size,
          color: iconColor,
          style: IconButton.styleFrom(
            side: BorderSide(
              color: enabled
                  ? HvacColors.backgroundCardBorder
                  : HvacColors.backgroundCardBorder.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          onPressed: enabled ? onPressed : null,
        );
        break;
    }

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
