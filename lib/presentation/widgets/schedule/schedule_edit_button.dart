/// Schedule Edit Button Component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:hvac_ui_kit/src/utils/adaptive_layout.dart' as adaptive;

/// Schedule edit button
class ScheduleEditButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ScheduleEditButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: HvacColors.primaryOrange,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  adaptive.AdaptiveLayout.borderRadius(context, base: 8),
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: deviceSize == DeviceSize.compact ? 10.0 : 12.0,
              ),
            ),
            child: Text(
              'Настроить расписание',
              style: HvacTypography.buttonMedium.copyWith(
                color: HvacColors.primaryOrange,
                fontSize: adaptive.AdaptiveLayout.fontSize(context, base: 13),
              ),
            ),
          ),
        );
      },
    );
  }
}
