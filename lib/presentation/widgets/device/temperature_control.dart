/// Temperature Control Widget
///
/// Responsive temperature control for air conditioners
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';

class TemperatureControl extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  const TemperatureControl({
    super.key,
    required this.value,
    this.min = 15,
    this.max = 29,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lgR),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            min.toInt().toString(),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textTertiary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.mdR),
              child: Column(
                children: [
                  Text(
                    '${value.toInt()}°',
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xsR),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4.h,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8.r,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 16.r,
                      ),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: AppTheme.backgroundCardBorder,
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: value,
                      min: min,
                      max: max,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            max.toInt().toString(),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
