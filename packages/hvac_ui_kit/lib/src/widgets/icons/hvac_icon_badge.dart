/// Icon Badge Component
/// Provides icons with notification badges
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

/// Icon with notification badge
class HvacIconBadge extends StatelessWidget {
  final IconData icon;
  final int? count;
  final bool showDot;
  final double iconSize;
  final Color? iconColor;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final VoidCallback? onTap;
  final String? tooltip;

  const HvacIconBadge({
    super.key,
    required this.icon,
    this.count,
    this.showDot = false,
    this.iconSize = 24.0,
    this.iconColor,
    this.badgeColor,
    this.badgeTextColor,
    this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final hasNotification = (count != null && count! > 0) || showDot;

    Widget iconWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor ?? HvacColors.textSecondary,
        ),
        if (hasNotification)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              constraints: BoxConstraints(
                minWidth: showDot ? 8 : 16,
                minHeight: showDot ? 8 : 16,
              ),
              padding: showDot
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor ?? HvacColors.error,
                shape: showDot ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: showDot ? null : BorderRadius.circular(8),
                border: Border.all(
                  color: HvacColors.backgroundMain,
                  width: 1.5,
                ),
              ),
              child: showDot
                  ? null
                  : Center(
                      child: Text(
                        count! > 99 ? '99+' : count.toString(),
                        style: HvacTypography.caption.copyWith(
                          fontSize: 10,
                          color: badgeTextColor ?? Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ),
            ),
          ),
      ],
    );

    if (tooltip != null) {
      iconWidget = Tooltip(
        message: tooltip!,
        child: iconWidget,
      );
    }

    if (onTap != null) {
      iconWidget = IconButton(
        icon: iconWidget,
        onPressed: onTap,
        iconSize: iconSize,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: iconSize + 8,
          minHeight: iconSize + 8,
        ),
      );
    }

    return iconWidget;
  }
}

/// Status icon with colored indicator
class HvacStatusIcon extends StatelessWidget {
  final IconData icon;
  final Color statusColor;
  final double iconSize;
  final Color? iconColor;
  final bool showPulse;
  final VoidCallback? onTap;

  const HvacStatusIcon({
    super.key,
    required this.icon,
    required this.statusColor,
    this.iconSize = 24.0,
    this.iconColor,
    this.showPulse = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor ?? HvacColors.textSecondary,
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: HvacColors.backgroundMain,
                width: 2,
              ),
              boxShadow: showPulse
                  ? [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.6),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ],
    );

    if (onTap != null) {
      return IconButton(
        icon: iconWidget,
        onPressed: onTap,
        iconSize: iconSize,
      );
    }

    return iconWidget;
  }
}
