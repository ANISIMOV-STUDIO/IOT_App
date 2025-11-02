/// Time Picker Field Widget
///
/// Reusable time picker input field with consistent styling
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/app_radius.dart';

class TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay? currentTime;
  final IconData icon;
  final ValueChanged<TimeOfDay?> onTimeChanged;

  const TimePickerField({
    super.key,
    required this.label,
    required this.currentTime,
    required this.icon,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTimePicker(context),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.smR),
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark,
          borderRadius: BorderRadius.circular(AppRadius.smR),
          border: Border.all(
            color: AppTheme.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 14.sp,
                  color: AppTheme.textSecondary,
                ),
                SizedBox(width: AppSpacing.xsR - 2.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xsR - 2.h),
            Text(
              currentTime != null
                  ? '${currentTime!.hour.toString().padLeft(2, '0')}:${currentTime!.minute.toString().padLeft(2, '0')}'
                  : '--:--',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: currentTime ?? const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryOrange,
              onPrimary: Colors.white,
              surface: AppTheme.backgroundCard,
              onSurface: AppTheme.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppTheme.backgroundCard,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      onTimeChanged(time);
    }
  }
}
