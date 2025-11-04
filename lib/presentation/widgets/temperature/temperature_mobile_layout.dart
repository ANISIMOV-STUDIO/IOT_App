/// Mobile layout for temperature display
///
/// Compact, vertical stacking layout optimized for mobile devices
/// with responsive sizing and touch-friendly interactions.
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'components/temperature_header.dart';
import 'components/temperature_tile.dart';
import 'components/status_item.dart';
import 'temperature_helpers.dart';

class TemperatureMobileLayout extends StatelessWidget {
  final double? supplyTemp;
  final double? extractTemp;
  final double? outdoorTemp;
  final double? indoorTemp;

  const TemperatureMobileLayout({
    super.key,
    this.supplyTemp,
    this.extractTemp,
    this.outdoorTemp,
    this.indoorTemp,
  });

  @override
  Widget build(BuildContext context) {
    return PerformanceUtils.isolateRepaint(
      SmoothAnimations.fadeIn(
        duration: AnimationDurations.medium,
        child: GlassCard(
          padding: EdgeInsets.all(12.r),
          enableBlur: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Minimalist Header
              TemperatureHeader(
                isMobile: true,
                isSystemNormal: TemperatureHelpers.isSystemNormal(
                  supplyTemp,
                  extractTemp,
                ),
              ),
              SizedBox(height: 10.h),
              // Temperature Grid - 2x2
              _buildTemperatureGrid(context),
              // Status bar
              if (TemperatureHelpers.hasAllData(supplyTemp, extractTemp)) ...[
                SizedBox(height: 8.h),
                _buildStatusBar(context),
              ],
            ],
          ),
        ),
      ),
      debugLabel: 'TempDisplay-Mobile',
    );
  }

  /// Temperature grid for mobile (2x2)
  Widget _buildTemperatureGrid(BuildContext context) {
    return Column(
      children: [
        // Primary temps (supply & extract)
        Row(
          children: [
            Expanded(
              child: TemperatureTile(
                icon: Icons.arrow_downward_rounded,
                label: 'Приток',
                value: supplyTemp,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: TemperatureTile(
                icon: Icons.arrow_upward_rounded,
                label: 'Вытяжка',
                value: extractTemp,
              ),
            ),
          ],
        ),
        // Secondary temps (outdoor & indoor)
        if (TemperatureHelpers.hasSecondaryData(outdoorTemp, indoorTemp)) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              if (outdoorTemp != null)
                Expanded(
                  child: TemperatureTile(
                    icon: Icons.wb_sunny_outlined,
                    label: 'Наружный',
                    value: outdoorTemp,
                    isSecondary: true,
                  ),
                ),
              if (outdoorTemp != null && indoorTemp != null) SizedBox(width: 8.w),
              if (indoorTemp != null)
                Expanded(
                  child: TemperatureTile(
                    icon: Icons.home_outlined,
                    label: 'Внутренний',
                    value: indoorTemp,
                    isSecondary: true,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  /// Status bar with additional info
  Widget _buildStatusBar(BuildContext context) {
    final delta = TemperatureHelpers.getTempDelta(supplyTemp, extractTemp);
    final efficiency = TemperatureHelpers.getEfficiency(
      supplyTemp,
      extractTemp,
      outdoorTemp,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          StatusItem(
            icon: Icons.swap_vert,
            label: 'Δ температур',
            value: delta != null ? '${delta.toStringAsFixed(1)}°C' : '—',
            isCompact: true,
          ),
          if (efficiency != null) ...[
            SizedBox(width: 6.w),
            Container(
              width: 1,
              height: 16.h,
              color: HvacColors.backgroundCardBorder,
            ),
            SizedBox(width: 6.w),
            StatusItem(
              icon: Icons.speed,
              label: 'Эффективность',
              value: '${efficiency.toStringAsFixed(0)}%',
              isCompact: true,
            ),
          ],
        ],
      ),
    );
  }
}