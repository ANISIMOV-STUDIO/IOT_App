/// Fan Controls Widget - Supply and Exhaust fan sliders
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';

/// Compact fan controls widget with supply and exhaust sliders
class FanControlsWidget extends StatelessWidget {
  final int supplyFan;
  final int exhaustFan;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;

  const FanControlsWidget({
    super.key,
    required this.supplyFan,
    required this.exhaustFan,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BreezCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const Row(
            children: [
              Icon(
                Icons.air,
                size: 16,
                color: AppColors.accent,
              ),
              SizedBox(width: 6),
              Text(
                'Вентиляция',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Supply fan slider
          _CompactSlider(
            label: 'Приток',
            value: supplyFan,
            onChanged: onSupplyFanChanged,
            color: AppColors.accent,
            icon: Icons.arrow_downward_rounded,
          ),

          const SizedBox(height: 8),

          // Exhaust fan slider
          _CompactSlider(
            label: 'Вытяжка',
            value: exhaustFan,
            onChanged: onExhaustFanChanged,
            color: AppColors.accentOrange,
            icon: Icons.arrow_upward_rounded,
          ),
        ],
      ),
    );
  }
}

/// Compact slider for fan controls
class _CompactSlider extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int>? onChanged;
  final Color color;
  final IconData icon;

  const _CompactSlider({
    required this.label,
    required this.value,
    this.onChanged,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 10, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkTextMuted,
                  ),
                ),
              ],
            ),
            Text(
              '$value%',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Slider
        SizedBox(
          height: 24,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 100,
              onChanged: (v) => onChanged?.call(v.round()),
            ),
          ),
        ),
      ],
    );
  }
}
