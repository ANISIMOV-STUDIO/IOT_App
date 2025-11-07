/// Schedule Header Component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:hvac_ui_kit/src/utils/adaptive_layout.dart' as adaptive;

/// Header for schedule control card
class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        return Row(
          children: [
            Container(
              padding: EdgeInsets.all(
                  adaptive.AdaptiveLayout.spacing(context, base: 8)),
              decoration: BoxDecoration(
                color: HvacColors.success.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  adaptive.AdaptiveLayout.borderRadius(context, base: 8),
                ),
              ),
              child: Icon(
                Icons.schedule,
                color: HvacColors.success,
                size: adaptive.AdaptiveLayout.iconSize(context, base: 20),
              ),
            ),
            SizedBox(width: adaptive.AdaptiveLayout.spacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Расписание',
                    style: HvacTypography.titleLarge.copyWith(
                      fontSize:
                          adaptive.AdaptiveLayout.fontSize(context, base: 16),
                      color: HvacColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'Автоматическое управление',
                    style: HvacTypography.labelLarge.copyWith(
                      fontSize:
                          adaptive.AdaptiveLayout.fontSize(context, base: 12),
                      color: HvacColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
