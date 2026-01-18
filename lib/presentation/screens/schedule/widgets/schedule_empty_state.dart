/// Schedule Empty State - No schedule entries widget
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../widgets/breez/breez_button.dart';

/// Пустое состояние - нет записей расписания
class ScheduleEmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const ScheduleEmptyState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: AppColors.accent.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.emptyNoScheduleTitle,
            style: TextStyle(
              fontSize: AppFontSizes.h3,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.emptyNoScheduleMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: AppFontSizes.body, color: colors.textMuted),
          ),
          const SizedBox(height: AppSpacing.lgx),
          BreezButton(
            onTap: onAdd,
            backgroundColor: AppColors.accent,
            hoverColor: AppColors.accentLight,
            borderRadius: AppRadius.button,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            enableGlow: true,
            semanticLabel: l10n.scheduleAdd,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: AppColors.white),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.scheduleAdd,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
