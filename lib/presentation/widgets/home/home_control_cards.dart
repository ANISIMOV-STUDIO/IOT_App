/// Home Control Cards Widget
///
/// Builds control cards for ventilation modes, temperature, and schedule
/// Part of home_screen.dart refactoring to respect 300-line limit
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
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

    // Adaptive layout based on screen width
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      // Desktop: use grid with 3 columns
      return _buildGridLayout(context, 3);
    } else if (width >= 600) {
      // Tablet: use grid with 2 columns
      return _buildGridLayout(context, 2);
    } else {
      // Mobile: use vertical column
      return _buildMobileLayout();
    }
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

  Widget _buildGridLayout(BuildContext context, int crossAxisCount) {
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

    final width = MediaQuery.of(context).size.width;
    final maxContentWidth = width >= 1024 ? 1600.0 : width;

    return Wrap(
      spacing: HvacSpacing.lgR,
      runSpacing: HvacSpacing.lgV,
      children: animatedCards.map((card) {
        return SizedBox(
          width: (maxContentWidth -
                  (HvacSpacing.lgR * 2) -
                  (HvacSpacing.lgR * (crossAxisCount - 1))) /
                 crossAxisCount,
          child: card,
        );
      }).toList(),
    );
  }
}
