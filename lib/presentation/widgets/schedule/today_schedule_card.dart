/// Today's Schedule Card Component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'schedule_time.dart';

/// Today's schedule display card
class TodayScheduleCard extends StatelessWidget {
  final int dayOfWeek;
  final dynamic schedule;

  const TodayScheduleCard({
    super.key,
    required this.dayOfWeek,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return HvacCard(
      size: HvacCardSize.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _getDayName(dayOfWeek, l10n),
                  style: HvacTypography.labelMedium.copyWith(
                    color: HvacColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: HvacSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: HvacSpacing.xs,
                  vertical: HvacSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: schedule?.timerEnabled == true
                      ? HvacColors.success.withValues(alpha: 0.2)
                      : HvacColors.textSecondary.withValues(alpha: 0.2),
                  borderRadius: HvacRadius.xsRadius,
                ),
                child: Text(
                  schedule?.timerEnabled == true ? l10n.enabled : l10n.disabled,
                  style: HvacTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: schedule?.timerEnabled == true
                        ? HvacColors.success
                        : HvacColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.sm),
          Row(
            children: [
              Expanded(
                child: ScheduleTime(
                  label: l10n.turnOn,
                  time: schedule?.turnOnTime,
                  icon: Icons.power_settings_new,
                ),
              ),
              const SizedBox(width: HvacSpacing.md),
              Expanded(
                child: ScheduleTime(
                  label: l10n.turnOff,
                  time: schedule?.turnOffTime,
                  icon: Icons.power_off,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDayName(int dayOfWeek, AppLocalizations l10n) {
    switch (dayOfWeek) {
      case 1:
        return l10n.monday;
      case 2:
        return l10n.tuesday;
      case 3:
        return l10n.wednesday;
      case 4:
        return l10n.thursday;
      case 5:
        return l10n.friday;
      case 6:
        return l10n.saturday;
      case 7:
        return l10n.sunday;
      default:
        return '';
    }
  }
}