/// Temperature Display Compact
///
/// Modern, aligned temperature display widget
/// Fixes "crooked" layout and improves visual hierarchy
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

class TemperatureDisplayCompact extends StatelessWidget {
  final double? supplyTemp;
  final double? extractTemp;
  final double? outdoorTemp;
  final double? indoorTemp;
  final bool isCompact;

  const TemperatureDisplayCompact({
    super.key,
    this.supplyTemp,
    this.extractTemp,
    this.outdoorTemp,
    this.indoorTemp,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactLayout();
    }
    return _buildFullLayout();
  }

  Widget _buildCompactLayout() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppTheme.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.thermostat,
                  color: AppTheme.info,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Температуры',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'Текущие показатели',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Temperature Grid - 2x2
          Row(
            children: [
              Expanded(
                child: _buildTempItem(
                  icon: Icons.download,
                  label: 'Приток',
                  value: supplyTemp,
                  color: AppTheme.info,
                  isLeft: true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTempItem(
                  icon: Icons.upload,
                  label: 'Вытяжка',
                  value: extractTemp,
                  color: AppTheme.warning,
                  isLeft: false,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 400.ms)
      .slideY(begin: 0.05, end: 0);
  }

  Widget _buildFullLayout() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.backgroundCard,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
              border: const Border(
                bottom: BorderSide(
                  color: AppTheme.backgroundCardBorder,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.info.withValues(alpha: 0.2),
                        AppTheme.info.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.thermostat_outlined,
                    color: AppTheme.info,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Мониторинг температур',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Все датчики в норме',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Temperature Values
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Primary temperatures
                Row(
                  children: [
                    Expanded(
                      child: _buildFullTempItem(
                        icon: Icons.download,
                        label: 'Приток',
                        value: supplyTemp,
                        color: AppTheme.info,
                        isPrimary: true,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60.h,
                      color: AppTheme.backgroundCardBorder,
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                    Expanded(
                      child: _buildFullTempItem(
                        icon: Icons.upload,
                        label: 'Вытяжка',
                        value: extractTemp,
                        color: AppTheme.warning,
                        isPrimary: true,
                      ),
                    ),
                  ],
                ),

                if (outdoorTemp != null || indoorTemp != null) ...[
                  SizedBox(height: 16.h),
                  Container(
                    height: 1,
                    color: AppTheme.backgroundCardBorder,
                  ),
                  SizedBox(height: 16.h),

                  // Secondary temperatures
                  Row(
                    children: [
                      if (outdoorTemp != null)
                        Expanded(
                          child: _buildFullTempItem(
                            icon: Icons.landscape,
                            label: 'Наружный',
                            value: outdoorTemp,
                            color: AppTheme.textSecondary,
                            isPrimary: false,
                          ),
                        ),
                      if (outdoorTemp != null && indoorTemp != null)
                        SizedBox(width: 16.w),
                      if (indoorTemp != null)
                        Expanded(
                          child: _buildFullTempItem(
                            icon: Icons.home,
                            label: 'Комнатный',
                            value: indoorTemp,
                            color: AppTheme.success,
                            isPrimary: false,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 400.ms)
      .scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1));
  }

  Widget _buildTempItem({
    required IconData icon,
    required String label,
    required double? value,
    required Color color,
    required bool isLeft,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.w,
            color: color,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value != null ? '${value.toStringAsFixed(1)}°' : '--',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: isLeft ? 100 : 200))
      .fadeIn()
      .slideX(begin: isLeft ? -0.05 : 0.05, end: 0);
  }

  Widget _buildFullTempItem({
    required IconData icon,
    required String label,
    required double? value,
    required Color color,
    required bool isPrimary,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isPrimary ? 32.w : 28.w,
              height: isPrimary ? 32.w : 28.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                size: isPrimary ? 18.w : 16.w,
                color: color,
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value != null ? '${value.toStringAsFixed(1)}°C' : '--',
                  style: TextStyle(
                    fontSize: isPrimary ? 22.sp : 18.sp,
                    fontWeight: FontWeight.w700,
                    color: isPrimary ? color : AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Mini temperature indicator for inline use
class TemperatureBadge extends StatelessWidget {
  final double? temperature;
  final String label;
  final Color? color;

  const TemperatureBadge({
    super.key,
    required this.temperature,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? AppTheme.info;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: displayColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: displayColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.thermostat,
            size: 14.w,
            color: displayColor,
          ),
          SizedBox(width: 4.w),
          Text(
            temperature != null
                ? '${temperature!.toStringAsFixed(1)}°'
                : '--',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: displayColor,
            ),
          ),
          if (label.isNotEmpty) ...[
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}