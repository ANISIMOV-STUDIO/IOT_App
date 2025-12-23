/// Device Zone Container - visual wrapper for device-specific widgets
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';

/// Container that visually separates device-specific widgets from global ones
/// Uses accent border and subtle background tint
class DeviceZoneContainer extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final EdgeInsets? padding;
  final Color? accentColor;

  const DeviceZoneContainer({
    super.key,
    required this.child,
    this.header,
    this.padding,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: accent,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) header!,
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Visual divider between Device Zone and Global Zone
class ZoneDivider extends StatelessWidget {
  final String? label;
  final IconData? icon;

  const ZoneDivider({
    super.key,
    this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    theme.colorScheme.mutedForeground.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          if (label != null || icon != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 14,
                      color: theme.colorScheme.mutedForeground,
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (label != null)
                    Text(
                      label!,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.mutedForeground,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.mutedForeground.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
