/// Alarm History Screen - История аварий устройства
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _AlarmHistoryConstants {
  static const double headerFontSize = 18;
  static const double subtitleFontSize = 12;
  static const double emptyIconSize = 64;
  static const double bodyFontSize = 16;
  static const double captionFontSize = 13;
  static const double smallFontSize = 14;
  static const double tinyFontSize = 10;
  static const double valueFontSize = 12;
  static const double iconSize = 20;
  static const double iconContainerSize = 40;
  static const double dividerHeight = 30;
  static const double textGap = 2;
}

/// Экран истории аварий
///
/// Загружает историю аварий из ClimateBloc при инициализации.
class AlarmHistoryScreen extends StatefulWidget {
  const AlarmHistoryScreen({
    required this.deviceId,
    required this.deviceName,
    super.key,
  });

  final String deviceId;
  final String deviceName;

  @override
  State<AlarmHistoryScreen> createState() => _AlarmHistoryScreenState();
}

class _AlarmHistoryScreenState extends State<AlarmHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Запрос на загрузку истории аварий
    context.read<ClimateBloc>().add(
      ClimateAlarmHistoryRequested(widget.deviceId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BreezIconButton(
          icon: Icons.arrow_back,
          iconColor: colors.text,
          backgroundColor: Colors.transparent,
          showBorder: false,
          compact: true,
          onTap: () => Navigator.of(context).pop(),
          semanticLabel: 'Back',
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.alarmHistoryTitle,
              style: TextStyle(
                fontSize: _AlarmHistoryConstants.headerFontSize,
                fontWeight: FontWeight.w700,
                color: colors.text,
              ),
            ),
            Text(
              widget.deviceName,
              style: TextStyle(
                fontSize: _AlarmHistoryConstants.subtitleFontSize,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          // Кнопка обновления
          BreezIconButton(
            icon: Icons.refresh,
            iconColor: colors.text,
            backgroundColor: Colors.transparent,
            showBorder: false,
            compact: true,
            onTap: () {
              context.read<ClimateBloc>().add(
                ClimateAlarmHistoryRequested(widget.deviceId),
              );
            },
            semanticLabel: 'Refresh',
            tooltip: 'Обновить историю',
          ),
        ],
      ),
      body: BlocBuilder<ClimateBloc, ClimateControlState>(
        buildWhen: (prev, curr) => prev.alarmHistory != curr.alarmHistory,
        builder: (context, state) {
          final history = state.alarmHistory;

          if (history.isEmpty) {
            return _buildEmptyState(colors, l10n);
          }

          return _buildHistoryList(history, colors, l10n);
        },
      ),
    );
  }

  Widget _buildEmptyState(BreezColors colors, AppLocalizations l10n) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: _AlarmHistoryConstants.emptyIconSize,
            color: colors.textMuted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.alarmHistoryEmpty,
            style: TextStyle(
              fontSize: _AlarmHistoryConstants.bodyFontSize,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.alarmNoAlarms,
            style: TextStyle(
              fontSize: _AlarmHistoryConstants.captionFontSize,
              color: colors.textMuted.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );

  Widget _buildHistoryList(
    List<AlarmHistory> history,
    BreezColors colors,
    AppLocalizations l10n,
  ) => ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final alarm = history[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < history.length - 1 ? AppSpacing.sm : 0,
          ),
          child: _AlarmHistoryCard(alarm: alarm, l10n: l10n),
        );
      },
    );
}

/// Карточка истории аварии
class _AlarmHistoryCard extends StatelessWidget {
  const _AlarmHistoryCard({required this.alarm, required this.l10n});

  final AlarmHistory alarm;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isCleared = alarm.isCleared;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Icon
              Container(
                width: _AlarmHistoryConstants.iconContainerSize,
                height: _AlarmHistoryConstants.iconContainerSize,
                decoration: BoxDecoration(
                  color: isCleared
                      ? AppColors.accentGreen.withValues(alpha: 0.15)
                      : AppColors.accentRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Icon(
                  isCleared ? Icons.check_circle_outline : Icons.error_outline,
                  size: _AlarmHistoryConstants.iconSize,
                  color: isCleared
                      ? AppColors.accentGreen
                      : AppColors.accentRed,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Title and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.alarmCodeLabel(alarm.alarmCode),
                      style: TextStyle(
                        fontSize: _AlarmHistoryConstants.smallFontSize,
                        fontWeight: FontWeight.w600,
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: _AlarmHistoryConstants.textGap),
                    Text(
                      alarm.description,
                      style: TextStyle(
                        fontSize: _AlarmHistoryConstants.valueFontSize,
                        color: colors.textMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: isCleared
                      ? AppColors.accentGreen.withValues(alpha: 0.15)
                      : AppColors.accentRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.indicator),
                ),
                child: Text(
                  isCleared ? l10n.statusResolved : l10n.statusActive,
                  style: TextStyle(
                    fontSize: _AlarmHistoryConstants.tinyFontSize,
                    fontWeight: FontWeight.w700,
                    color: isCleared
                        ? AppColors.accentGreen
                        : AppColors.accentRed,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Time info
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.cardLight,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Row(
              children: [
                // Occurred time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.alarmOccurredAt,
                        style: TextStyle(
                          fontSize: _AlarmHistoryConstants.tinyFontSize,
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: _AlarmHistoryConstants.textGap),
                      Text(
                        _formatDateTime(alarm.occurredAt, l10n),
                        style: TextStyle(
                          fontSize: _AlarmHistoryConstants.valueFontSize,
                          fontWeight: FontWeight.w600,
                          color: colors.text,
                        ),
                      ),
                    ],
                  ),
                ),
                // Cleared time (if cleared)
                if (isCleared && alarm.clearedAt != null) ...[
                  Container(
                    width: 1,
                    height: _AlarmHistoryConstants.dividerHeight,
                    color: colors.border,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.alarmClearedAt,
                          style: TextStyle(
                            fontSize: _AlarmHistoryConstants.tinyFontSize,
                            color: colors.textMuted,
                          ),
                        ),
                        const SizedBox(height: _AlarmHistoryConstants.textGap),
                        Text(
                          _formatDateTime(alarm.clearedAt!, l10n),
                          style: const TextStyle(
                            fontSize: _AlarmHistoryConstants.valueFontSize,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt, AppLocalizations l10n) {
    final months = [
      l10n.janShort,
      l10n.febShort,
      l10n.marShort,
      l10n.aprShort,
      l10n.mayShort,
      l10n.junShort,
      l10n.julShort,
      l10n.augShort,
      l10n.sepShort,
      l10n.octShort,
      l10n.novShort,
      l10n.decShort,
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
