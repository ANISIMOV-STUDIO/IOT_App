/// Brightness Control Widget
///
/// Responsive brightness control for lamps
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/app_radius.dart';

class BrightnessControl extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const BrightnessControl({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: AppTheme.backgroundDark,
            borderRadius: BorderRadius.circular(AppRadius.mdR),
          ),
          child: Icon(
            Icons.lightbulb_outline,
            size: 20.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.mdR),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8.h,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 6.r,
                ),
                activeTrackColor: AppTheme.warning,
                inactiveTrackColor: AppTheme.backgroundCardBorder,
                thumbColor: Colors.white,
              ),
              child: Slider(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
