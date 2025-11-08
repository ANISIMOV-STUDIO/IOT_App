/// Material 3 Checkbox Component
/// Provides checkbox with label and HVAC theming
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

/// HVAC-themed checkbox with Material 3 design
class HvacCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final String? subtitle;
  final bool enabled;
  final Color? activeColor;
  final Color? checkColor;
  final EdgeInsetsGeometry? padding;

  const HvacCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.subtitle,
    this.enabled = true,
    this.activeColor,
    this.checkColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final checkbox = Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: activeColor ?? HvacColors.primaryOrange,
      checkColor: checkColor ?? HvacColors.textPrimary,
      side: BorderSide(
        color: enabled
            ? HvacColors.backgroundCardBorder
            : HvacColors.backgroundCardBorder.withValues(alpha: 0.3),
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );

    if (label == null && subtitle == null) {
      return checkbox;
    }

    return InkWell(
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: HvacSpacing.xs),
        child: Row(
          children: [
            checkbox,
            const SizedBox(width: HvacSpacing.xs),
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
          ],
        ),
      ),
    );
  }
}

/// Checkbox tile with leading checkbox
class HvacCheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final Color? activeColor;

  const HvacCheckboxTile({
    super.key,
    required this.value,
    required this.title,
    this.onChanged,
    this.subtitle,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
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
      checkColor: HvacColors.textPrimary,
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
