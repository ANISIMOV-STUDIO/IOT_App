/// Schedule Stats Components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Quick stats row
class ScheduleQuickStats extends StatelessWidget {
  final bool isPowerOn;
  final int? fanSpeed;

  const ScheduleQuickStats({
    super.key,
    required this.isPowerOn,
    this.fanSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        return Row(
          children: [
            Expanded(
              child: ScheduleStat(
                label: 'Статус',
                value: isPowerOn ? 'Работает' : 'Выключено',
                color: isPowerOn ? HvacColors.success : HvacColors.error,
              ),
            ),
            SizedBox(width: AdaptiveLayout.spacing(context)),
            Expanded(
              child: ScheduleStat(
                label: 'Время работы',
                value: (fanSpeed ?? 0) > 0 ? '2ч 15м' : '0м',
                color: HvacColors.info,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Single stat display
class ScheduleStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const ScheduleStat({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        return Container(
          padding:
              EdgeInsets.all(AdaptiveLayout.spacing(context, base: 8)),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: HvacTypography.labelSmall.copyWith(
                  fontSize: AdaptiveLayout.fontSize(context, base: 10),
                  color: HvacColors.textSecondary,
                ),
              ),
              SizedBox(
                  height: AdaptiveLayout.spacing(context, base: 4)),
              Text(
                value,
                style: HvacTypography.labelLarge.copyWith(
                  fontSize: AdaptiveLayout.fontSize(context, base: 12),
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
