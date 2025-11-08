/// Material 3 Switch Component
/// Provides animated switch with label and HVAC theming
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

/// HVAC-themed switch with Material 3 design
class HvacSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? subtitle;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final EdgeInsetsGeometry? padding;

  const HvacSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.subtitle,
    this.enabled = true,
    this.activeColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final switchWidget = Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: activeColor ?? HvacColors.primaryOrange,
      inactiveThumbColor: inactiveThumbColor ??
          HvacColors.backgroundCardBorder.withValues(alpha: 0.5),
      inactiveTrackColor: inactiveTrackColor ??
          HvacColors.backgroundCardBorder.withValues(alpha: 0.3),
    );

    if (label == null && subtitle == null) {
      return switchWidget;
    }

    return InkWell(
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: HvacSpacing.xs),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (label != null)
                    Text(
                      label!,
                      style: HvacTypography.bodyMedium.copyWith(
                        color: enabled
                            ? HvacColors.textPrimary
                            : HvacColors.textSecondary,
                      ),
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: HvacSpacing.xxs),
                    Text(
                      subtitle!,
                      style: HvacTypography.caption.copyWith(
                        color: HvacColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: HvacSpacing.sm),
            switchWidget,
          ],
        ),
      ),
    );
  }
}

/// Switch tile with trailing switch
class HvacSwitchTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;
  final Color? activeColor;

  const HvacSwitchTile({
    super.key,
    required this.value,
    required this.title,
    this.onChanged,
    this.subtitle,
    this.leading,
    this.enabled = true,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: enabled ? onChanged : null,
      title: Text(
        title,
        style: HvacTypography.bodyMedium.copyWith(
          color:
              enabled ? HvacColors.textPrimary : HvacColors.textSecondary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: HvacTypography.caption.copyWith(
                color: HvacColors.textSecondary,
              ),
            )
          : null,
      secondary: leading,
      activeColor: activeColor ?? HvacColors.primaryOrange,
      inactiveThumbColor:
          HvacColors.backgroundCardBorder.withValues(alpha: 0.5),
      inactiveTrackColor:
          HvacColors.backgroundCardBorder.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: HvacSpacing.sm,
        vertical: HvacSpacing.xxs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
