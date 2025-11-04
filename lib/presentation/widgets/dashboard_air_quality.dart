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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.air,
                        color: _levelColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Air Quality',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

            const SizedBox(height: 20),

            // AQI Value
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  aqi.toString(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: _levelColor,
                        height: 1,
                      ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: HvacSpacing.smR),
                  child: Text(
                    'AQI',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: HvacColors.textSecondary,
                        ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Level badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.mdR, vertical: HvacSpacing.xsR),
              decoration: BoxDecoration(
                color: _levelColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
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

            const SizedBox(height: 12),

            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: HvacColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
