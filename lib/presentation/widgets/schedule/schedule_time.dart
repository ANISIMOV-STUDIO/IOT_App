/// Schedule Time Component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Schedule time display
class ScheduleTime extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final IconData icon;

  const ScheduleTime({
    super.key,
    required this.label,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: AdaptiveLayout.iconSize(context, base: 12),
                  color: HvacColors.textSecondary,
                ),
                SizedBox(
                    width: AdaptiveLayout.spacing(context, base: 4)),
                Flexible(
                  child: Text(
                    label,
                    style: HvacTypography.labelSmall.copyWith(
                      fontSize:
                          AdaptiveLayout.fontSize(context, base: 10),
                      color: HvacColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: AdaptiveLayout.spacing(context, base: 4)),
            Text(
              time != null
                  ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}'
                  : '--:--',
              style: HvacTypography.titleMedium.copyWith(
                fontSize: AdaptiveLayout.fontSize(context, base: 15),
                fontWeight: FontWeight.w700,
                color: HvacColors.textPrimary,
              ),
            ),
          ],
        );
      },
    );
  }
}
