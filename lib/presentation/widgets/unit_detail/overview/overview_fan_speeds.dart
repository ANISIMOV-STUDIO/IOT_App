/// Fan Speeds Card Widget
///
/// Displays supply and exhaust fan speeds with visual indicators
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../domain/entities/hvac_unit.dart';

class OverviewFanSpeeds extends StatelessWidget {
  final HvacUnit unit;

  const OverviewFanSpeeds({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Скорости вентиляторов',
            style: HvacTypography.titleLarge.copyWith(
              fontSize: 16.0,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16.0),

          // Supply fan
          _FanSpeedRow(
            label: 'Приточный',
            speed: unit.supplyFanSpeed ?? 0,
            color: HvacColors.primaryOrange,
          ),
          const SizedBox(height: 12.0),

          // Exhaust fan
          _FanSpeedRow(
            label: 'Вытяжной',
            speed: unit.exhaustFanSpeed ?? 0,
            color: HvacColors.info,
          ),
        ],
      ),
    );
  }
}

class _FanSpeedRow extends StatelessWidget {
  final String label;
  final int speed;
  final Color color;

  const _FanSpeedRow({
    required this.label,
    required this.speed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.air, color: color, size: 20.0),
        const SizedBox(width: 12.0),
        Text(
          label,
          style: HvacTypography.bodyMedium.copyWith(
            fontSize: 14.0,
            color: HvacColors.textSecondary,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: HvacRadius.smRadius,
          ),
          child: Text(
            '$speed%',
            style: HvacTypography.titleLarge.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}