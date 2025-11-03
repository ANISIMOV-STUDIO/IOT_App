/// Detailed temperature card component
///
/// Enhanced temperature display card for desktop layouts
/// with comprehensive information and visual hierarchy
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Detailed temperature card for desktop view
class DetailedTemperatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double? value;
  final String description;
  final bool isPrimary;

  const DetailedTemperatureCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.description,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isPrimary ? 16.r : 14.r),
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isPrimary
              ? HvacColors.neutral300.withValues(alpha: 0.3)
              : HvacColors.backgroundCardBorder,
          width: isPrimary ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: HvacColors.neutral300.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  size: isPrimary ? 20.w : 18.w,
                  color: HvacColors.neutral200,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: isPrimary ? 12.sp : 11.sp,
                        fontWeight: FontWeight.w600,
                        color: HvacColors.textPrimary,
                      ),
                    ),
                    if (isPrimary) ...[
                      SizedBox(height: 2.h),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: HvacColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isPrimary ? 14.h : 12.h),
          Text(
            value != null ? '${value.toStringAsFixed(1)}°C' : '—',
            style: TextStyle(
              fontSize: isPrimary ? 32.sp : 24.sp,
              fontWeight: FontWeight.w600,
              color: value != null ? HvacColors.textPrimary : HvacColors.textDisabled,
              letterSpacing: -1.5,
            ),
          ),
          if (!isPrimary && description.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 9.sp,
                color: HvacColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}