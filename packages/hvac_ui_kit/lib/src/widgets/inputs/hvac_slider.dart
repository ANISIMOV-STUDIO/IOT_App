/// Material 3 Slider Component
/// Provides customizable slider with HVAC theming
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

/// HVAC-themed slider with Material 3 design
class HvacSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;
  final int? divisions;
  final String? label;
  final String? topLabel;
  final bool showValue;
  final String Function(double)? valueFormatter;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final EdgeInsetsGeometry? padding;

  const HvacSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
    this.onChangeEnd,
    this.divisions,
    this.label,
    this.topLabel,
    this.showValue = false,
    this.valueFormatter,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.padding,
  });

  String _formatValue(double val) {
    if (valueFormatter != null) {
      return valueFormatter!(val);
    }
    if (divisions != null) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topLabel != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  topLabel!,
                  style: HvacTypography.bodyMedium.copyWith(
                    color: enabled
                        ? HvacColors.textPrimary
                        : HvacColors.textSecondary,
                  ),
                ),
                if (showValue)
                  Text(
                    _formatValue(value),
                    style: HvacTypography.bodyBold.copyWith(
                      color: activeColor ?? HvacColors.primaryOrange,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: HvacSpacing.xs),
          ],
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: activeColor ?? HvacColors.primaryOrange,
              inactiveTrackColor: inactiveColor ??
                  HvacColors.backgroundCardBorder.withValues(alpha: 0.3),
              thumbColor: activeColor ?? HvacColors.primaryOrange,
              overlayColor: (activeColor ?? HvacColors.primaryOrange)
                  .withValues(alpha: 0.2),
              valueIndicatorColor: activeColor ?? HvacColors.primaryOrange,
              valueIndicatorTextStyle: HvacTypography.caption.copyWith(
                color: HvacColors.textPrimary,
              ),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              label: label ?? (divisions != null ? _formatValue(value) : null),
              onChanged: enabled ? onChanged : null,
              onChangeEnd: onChangeEnd,
            ),
          ),
        ],
      ),
    );
  }
}

/// Range slider for selecting a range of values
class HvacRangeSlider extends StatelessWidget {
  final RangeValues values;
  final double min;
  final double max;
  final ValueChanged<RangeValues>? onChanged;
  final ValueChanged<RangeValues>? onChangeEnd;
  final int? divisions;
  final String? topLabel;
  final bool showValues;
  final String Function(double)? valueFormatter;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final EdgeInsetsGeometry? padding;

  const HvacRangeSlider({
    super.key,
    required this.values,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
    this.onChangeEnd,
    this.divisions,
    this.topLabel,
    this.showValues = false,
    this.valueFormatter,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.padding,
  });

  String _formatValue(double val) {
    if (valueFormatter != null) {
      return valueFormatter!(val);
    }
    if (divisions != null) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topLabel != null || showValues) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (topLabel != null)
                  Text(
                    topLabel!,
                    style: HvacTypography.bodyMedium.copyWith(
                      color: enabled
                          ? HvacColors.textPrimary
                          : HvacColors.textSecondary,
                    ),
                  ),
                if (showValues)
                  Text(
                    '${_formatValue(values.start)} - ${_formatValue(values.end)}',
                    style: HvacTypography.bodyBold.copyWith(
                      color: activeColor ?? HvacColors.primaryOrange,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: HvacSpacing.xs),
          ],
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: activeColor ?? HvacColors.primaryOrange,
              inactiveTrackColor: inactiveColor ??
                  HvacColors.backgroundCardBorder.withValues(alpha: 0.3),
              thumbColor: activeColor ?? HvacColors.primaryOrange,
              overlayColor: (activeColor ?? HvacColors.primaryOrange)
                  .withValues(alpha: 0.2),
              valueIndicatorColor: activeColor ?? HvacColors.primaryOrange,
              valueIndicatorTextStyle: HvacTypography.caption.copyWith(
                color: HvacColors.textPrimary,
              ),
            ),
            child: RangeSlider(
              values: RangeValues(
                values.start.clamp(min, max),
                values.end.clamp(min, max),
              ),
              min: min,
              max: max,
              divisions: divisions,
              labels: divisions != null
                  ? RangeLabels(
                      _formatValue(values.start),
                      _formatValue(values.end),
                    )
                  : null,
              onChanged: enabled ? onChanged : null,
              onChangeEnd: onChangeEnd,
            ),
          ),
        ],
      ),
    );
  }
}
