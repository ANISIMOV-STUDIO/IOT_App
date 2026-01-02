/// Unit Alarms Widget - Активные аварии устройства
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/alarm_info.dart';
import 'breez_card.dart';

/// Виджет отображения активных аварий
class UnitAlarmsWidget extends StatelessWidget {
  final Map<String, AlarmInfo> alarms;
  final VoidCallback? onSeeHistory;
  final ValueChanged<String>? onAlarmTap;

  const UnitAlarmsWidget({
    super.key,
    required this.alarms,
    this.onSeeHistory,
    this.onAlarmTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final alarmsList = alarms.entries.toList();

    return BreezCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                    'Аварии',
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

          // Alarms list
          Expanded(
            child: alarmsList.isEmpty
                ? _EmptyState()
                : Column(
                    children: alarmsList.take(3).toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final alarm = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: index < 2 ? 8 : 0),
                        child: _AlarmCard(
                          alarmKey: alarm.key,
                          alarm: alarm.value,
                          onTap: () => onAlarmTap?.call(alarm.key),
                        ),
                      );
                    }).toList(),
                  ),
          ),

          // History button
          const SizedBox(height: 12),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onSeeHistory,
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.buttonBg,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  border: Border.all(color: colors.border),
                ),
                child: Center(
                  child: Text(
                    alarmsList.isEmpty ? 'История аварий' : 'Все аварии (+${alarmsList.length > 3 ? alarmsList.length - 3 : 0})',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 40,
            color: AppColors.accentGreen.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Нет аварий',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Система работает штатно',
            style: TextStyle(
              fontSize: 11,
              color: colors.textMuted.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Alarm card
class _AlarmCard extends StatefulWidget {
  final String alarmKey;
  final AlarmInfo alarm;
  final VoidCallback? onTap;

  const _AlarmCard({
    required this.alarmKey,
    required this.alarm,
    this.onTap,
  });

  @override
  State<_AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<_AlarmCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.accentRed.withValues(alpha: 0.12)
                : AppColors.accentRed.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentRed.withValues(alpha: 0.4)
                  : AppColors.accentRed.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.accentRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 16,
                  color: AppColors.accentRed,
                ),
              ),

              const SizedBox(width: 10),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Код ${widget.alarm.code}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors.text,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentRed.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'АКТИВНА',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.alarm.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
