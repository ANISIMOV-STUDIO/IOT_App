/// Home Control Cards Widget
///
/// Builds control cards for ventilation modes, temperature, and schedule
/// Part of home_screen.dart refactoring to respect 300-line limit
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/ventilation_mode.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../ventilation_mode_control.dart';
import '../ventilation_temperature_control.dart';
import '../ventilation_schedule_control.dart';

/// Control cards builder for home screen
class HomeControlCards extends StatelessWidget {
  final HvacUnit? currentUnit;
  final Function(VentilationMode) onModeChanged;
  final Function(int) onSupplyFanChanged;
  final Function(int) onExhaustFanChanged;
  final VoidCallback onSchedulePressed;

  const HomeControlCards({
    super.key,
    required this.currentUnit,
    required this.onModeChanged,
    required this.onSupplyFanChanged,
    required this.onExhaustFanChanged,
    required this.onSchedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    if (currentUnit == null) {
      return _buildNoDeviceSelected(context);
    }

    final isMobile = ResponsiveUtils.isMobile(context);

    return isMobile
        ? _buildMobileLayout()
        : _buildDesktopLayout();
  }

  Widget _buildNoDeviceSelected(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xlR),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.deviceNotSelected,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        VentilationModeControl(
          unit: currentUnit!,
          onModeChanged: onModeChanged,
          onSupplyFanChanged: onSupplyFanChanged,
          onExhaustFanChanged: onExhaustFanChanged,
        ),
        SizedBox(height: AppSpacing.mdV),
        VentilationTemperatureControl(unit: currentUnit!),
        SizedBox(height: AppSpacing.mdV),
        VentilationScheduleControl(
          unit: currentUnit!,
          onSchedulePressed: onSchedulePressed,
        ),
      ],
    ).animate()
      .fadeIn(duration: 500.ms, delay: 100.ms)
      .slideY(begin: 0.1, end: 0);
  }

  Widget _buildDesktopLayout() {
    return SizedBox(
      height: AppTheme.controlCardHeight.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: VentilationModeControl(
              unit: currentUnit!,
              onModeChanged: onModeChanged,
              onSupplyFanChanged: onSupplyFanChanged,
              onExhaustFanChanged: onExhaustFanChanged,
            ),
          ),
          SizedBox(width: AppSpacing.mdR),
          Expanded(
            child: VentilationTemperatureControl(unit: currentUnit!),
          ),
          SizedBox(width: AppSpacing.mdR),
          Expanded(
            child: VentilationScheduleControl(
              unit: currentUnit!,
              onSchedulePressed: onSchedulePressed,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms, delay: 100.ms)
      .slideY(begin: 0.1, end: 0);
  }
}