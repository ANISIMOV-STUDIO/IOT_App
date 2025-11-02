/// Quick Stats Chips
///
/// Status chips for unit detail app bar
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
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
              ? AppTheme.success
              : AppTheme.textSecondary,
        ),
        SizedBox(width: AppSpacing.mdR),
        _buildStatChip(
          icon: Icons.thermostat,
          label: '${unit.currentTemp.round()}°C',
          color: AppTheme.primaryOrange,
        ),
        if (unit.ventMode != null) ...[
          SizedBox(width: AppSpacing.mdR),
          _buildStatChip(
            icon: Icons.air,
            label: unit.ventMode!.displayName,
            color: AppTheme.primaryBlue,
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
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.smR,
        vertical: AppSpacing.xsV,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: AppSpacing.xsR),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}