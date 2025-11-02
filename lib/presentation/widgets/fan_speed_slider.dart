/// Fan Speed Slider Widget
///
/// Slider for controlling supply/exhaust fan speed (0-100%)
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
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
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$value%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 20,
              ),
              activeTrackColor: AppTheme.primaryOrange,
              inactiveTrackColor: AppTheme.backgroundCardBorder,
              thumbColor: Colors.white,
              overlayColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
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
