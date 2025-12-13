/// Brightness Control Widget
///
/// Responsive brightness control for lamps
library;

import 'package:flutter/material.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';

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
            color: NeumorphicColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.lightbulb_outline,
            size: 20.0,
            color: NeumorphicColors.lightTextSecondary,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: NeumorphicSpacing.md),
            child: Slider(
              value: value,
              min: 0,
              max: 1,
              label: '${(value * 100).toInt()}%',
              onChanged: onChanged,
            ),
          ),
        ),
        Text(
          '${(value * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: NeumorphicColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
