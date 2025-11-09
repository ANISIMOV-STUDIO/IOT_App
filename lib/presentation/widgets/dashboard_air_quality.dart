/// Dashboard Air Quality Widget
///
/// Air quality index display for dashboard
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

enum AirQualityLevel { excellent, good, moderate, poor, veryPoor }

class DashboardAirQuality extends StatelessWidget {
  final int aqi;
  final String location;
  final VoidCallback? onTap;

  const DashboardAirQuality({
    super.key,
    required this.aqi,
    required this.location,
    this.onTap,
  });

  AirQualityLevel get _level {
    if (aqi <= 50) return AirQualityLevel.excellent;
    if (aqi <= 100) return AirQualityLevel.good;
    if (aqi <= 150) return AirQualityLevel.moderate;
    if (aqi <= 200) return AirQualityLevel.poor;
    return AirQualityLevel.veryPoor;
  }

  Color get _levelColor {
    switch (_level) {
      case AirQualityLevel.excellent:
        return HvacColors.success;
      case AirQualityLevel.good:
        return HvacColors.success.withValues(alpha: 0.8);
      case AirQualityLevel.moderate:
        return HvacColors.warning;
      case AirQualityLevel.poor:
        return HvacColors.primaryOrange;
      case AirQualityLevel.veryPoor:
        return HvacColors.error;
    }
  }

  String get _levelText {
    switch (_level) {
      case AirQualityLevel.excellent:
        return 'Excellent';
      case AirQualityLevel.good:
        return 'Good';
      case AirQualityLevel.moderate:
        return 'Moderate';
      case AirQualityLevel.poor:
        return 'Poor';
      case AirQualityLevel.veryPoor:
        return 'Very Poor';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.xlR),
        decoration: HvacTheme.deviceCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(HvacSpacing.smR),
                      decoration: BoxDecoration(
                        color: _levelColor.withValues(alpha: 0.15),
                        borderRadius: HvacRadius.smRadius,
                      ),
                      child: Icon(
                        Icons.air,
                        color: _levelColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: HvacSpacing.sm),
                    Text(
                      'Air Quality',
                      style: HvacTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right,
                  color: HvacColors.textTertiary,
                  size: 20,
                ),
              ],
            ),

            const SizedBox(height: HvacSpacing.lg),

            // AQI Value
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  aqi.toString(),
                  style: HvacTypography.displayLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _levelColor,
                        height: 1,
                      ),
                ),
                const SizedBox(width: HvacSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: HvacSpacing.smR),
                  child: Text(
                    'AQI',
                    style: HvacTypography.bodyMedium.copyWith(
                          color: HvacColors.textSecondary,
                        ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: HvacSpacing.sm),

            // Level badge
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: HvacSpacing.mdR, vertical: HvacSpacing.xsR),
              decoration: BoxDecoration(
                color: _levelColor.withValues(alpha: 0.15),
                borderRadius: HvacRadius.smRadius,
                border: Border.all(
                  color: _levelColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _levelText,
                style: TextStyle(
                  color: _levelColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: HvacSpacing.sm),

            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: HvacColors.textTertiary,
                ),
                const SizedBox(width: HvacSpacing.xxs),
                Text(
                  location,
                  style: HvacTypography.bodySmall.copyWith(
                        color: HvacColors.textSecondary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
