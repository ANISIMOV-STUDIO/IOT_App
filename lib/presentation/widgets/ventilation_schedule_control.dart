/// Ventilation Schedule Control Widget
///
/// Adaptive card for schedule overview and quick status
/// Uses big-tech adaptive layout approach
/// Refactored to <150 lines by extracting components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:hvac_ui_kit/src/utils/adaptive_layout.dart' as adaptive;
import '../../domain/entities/hvac_unit.dart';
import 'schedule/schedule_components.dart';

class VentilationScheduleControl extends StatelessWidget {
  final HvacUnit unit;
  final VoidCallback? onSchedulePressed;

  const VentilationScheduleControl({
    super.key,
    required this.unit,
    this.onSchedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        final now = DateTime.now();
        final dayOfWeek = now.weekday;
        final todaySchedule = unit.schedule?.getDaySchedule(dayOfWeek);

        return Container(
          padding: adaptive.AdaptiveLayout.controlPadding(context),
          decoration: BoxDecoration(
            color: HvacColors.backgroundCard,
            borderRadius: BorderRadius.circular(
              adaptive.AdaptiveLayout.borderRadius(context, base: 16),
            ),
            border: Border.all(
              color: HvacColors.backgroundCardBorder,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Check if we have a height constraint (desktop layout)
              final hasHeightConstraint =
                  constraints.maxHeight != double.infinity;

              if (hasHeightConstraint) {
                return _buildDesktopLayout(
                    deviceSize, dayOfWeek, todaySchedule);
              } else {
                return _buildMobileLayout(deviceSize, dayOfWeek, todaySchedule);
              }
            },
          ),
        );
      },
    );
  }

  /// Desktop layout with constrained height - uses scrollable content
  Widget _buildDesktopLayout(
      DeviceSize deviceSize, int dayOfWeek, dynamic todaySchedule) {
    return AdaptiveControl(
      builder: (context, _) {
        final spacing = switch (deviceSize) {
          DeviceSize.compact => 12.0,
          DeviceSize.medium ||
          DeviceSize.expanded =>
            adaptive.AdaptiveLayout.spacing(context, base: 12),
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScheduleHeader(),
            SizedBox(height: spacing),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TodayScheduleCard(
                      dayOfWeek: dayOfWeek,
                      schedule: todaySchedule,
                    ),
                    SizedBox(height: spacing),
                    ScheduleQuickStats(
                      isPowerOn: unit.power,
                      fanSpeed: unit.supplyFanSpeed,
                    ),
                    SizedBox(height: spacing),
                    ScheduleEditButton(onPressed: onSchedulePressed),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Mobile layout without height constraint
  Widget _buildMobileLayout(
      DeviceSize deviceSize, int dayOfWeek, dynamic todaySchedule) {
    return AdaptiveControl(
      builder: (context, _) {
        final spacing = switch (deviceSize) {
          DeviceSize.compact => 12.0,
          DeviceSize.medium ||
          DeviceSize.expanded =>
            adaptive.AdaptiveLayout.spacing(context, base: 12),
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const ScheduleHeader(),
            SizedBox(height: spacing),
            TodayScheduleCard(
              dayOfWeek: dayOfWeek,
              schedule: todaySchedule,
            ),
            SizedBox(height: spacing),
            ScheduleQuickStats(
              isPowerOn: unit.power,
              fanSpeed: unit.supplyFanSpeed,
            ),
            SizedBox(height: spacing),
            ScheduleEditButton(onPressed: onSchedulePressed),
          ],
        );
      },
    );
  }
}
