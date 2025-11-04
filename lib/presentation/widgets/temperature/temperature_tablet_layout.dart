/// Tablet layout for temperature display
///
/// Horizontal, spacious layout optimized for tablet devices
/// with enhanced visual hierarchy and information density.
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'components/temperature_header.dart';
import 'components/status_item.dart';
import 'temperature_helpers.dart';

class TemperatureTabletLayout extends StatelessWidget {
  final double? supplyTemp;
  final double? extractTemp;
  final double? outdoorTemp;
  final double? indoorTemp;

  const TemperatureTabletLayout({
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
          padding: EdgeInsets.all(20.r),
          enableBlur: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TemperatureHeader(
                isMobile: false,
                isSystemNormal: TemperatureHelpers.isSystemNormal(
                  supplyTemp,
                  extractTemp,
                ),
              ),
              SizedBox(height: 20.h),
              // Horizontal layout with dividers
              Row(
                children: [
                  Expanded(
                    child: _buildTempColumn(
                      context,
                      icon: Icons.arrow_downward_rounded,
                      label: 'Приточный воздух',
                      value: supplyTemp,
                      subtitle: 'Поступление',
                    ),
                  ),
                  const TemperatureDivider(),
                  Expanded(
                    child: _buildTempColumn(
                      context,
                      icon: Icons.arrow_upward_rounded,
                      label: 'Вытяжной воздух',
                      value: extractTemp,
                      subtitle: 'Удаление',
                    ),
                  ),
                  if (TemperatureHelpers.hasSecondaryData(outdoorTemp, indoorTemp)) ...[
                    const TemperatureDivider(),
                    Expanded(
                      child: _buildTempColumn(
                        context,
                        icon: Icons.home_outlined,
                        label: 'Помещение',
                        value: indoorTemp ?? outdoorTemp,
                        subtitle: indoorTemp != null ? 'Комната' : 'Улица',
                      ),
                    ),
                  ],
                ],
              ),
              if (TemperatureHelpers.hasAllData(supplyTemp, extractTemp)) ...[
                SizedBox(height: 16.h),
                _buildStatusBar(context),
              ],
            ],
          ),
        ),
      ),
      debugLabel: 'TempDisplay-Tablet',
    );
  }

  /// Temperature column for tablet
  Widget _buildTempColumn(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double? value,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24.w,
          color: HvacColors.neutral200,
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: HvacColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          value != null ? '${value.toStringAsFixed(1)}°C' : '—',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: value != null ? HvacColors.textPrimary : HvacColors.textDisabled,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10.sp,
            color: HvacColors.textTertiary,
          ),
        ),
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
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark,
        borderRadius: HvacRadius.smRadius,
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
            isCompact: false,
          ),
          if (efficiency != null) ...[
            SizedBox(width: 12.w),
            Container(
              width: 1,
              height: 20.h,
              color: HvacColors.backgroundCardBorder,
            ),
            SizedBox(width: 12.w),
            StatusItem(
              icon: Icons.speed,
              label: 'Эффективность',
              value: '${efficiency.toStringAsFixed(0)}%',
              isCompact: false,
            ),
          ],
        ],
      ),
    );
  }
}