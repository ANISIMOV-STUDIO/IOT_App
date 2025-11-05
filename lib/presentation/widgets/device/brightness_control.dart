/// Brightness Control Widget
///
/// Responsive brightness control for lamps
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
class BrightnessControl extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const BrightnessControl({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: HvacColors.backgroundDark,
            borderRadius: BorderRadius.circular(HvacRadius.mdR),
          ),
          child: const Icon(
            Icons.lightbulb_outline,
            size: 20.0,
            color: HvacColors.textSecondary,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.mdR),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8.0,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6.0,
                ),
                activeTrackColor: HvacColors.warning,
                inactiveTrackColor: HvacColors.backgroundCardBorder,
                thumbColor: Colors.white,
              ),
              child: Slider(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        Text(
          '${(value * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
