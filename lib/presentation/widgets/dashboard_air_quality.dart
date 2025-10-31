/// Dashboard Air Quality Widget
///
/// Air quality index display for dashboard
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
        return AppTheme.success;
      case AirQualityLevel.good:
        return const Color(0xFF7CB342);
      case AirQualityLevel.moderate:
        return AppTheme.warning;
      case AirQualityLevel.poor:
        return const Color(0xFFFF7043);
      case AirQualityLevel.veryPoor:
        return AppTheme.error;
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
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.deviceCard(),
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
                      padding: const EdgeInsets.all(8),
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
                  color: AppTheme.textTertiary,
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
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'AQI',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Level badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
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
