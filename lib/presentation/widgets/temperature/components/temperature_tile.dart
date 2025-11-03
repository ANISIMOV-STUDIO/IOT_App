/// Compact temperature tile component
///
/// Reusable tile for displaying temperature values in grid layouts
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Compact temperature tile for grid layouts
class TemperatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final double? value;
  final bool isSecondary;

  const TemperatureTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: isSecondary ? 14.w : 16.w,
                color: HvacColors.neutral200,
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSecondary ? 10.sp : 11.sp,
                  color: HvacColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value != null ? '${value.toStringAsFixed(1)}°C' : '—',
            style: TextStyle(
              fontSize: isSecondary ? 18.sp : 22.sp,
              fontWeight: FontWeight.w600,
              color: value != null ? HvacColors.textPrimary : HvacColors.textDisabled,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}