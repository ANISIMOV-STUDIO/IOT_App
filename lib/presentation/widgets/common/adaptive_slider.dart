/// Adaptive Slider Widget
///
/// Big-tech inspired slider with proper touch targets and responsive sizing
/// Based on Material Design 3 and iOS Human Interface Guidelines
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/adaptive_layout.dart';

class AdaptiveSlider extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final Color? color;
  final String? unit;

  const AdaptiveSlider({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    this.min = 0,
    this.max = 100,
    required this.onChanged,
    this.color,
    this.unit = '%',
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.primaryOrange;

    return AdaptiveControl(
      builder: (context, deviceSize) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label row
            Row(
              children: [
                Icon(
                  icon,
                  size: AdaptiveLayout.iconSize(context, base: 16),
                  color: AppTheme.textSecondary,
                ),
                SizedBox(width: AdaptiveLayout.spacing(context, base: 6)),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: AdaptiveLayout.fontSize(context, base: 13),
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: AdaptiveLayout.spacing(context, base: 8)),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: deviceSize == DeviceSize.compact ? 60.w : 80.w,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AdaptiveLayout.spacing(context, base: 10),
                    vertical: AdaptiveLayout.spacing(context, base: 4),
                  ),
                  decoration: BoxDecoration(
                    color: effectiveColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(
                      AdaptiveLayout.borderRadius(context, base: 8),
                    ),
                  ),
                  child: Text(
                    '$value$unit',
                    style: TextStyle(
                      fontSize: AdaptiveLayout.fontSize(context, base: 13),
                      fontWeight: FontWeight.w700,
                      color: effectiveColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            SizedBox(height: AdaptiveLayout.spacing(context, base: 8)),

            // Slider
            SizedBox(
              height: AdaptiveLayout.getSliderHeight(context),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: effectiveColor,
                  inactiveTrackColor: effectiveColor.withValues(alpha: 0.2),
                  thumbColor: effectiveColor,
                  overlayColor: effectiveColor.withValues(alpha: 0.2),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: AdaptiveLayout.getSliderThumbRadius(context),
                  ),
                  trackHeight: deviceSize == DeviceSize.compact ? 4.h : 6.h,
                  trackShape: const RoundedRectSliderTrackShape(),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: AdaptiveLayout.getSliderThumbRadius(context) * 1.5,
                  ),
                ),
                child: Slider(
                  value: value.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: max - min,
                  onChanged: (newValue) => onChanged(newValue.toInt()),
                ),
              ),
            ),

            // Optional: tick marks for tablet/desktop
            if (deviceSize != DeviceSize.compact) _buildTickMarks(context, deviceSize),
          ],
        );
      },
    );
  }

  Widget _buildTickMarks(BuildContext context, DeviceSize deviceSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$min$unit',
            style: TextStyle(
              fontSize: AdaptiveLayout.fontSize(context, base: 10),
              color: AppTheme.textTertiary,
            ),
          ),
          Text(
            '${(min + max) ~/ 2}$unit',
            style: TextStyle(
              fontSize: AdaptiveLayout.fontSize(context, base: 10),
              color: AppTheme.textTertiary,
            ),
          ),
          Text(
            '$max$unit',
            style: TextStyle(
              fontSize: AdaptiveLayout.fontSize(context, base: 10),
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
