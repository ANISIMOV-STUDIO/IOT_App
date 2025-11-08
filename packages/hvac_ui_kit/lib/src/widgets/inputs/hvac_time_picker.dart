/// Time Picker Component
/// Provides time selection with Material 3 styled picker
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../theme/typography.dart';

/// HVAC-themed time picker field
class HvacTimePicker extends StatelessWidget {
  final String label;
  final TimeOfDay? value;
  final IconData? icon;
  final ValueChanged<TimeOfDay?>? onChanged;
  final bool enabled;
  final String? hintText;
  final EdgeInsetsGeometry? padding;

  const HvacTimePicker({
    super.key,
    required this.label,
    this.value,
    this.icon,
    this.onChanged,
    this.enabled = true,
    this.hintText,
    this.padding,
  });

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _showTimePicker(BuildContext context) async {
    if (!enabled || onChanged == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: value ?? const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: HvacColors.primaryOrange,
              onPrimary: Colors.white,
              surface: HvacColors.backgroundCard,
              onSurface: HvacColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: HvacColors.backgroundCard,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      onChanged!(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTimePicker(context),
      child: Container(
        padding: padding ?? const EdgeInsets.all(HvacSpacing.sm),
        decoration: BoxDecoration(
          color: enabled
              ? HvacColors.backgroundDark
              : HvacColors.backgroundDark.withValues(alpha: 0.5),
          borderRadius: HvacRadius.smRadius,
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 14.0,
                    color: enabled
                        ? HvacColors.textSecondary
                        : HvacColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: HvacSpacing.xs),
                ],
                Text(
                  label,
                  style: HvacTypography.caption.copyWith(
                    color: enabled
                        ? HvacColors.textSecondary
                        : HvacColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: HvacSpacing.xs),
            Text(
              value != null ? _formatTime(value!) : (hintText ?? '--:--'),
              style: HvacTypography.h3.copyWith(
                color: enabled
                    ? (value != null
                        ? HvacColors.primaryOrange
                        : HvacColors.textSecondary)
                    : HvacColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact time picker for inline usage
class HvacTimePickerCompact extends StatelessWidget {
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?>? onChanged;
  final bool enabled;
  final IconData icon;
  final Color? color;

  const HvacTimePickerCompact({
    super.key,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.icon = Icons.access_time,
    this.color,
  });

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _showTimePicker(BuildContext context) async {
    if (!enabled || onChanged == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: value ?? const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: color ?? HvacColors.primaryOrange,
              onPrimary: Colors.white,
              surface: HvacColors.backgroundCard,
              onSurface: HvacColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: HvacColors.backgroundCard,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      onChanged!(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showTimePicker(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.sm,
          vertical: HvacSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color ?? HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.0,
              color: enabled
                  ? (color ?? HvacColors.primaryOrange)
                  : HvacColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(width: HvacSpacing.xs),
            Text(
              value != null ? _formatTime(value!) : '--:--',
              style: HvacTypography.bodyMedium.copyWith(
                color: enabled
                    ? (color ?? HvacColors.primaryOrange)
                    : HvacColors.textSecondary.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
