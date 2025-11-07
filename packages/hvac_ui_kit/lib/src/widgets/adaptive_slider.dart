/// Adaptive Slider Widget
///
/// Big-tech inspired slider with proper touch targets and responsive sizing
/// Based on Material Design 3 and iOS Human Interface Guidelines
library;

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/adaptive_layout.dart';

class AdaptiveSlider extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final Color? color;
  final String? unit;
  final bool showTickMarks;

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
    this.showTickMarks = true,
  });

  @override
  Widget build(BuildContext context) {
    // MONOCHROMATIC PALETTE - Ignore passed color, use luxury scheme
    // Active slider uses accent, inactive uses neutral gray
    const sliderColor = HvacColors.accent;
    const trackColor = HvacColors.neutral300;

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
                  color: HvacColors.textSecondary,
                ),
                SizedBox(width: AdaptiveLayout.spacing(context, base: 6)),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: AdaptiveLayout.fontSize(context, base: 13),
                      color: HvacColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: AdaptiveLayout.spacing(context, base: 8)),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: deviceSize == DeviceSize.compact ? 60.0 : 80.0,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AdaptiveLayout.spacing(context, base: 10),
                    vertical: AdaptiveLayout.spacing(context, base: 4),
                  ),
                  decoration: BoxDecoration(
                    color: sliderColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(
                      AdaptiveLayout.borderRadius(context, base: 8),
                    ),
                  ),
                  child: Text(
                    '$value$unit',
                    style: TextStyle(
                      fontSize: AdaptiveLayout.fontSize(context, base: 13),
                      fontWeight: FontWeight.w700,
                      color: sliderColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            SizedBox(height: AdaptiveLayout.spacing(context, base: 8)),

            // Slider - Monochromatic accent active, gray inactive
            SizedBox(
              height: AdaptiveLayout.getSliderHeight(context),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: sliderColor,
                  inactiveTrackColor: trackColor,
                  thumbColor:
                      HvacColors.textPrimary, // White thumb (luxury style)
                  overlayColor: sliderColor.withValues(alpha: 0.2),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius:
                        AdaptiveLayout.getSliderThumbRadius(context),
                  ),
                  trackHeight: deviceSize == DeviceSize.compact ? 4.0 : 6.0,
                  trackShape: const RoundedRectSliderTrackShape(),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius:
                        AdaptiveLayout.getSliderThumbRadius(context) * 1.5,
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
            if (showTickMarks && deviceSize != DeviceSize.compact)
              _buildTickMarks(context, deviceSize),
          ],
        );
      },
    );
  }

  Widget _buildTickMarks(BuildContext context, DeviceSize deviceSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$min$unit',
            style: TextStyle(
              fontSize: AdaptiveLayout.fontSize(context, base: 10),
              color: HvacColors.textTertiary,
            ),
          ),
          Text(
            '${(min + max) ~/ 2}$unit',
            style: TextStyle(
              fontSize: AdaptiveLayout.fontSize(context, base: 10),
              color: HvacColors.textTertiary,
            ),
          ),
          Text(
            '$max$unit',
            style: TextStyle(
              fontSize: AdaptiveLayout.fontSize(context, base: 10),
              color: HvacColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
