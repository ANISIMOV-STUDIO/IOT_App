/// Status item component for metrics display
///
/// Reusable component for displaying status information with icons
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Status bar item for displaying metrics
class StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isCompact;

  const StatusItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isCompact ? 14.w : 16.w,
            color: HvacColors.neutral200,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isCompact ? 9.sp : 10.sp,
                    color: HvacColors.textTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isCompact ? 12.sp : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Vertical divider for layout separation
class TemperatureDivider extends StatelessWidget {
  final double height;

  const TemperatureDivider({
    super.key,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: height.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      color: HvacColors.backgroundCardBorder,
    );
  }
}