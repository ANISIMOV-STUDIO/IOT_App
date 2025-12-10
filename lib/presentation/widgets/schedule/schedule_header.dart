/// Schedule Header Component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Header for schedule control card
class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(HvacSpacing.xs),
          decoration: BoxDecoration(
            color: HvacColors.success.withValues(alpha: 0.2),
            borderRadius: HvacRadius.smRadius,
          ),
          child: const Icon(
            Icons.schedule,
            color: HvacColors.success,
            size: 20,
          ),
        ),
        const SizedBox(width: HvacSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.schedule,
                style: HvacTypography.titleMedium.copyWith(
                  color: HvacColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: HvacSpacing.xxs),
              Text(
                l10n.automaticControl,
                style: HvacTypography.labelSmall.copyWith(
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
  }
}