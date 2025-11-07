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
            style: const TextStyle(
              fontSize: 14.0,
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
                    style: const TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: HvacColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: HvacSpacing.xsR),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.0,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8.0,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16.0,
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
            style: const TextStyle(
              fontSize: 14.0,
              color: HvacColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
