/// Mini temperature badge for inline use
///
/// A compact, reusable widget for displaying temperature values
/// in a badge format with optional labels.
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class TemperatureBadge extends StatelessWidget {
  final double? temperature;
  final String label;

  const TemperatureBadge({
    super.key,
    required this.temperature,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.thermostat_outlined,
            size: 14.w,
            color: HvacColors.neutral200,
          ),
          SizedBox(width: 6.w),
          Text(
            temperature != null ? '${temperature!.toStringAsFixed(1)}°C' : '—',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          if (label.isNotEmpty) ...[
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: HvacColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}