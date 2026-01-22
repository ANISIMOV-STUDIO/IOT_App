/// Unit Alarms Widget - Активные аварии устройства
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_list_card.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для UnitAlarmsWidget
abstract class _AlarmWidgetConstants {
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

  const UnitAlarmsWidget({
    required this.alarms,
    super.key,
    this.onSeeHistory,
    this.onAlarmTap,
    this.onResetAlarms,
    this.compact = false,
    this.showCard = true,
  });
  final Map<String, AlarmInfo> alarms;
  final VoidCallback? onSeeHistory;
  final ValueChanged<String>? onAlarmTap;
  final VoidCallback? onResetAlarms;
  final bool compact;
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final alarmsList = alarms.entries.toList();

    final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок (скрыт в компактном режиме)
            if (!compact) ...[
              BreezSectionHeader.alarms(
                title: l10n.alarms,
                count: alarmsList.length,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            // Список аварий
            Expanded(
              child: alarmsList.isEmpty
                  ? BreezEmptyState.noAlarms(l10n, compact: compact)
                  : Column(
                      children: [
                        ...alarmsList
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
                        }),
                        // Кнопка сброса в компактном режиме (внизу, на всю ширину)
                        if (compact && onResetAlarms != null) ...[
                          const Spacer(),
                          BreezResetButton(
                            label: l10n.alarmReset,
                            onTap: onResetAlarms,
                          ),
                        ],
                      ],
                    ),
            ),

            // Кнопка сброса внизу (скрыта в компактном режиме)
            if (!compact && alarmsList.isNotEmpty && onResetAlarms != null) ...[
              const SizedBox(height: AppSpacing.sm),
              BreezResetButton(
                label: l10n.alarmReset,
                onTap: onResetAlarms,
              ),
            ],
          ],
    );

    final wrappedContent = showCard
        ? BreezCard(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: content,
          )
        : content;

    return Semantics(
      label: alarmsList.isEmpty
          ? '${l10n.alarms}: нет активных'
          : '${l10n.alarms}: ${alarmsList.length} активных',
      child: wrappedContent,
    );
  }
}
