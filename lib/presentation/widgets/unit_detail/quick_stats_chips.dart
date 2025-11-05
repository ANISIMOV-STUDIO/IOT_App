/// Quick Stats Chips
///
/// Status chips for unit detail app bar
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/ventilation_mode.dart';

class QuickStatsChips extends StatelessWidget {
  final HvacUnit unit;

  const QuickStatsChips({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatChip(
          icon: Icons.power_settings_new,
          label: unit.power ? 'ON' : 'OFF',
          color: unit.power
              ? HvacColors.success
              : HvacColors.textSecondary,
        ),
        const SizedBox(width: HvacSpacing.mdR),
        _buildStatChip(
          icon: Icons.thermostat,
          label: '${unit.currentTemp.round()}°C',
          color: HvacColors.primaryOrange,
        ),
        if (unit.ventMode != null) ...[
          const SizedBox(width: HvacSpacing.mdR),
          _buildStatChip(
            icon: Icons.air,
            label: unit.ventMode!.displayName,
            color: HvacColors.primaryBlue,
          ),
        ],
      ],
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HvacSpacing.smR,
        vertical: HvacSpacing.xsV,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: HvacRadius.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.0, color: color),
          const SizedBox(width: HvacSpacing.xsR),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}