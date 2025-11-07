/// Time Picker Field Widget
///
/// Reusable time picker input field with consistent styling
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

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
        padding: const EdgeInsets.all(HvacSpacing.smR),
        decoration: BoxDecoration(
          color: HvacColors.backgroundDark,
          borderRadius: BorderRadius.circular(HvacRadius.smR),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
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
                  size: 14.0,
                  color: HvacColors.textSecondary,
                ),
                const SizedBox(width: HvacSpacing.xsR - 2.0),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.0,
                    color: HvacColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: HvacSpacing.xsR - 2.0),
            Text(
              currentTime != null
                  ? '${currentTime!.hour.toString().padLeft(2, '0')}:${currentTime!.minute.toString().padLeft(2, '0')}'
                  : '--:--',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: HvacColors.primaryOrange,
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
              primary: HvacColors.primaryOrange,
              onPrimary: Colors.white,
              surface: HvacColors.backgroundCard,
              onSurface: HvacColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: HvacColors.backgroundCard,
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
