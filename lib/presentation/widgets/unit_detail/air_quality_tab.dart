/// Air Quality Tab Widget
///
/// Air quality tab showing air quality metrics, airflow animation, and recommendations
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../air_quality_indicator.dart';
import '../airflow_animation.dart';
import '../animated_stat_card.dart';

class AirQualityTab extends StatelessWidget {
  final HvacUnit unit;

  const AirQualityTab({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for air quality
    const airQualityLevel = AirQualityLevel.good;
    const co2Level = 650;
    const pm25Level = 12.5;
    const vocLevel = 180.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Air quality indicator
          const AirQualityIndicator(
            level: airQualityLevel,
            co2Level: co2Level,
            pm25Level: pm25Level,
            vocLevel: vocLevel,
          ),

          SizedBox(height: 20.h),

          // Airflow animation
          AirflowAnimation(
            isActive: unit.power,
            speed: unit.supplyFanSpeed ?? 0,
          ),

          SizedBox(height: 20.h),

          // Stats with animation
          Text(
            'Текущие показатели',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: AnimatedStatCard(
                  label: 'Температура',
                  value: '${unit.supplyAirTemp?.toInt() ?? 0}°C',
                  icon: Icons.thermostat,
                  color: AppTheme.primaryOrange,
                  trend: '+0.5°C',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AnimatedStatCard(
                  label: 'Влажность',
                  value: '${unit.humidity.toInt()}%',
                  icon: Icons.water_drop,
                  color: AppTheme.info,
                  trend: '-2%',
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: AnimatedStatCard(
                  label: 'Приточный',
                  value: '${unit.supplyFanSpeed ?? 0}%',
                  icon: Icons.air,
                  color: AppTheme.success,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AnimatedStatCard(
                  label: 'Вытяжной',
                  value: '${unit.exhaustFanSpeed ?? 0}%',
                  icon: Icons.air,
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Recommendations
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppTheme.info.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.info,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Рекомендация',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Качество воздуха хорошее. Рекомендуем поддерживать текущий режим вентиляции.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
