/// Schedule Edit Button Component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

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
          child: HvacOutlineButton(
            label: 'Настроить расписание',
            onPressed: onPressed,
          ),
        );
      },
    );
  }
}
