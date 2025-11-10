/// Labeled Slider Component for HVAC UI Kit
///
/// Slider with label and value display
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

/// Professional slider with label and value
///
/// Usage:
/// ```dart
/// HvacLabeledSlider(
///   label: 'Fan Speed',
///   value: 50,
///   min: 0,
///   max: 100,
///   suffix: '%',
///   onChanged: (value) => setState(() => _speed = value),
/// )
/// ```
class HvacLabeledSlider extends StatelessWidget {
  /// Label text
  final String label;

  /// Current value
  final double value;

  /// Minimum value
  final double min;

  /// Maximum value
  final double max;

  /// Value suffix (e.g., '%', '°C')
  final String? suffix;

  /// Callback when value changes
  final ValueChanged<double>? onChanged;

  /// Number of divisions
  final int? divisions;

  /// Active color
  final Color? activeColor;

  /// Icon for label
  final IconData? icon;

  const HvacLabeledSlider({
    super.key,
    required this.label,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.suffix,
    this.onChanged,
    this.divisions,
    this.activeColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = activeColor ?? HvacColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label and value row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Label with optional icon
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: HvacColors.textSecondary,
                  ),
                  const SizedBox(width: HvacSpacing.xs),
                ],
                Text(
                  label,
                  style: HvacTypography.labelMedium.copyWith(
                    color: HvacColors.textSecondary,
                  ),
                ),
              ],
            ),
            // Value display
            Text(
              '${value.toInt()}${suffix ?? ''}',
              style: HvacTypography.titleSmall.copyWith(
                color: HvacColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: HvacSpacing.xs),
        // Slider
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: effectiveColor,
            inactiveTrackColor: HvacColors.backgroundCardBorder,
            thumbColor: effectiveColor,
            overlayColor: effectiveColor.withValues(alpha: 0.2),
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
