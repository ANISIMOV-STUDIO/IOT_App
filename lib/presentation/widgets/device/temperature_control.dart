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
                  HvacSlider(
                    value: value,
                    min: min,
                    max: max,
                    label: '${value.toInt()}°',
                    onChanged: onChanged,
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
