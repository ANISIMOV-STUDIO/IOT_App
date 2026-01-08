/// Unit Alarms Widget - Активные аварии устройства
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/alarm_info.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';
import 'breez_list_card.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для UnitAlarmsWidget
abstract class _AlarmWidgetConstants {
  static const double iconSize = 18.0;
  static const double titleFontSize = 16.0;
  static const double badgeFontSize = 11.0;
  static const int maxVisibleAlarms = 3;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Виджет отображения активных аварий
///
/// Поддерживает:
/// - Компактный режим для mobile
/// - Показ до 3 аварий с кнопкой "показать все"
/// - Empty state когда нет аварий
/// - Accessibility через Semantics
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

    return Semantics(
      label: alarmsList.isEmpty
          ? '${l10n.alarms}: нет активных'
          : '${l10n.alarms}: ${alarmsList.length} активных',
      child: BreezCard(
        padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.lg),
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
                        size: _AlarmWidgetConstants.iconSize,
                        color: alarmsList.isEmpty
                            ? AppColors.accentGreen
                            : AppColors.accentRed,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        l10n.alarms,
                        style: TextStyle(
                          fontSize: _AlarmWidgetConstants.titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                        ),
                      ),
                    ],
                  ),
                  if (alarmsList.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      child: Text(
                        '${alarmsList.length}',
                        style: TextStyle(
                          fontSize: _AlarmWidgetConstants.badgeFontSize,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentRed,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
            ],

            // Список аварий
            Expanded(
              child: alarmsList.isEmpty
                  ? BreezEmptyState.noAlarms(l10n, compact: compact)
                  : Column(
                      children: alarmsList
                          .take(_AlarmWidgetConstants.maxVisibleAlarms)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final alarm = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < _AlarmWidgetConstants.maxVisibleAlarms - 1
                                ? (compact ? AppSpacing.xxs : AppSpacing.xs)
                                : 0,
                          ),
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
              SizedBox(height: AppSpacing.sm),
              BreezSeeMoreButton(
                label: alarmsList.isEmpty ? l10n.alarmHistory : l10n.allAlarms,
                extraCount: alarmsList.length > _AlarmWidgetConstants.maxVisibleAlarms
                    ? alarmsList.length - _AlarmWidgetConstants.maxVisibleAlarms
                    : null,
                onTap: onSeeHistory,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
