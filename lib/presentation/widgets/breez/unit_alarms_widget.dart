/// Unit Alarms Widget - Активные аварии устройства
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/alarm_info.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';
import 'breez_list_card.dart';

/// Виджет отображения активных аварий
class UnitAlarmsWidget extends StatelessWidget {
  final Map<String, AlarmInfo> alarms;
  final VoidCallback? onSeeHistory;
  final ValueChanged<String>? onAlarmTap;
  final bool compact;

  const UnitAlarmsWidget({
    super.key,
    required this.alarms,
    this.onSeeHistory,
    this.onAlarmTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final alarmsList = alarms.entries.toList();

    return BreezCard(
      padding: EdgeInsets.all(compact ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок (скрыт в компактном режиме)
          if (!compact) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      alarmsList.isEmpty
                          ? Icons.check_circle_outline
                          : Icons.warning_amber_rounded,
                      size: 18,
                      color: alarmsList.isEmpty
                          ? AppColors.accentGreen
                          : AppColors.accentRed,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.alarms,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                  ],
                ),
                if (alarmsList.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                    child: Text(
                      '${alarmsList.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentRed,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Список аварий
          Expanded(
            child: alarmsList.isEmpty
                ? BreezEmptyState.noAlarms(l10n, compact: compact)
                : Column(
                    children: alarmsList.take(3).toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final alarm = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: index < 2 ? (compact ? 4 : 8) : 0),
                        child: BreezListCard.alarm(
                          code: alarm.value.code.toString(),
                          description: alarm.value.description,
                          l10n: l10n,
                          onTap: () => onAlarmTap?.call(alarm.key),
                          compact: compact,
                        ),
                      );
                    }).toList(),
                  ),
          ),

          // Кнопка истории (скрыта в компактном режиме)
          if (!compact) ...[
            const SizedBox(height: 12),
            BreezSeeMoreButton(
              label: alarmsList.isEmpty ? l10n.alarmHistory : l10n.allAlarms,
              extraCount: alarmsList.length > 3 ? alarmsList.length - 3 : null,
              onTap: onSeeHistory,
            ),
          ],
        ],
      ),
    );
  }
}
