/// Schedule Stats Components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: ScheduleStat(
            label: l10n.status,
            value: isPowerOn ? l10n.running : l10n.stopped,
            color: isPowerOn ? HvacColors.success : HvacColors.error,
          ),
        ),
        const SizedBox(width: HvacSpacing.md),
        Expanded(
          child: ScheduleStat(
            label: l10n.operatingTime,
            value: (fanSpeed ?? 0) > 0 ? '2ч 15м' : '0м',
            color: HvacColors.info,
          ),
        ),
      ],
    );
  }
}

/// Single stat display using HvacStatCard
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
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: HvacRadius.smRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: HvacTypography.labelSmall.copyWith(
              color: HvacColors.textSecondary,
            ),
          ),
          const SizedBox(height: HvacSpacing.xxs),
          Text(
            value,
            style: HvacTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}