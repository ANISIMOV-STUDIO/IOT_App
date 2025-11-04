/// Fan Speed Slider Widget
///
/// Slider for controlling supply/exhaust fan speed (0-100%)
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
class FanSpeedSlider extends StatelessWidget {
  final String label;
  final int value; // 0-100%
  final ValueChanged<int> onChanged;
  final bool enabled;
  final IconData? icon;

  const FanSpeedSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.md),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                      color: HvacColors.textSecondary,
                    ),
                    const SizedBox(width: HvacSpacing.xs),
                  ],
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.sm, vertical: HvacSpacing.xxs + 2),
                decoration: BoxDecoration(
                  color: HvacColors.backgroundDark,
                  borderRadius: HvacRadius.smRadius,
                ),
                child: Text(
                  '$value%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: HvacColors.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.sm),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 20,
              ),
              activeTrackColor: HvacColors.primaryOrange,
              inactiveTrackColor: HvacColors.backgroundCardBorder,
              thumbColor: Colors.white,
              overlayColor: HvacColors.primaryOrange.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 100,
              divisions: 20,
              label: '$value%',
              onChanged: enabled ? (val) => onChanged(val.round()) : null,
            ),
          ),
        ],
      ),
    );
  }
}
