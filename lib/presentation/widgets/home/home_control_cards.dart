/// Home Control Cards Widget
///
/// Builds control cards for ventilation modes, temperature, and schedule
/// Part of home_screen.dart refactoring to respect 300-line limit
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/theme/ui_constants.dart';
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
    final isTablet = ResponsiveUtils.isTablet(context);

    // Both mobile and tablet use vertical layout
    // Only desktop (>1200px) uses horizontal layout
    return (isMobile || isTablet)
        ? _buildMobileLayout()
        : _buildDesktopLayout();
  }

  Widget _buildNoDeviceSelected(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.xlR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: HvacColors.backgroundCardBorder.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.deviceNotSelected,
          style: TextStyle(
            fontSize: 14.sp,
            color: HvacColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final cards = [
      VentilationModeControl(
        unit: currentUnit!,
        onModeChanged: onModeChanged,
        onSupplyFanChanged: onSupplyFanChanged,
        onExhaustFanChanged: onExhaustFanChanged,
      ),
      VentilationTemperatureControl(unit: currentUnit!),
      VentilationScheduleControl(
        unit: currentUnit!,
        onSchedulePressed: onSchedulePressed,
      ),
    ];

    // Apply staggered animations
    final animatedCards = SmoothAnimations.staggeredList(
      children: cards,
      staggerDelay: AnimationDurations.staggerMedium,
      itemDuration: AnimationDurations.medium,
      fadeIn: true,
      slideIn: true,
      scaleIn: false,
    );

    return Column(
      children: List.generate(
        animatedCards.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index < animatedCards.length - 1 ? HvacSpacing.mdV : 0,
          ),
          child: animatedCards[index],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SmoothAnimations.fadeIn(
      delay: AnimationDurations.staggerShort,
      duration: AnimationDurations.medium,
      child: SmoothAnimations.slideIn(
        begin: const Offset(0, 0.05),
        delay: AnimationDurations.staggerShort,
        duration: AnimationDurations.medium,
        child: SizedBox(
          height: UIConstants.controlCardHeight.h,
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
              const SizedBox(width: HvacSpacing.mdR),
              Expanded(
                child: VentilationTemperatureControl(unit: currentUnit!),
              ),
              const SizedBox(width: HvacSpacing.mdR),
              Expanded(
                child: VentilationScheduleControl(
                  unit: currentUnit!,
                  onSchedulePressed: onSchedulePressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
