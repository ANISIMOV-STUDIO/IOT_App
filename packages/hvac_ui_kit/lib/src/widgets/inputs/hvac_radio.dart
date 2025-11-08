/// Material 3 Radio Component
/// Provides radio buttons with label and HVAC theming
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

/// HVAC-themed radio button with Material 3 design
class HvacRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? subtitle;
  final bool enabled;
  final Color? activeColor;

  const HvacRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.subtitle,
    this.enabled = true,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final radio = Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: enabled ? onChanged : null,
      activeColor: activeColor ?? HvacColors.primaryOrange,
    );

    if (label == null && subtitle == null) {
      return radio;
    }

    return InkWell(
      onTap: enabled && onChanged != null ? () => onChanged!(value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: HvacSpacing.xs),
        child: Row(
          children: [
            radio,
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

/// Radio option for use with HvacRadioGroup
class HvacRadioOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;

  const HvacRadioOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.enabled = true,
  });
}

/// Radio group for convenient multiple radio selection
class HvacRadioGroup<T> extends StatelessWidget {
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final List<HvacRadioOption<T>> options;
  final Color? activeColor;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const HvacRadioGroup({
    super.key,
    required this.options,
    this.groupValue,
    this.onChanged,
    this.activeColor,
    this.padding,
    this.spacing = HvacSpacing.xs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          options.length,
          (index) {
            final option = options[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < options.length - 1 ? spacing : 0,
              ),
              child: HvacRadio<T>(
                value: option.value,
                groupValue: groupValue,
                onChanged: onChanged,
                label: option.label,
                subtitle: option.subtitle,
                enabled: option.enabled,
                activeColor: activeColor,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Radio tile with leading radio button
class HvacRadioTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;
  final Color? activeColor;

  const HvacRadioTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.title,
    this.onChanged,
    this.subtitle,
    this.leading,
    this.enabled = true,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
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
