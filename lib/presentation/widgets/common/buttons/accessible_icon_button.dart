/// Accessible Icon Button Component
/// Specialized icon button with accessibility features
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Accessible icon button with minimum touch target
class AccessibleIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String semanticLabel;
  final String? tooltip;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final bool enableHapticFeedback;
  final bool loading;
  final double minTouchTarget;
  final ButtonStyle? style;
  final bool selected;
  final Widget? selectedIcon;

  const AccessibleIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.semanticLabel,
    this.tooltip,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
    this.enableHapticFeedback = true,
    this.loading = false,
    this.minTouchTarget = 48.0,
    this.style,
    this.selected = false,
    this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.onSurface;
    final effectiveIcon = selected && selectedIcon != null
        ? selectedIcon!
        : Icon(
            icon,
            size: ResponsiveUtils.scaledIconSize(context, size),
            color: effectiveColor,
            semanticLabel: semanticLabel,
          );

    Widget button = Material(
      color: backgroundColor ?? Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed != null && !loading
            ? () {
                if (enableHapticFeedback && !kIsWeb) {
                  HapticFeedback.lightImpact();
                }
                onPressed!();
              }
            : null,
        customBorder: const CircleBorder(),
        hoverColor: kIsWeb ? theme.hoverColor : null,
        child: Container(
          width: minTouchTarget.w,
          height: minTouchTarget.h,
          alignment: Alignment.center,
          child: loading
              ? SizedBox(
                  width: (size * 0.8).r,
                  height: (size * 0.8).r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                  ),
                )
              : effectiveIcon,
        ),
      ),
    );

    // Web enhancements
    if (kIsWeb) {
      button = MouseRegion(
        cursor: (onPressed != null && !loading)
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: button,
      );
    }

    // Wrap with tooltip if provided
    if (tooltip != null && tooltip!.isNotEmpty) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    // Wrap with semantics
    return Semantics(
      button: true,
      enabled: onPressed != null && !loading,
      label: semanticLabel,
      hint: loading ? 'Loading' : null,
      selected: selected,
      child: button,
    );
  }
}