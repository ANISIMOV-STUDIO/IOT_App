/// Temperature Control Widget
///
/// Responsive temperature control for air conditioners
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
class TemperatureControl extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  const TemperatureControl({
    super.key,
    required this.value,
    this.min = 15,
    this.max = 29,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: HvacSpacing.lgR),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            min.toInt().toString(),
            style: TextStyle(
              fontSize: 14.sp,
              color: HvacColors.textTertiary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.mdR),
              child: Column(
                children: [
                  Text(
                    '${value.toInt()}°',
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: HvacColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: HvacSpacing.xsR),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.h,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8.r,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 16.r,
                      ),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: HvacColors.backgroundCardBorder,
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: value,
                      min: min,
                      max: max,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            max.toInt().toString(),
            style: TextStyle(
              fontSize: 14.sp,
              color: HvacColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
