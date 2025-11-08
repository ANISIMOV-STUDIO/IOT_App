/// Room Card Stats
///
/// Statistics row for room card (temperature, humidity, fan speed)
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/theme/ui_constants.dart';

class RoomCardStats extends StatelessWidget {
  final double? temperature;
  final int? humidity;
  final int? fanSpeed;

  const RoomCardStats({
    super.key,
    this.temperature,
    this.humidity,
    this.fanSpeed,
  });

  @override
  Widget build(BuildContext context) {
    // MONOCHROMATIC: Use neutral shades for stats, not colorful icons
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (temperature != null)
          Flexible(
            child: RoomCardStatItem(
              icon: Icons.thermostat,
              value: '${temperature!.toStringAsFixed(1)}°',
              label: 'Темп',
              color: HvacColors.neutral100, // Light gray
              isCompact: true,
            ),
          ),
        if (humidity != null)
          Flexible(
            child: RoomCardStatItem(
              icon: Icons.water_drop,
              value: '$humidity%',
              label: 'Влаж',
              color: HvacColors.neutral200, // Medium gray
              isCompact: true,
            ),
          ),
        if (fanSpeed != null)
          Flexible(
            child: RoomCardStatItem(
              icon: Icons.air,
              value: '$fanSpeed%',
              label: 'Вент',
              color: HvacColors.neutral300, // Dark gray
              isCompact: true,
            ),
          ),
      ],
    );
  }
}

/// Reusable stat item widget
class RoomCardStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isCompact;

  const RoomCardStatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28.0,
            height: 28.0,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(HvacRadius.smR),
            ),
            child: Icon(
              icon,
              size: UIConstants.iconXsR,
              color: color,
            ),
          ),
          const SizedBox(width: HvacSpacing.xsR),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: HvacTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                label,
                style: HvacTypography.overline.copyWith(
                  fontSize: 10.0,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: UIConstants.iconXsR,
              color: color,
            ),
            const SizedBox(width: HvacSpacing.xxsR),
            Text(
              label,
              style: HvacTypography.overline,
            ),
          ],
        ),
        const SizedBox(height: HvacSpacing.xxsV),
        Text(
          value,
          style: HvacTypography.h5.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}
