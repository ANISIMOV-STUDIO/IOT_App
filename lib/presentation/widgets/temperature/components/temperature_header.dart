/// Temperature display header component
///
/// Minimalist header with title and system status indicator
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Header with title and system status for temperature display
class TemperatureHeader extends StatelessWidget {
  final bool isMobile;
  final bool showDetails;
  final bool isSystemNormal;

  const TemperatureHeader({
    super.key,
    required this.isMobile,
    this.showDetails = false,
    required this.isSystemNormal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Simple icon without shimmer for calm look
        Container(
          width: isMobile ? 32.w : 36.w,
          height: isMobile ? 32.w : 36.w,
          decoration: BoxDecoration(
            color: HvacColors.neutral300.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: HvacColors.neutral300.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.thermostat_outlined,
            color: HvacColors.neutral200,
            size: isMobile ? 16.w : 18.w,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Мониторинг температур',
                style: TextStyle(
                  fontSize: isMobile ? 14.sp : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              if (showDetails) ...[
                SizedBox(height: 2.h),
                Text(
                  'Контроль теплообмена системы вентиляции',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: HvacColors.textTertiary,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ],
          ),
        ),
        _SystemStatusIndicator(isNormal: isSystemNormal),
      ],
    );
  }
}

/// System status indicator (minimalist)
class _SystemStatusIndicator extends StatelessWidget {
  final bool isNormal;

  const _SystemStatusIndicator({
    required this.isNormal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isNormal
            ? HvacColors.success.withValues(alpha: 0.1)
            : HvacColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: isNormal ? HvacColors.success : HvacColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            isNormal ? 'Норма' : 'Проверка',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: isNormal ? HvacColors.success : HvacColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}