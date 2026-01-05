/// Alarm History Screen - История аварий устройства
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/alarm_info.dart';
import '../../bloc/climate/climate_bloc.dart';
import '../../widgets/breez/breez_card.dart';

/// Экран истории аварий
///
/// Загружает историю аварий из ClimateBloc при инициализации.
class AlarmHistoryScreen extends StatefulWidget {
  final String deviceId;
  final String deviceName;

  const AlarmHistoryScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
  });

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.alarmHistoryTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.text,
              ),
            ),
            Text(
              widget.deviceName,
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          // Кнопка обновления
          IconButton(
            icon: Icon(Icons.refresh, color: colors.text),
            onPressed: () {
              context.read<ClimateBloc>().add(
                    ClimateAlarmHistoryRequested(widget.deviceId),
                  );
            },
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

  Widget _buildEmptyState(BreezColors colors, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: colors.textMuted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.alarmHistoryEmpty,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.alarmNoAlarms,
            style: TextStyle(
              fontSize: 13,
              color: colors.textMuted.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(
    List<AlarmHistory> history,
    BreezColors colors,
    AppLocalizations l10n,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final alarm = history[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index < history.length - 1 ? 12 : 0),
          child: _AlarmHistoryCard(alarm: alarm, l10n: l10n),
        );
      },
    );
  }
}

/// Карточка истории аварии
class _AlarmHistoryCard extends StatelessWidget {
  final AlarmHistory alarm;
  final AppLocalizations l10n;

  const _AlarmHistoryCard({required this.alarm, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isCleared = alarm.isCleared;

    return BreezCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCleared
                      ? AppColors.accentGreen.withValues(alpha: 0.15)
                      : AppColors.accentRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Icon(
                  isCleared ? Icons.check_circle_outline : Icons.error_outline,
                  size: 20,
                  color: isCleared ? AppColors.accentGreen : AppColors.accentRed,
                ),
              ),
              const SizedBox(width: 12),
              // Title and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.alarmCodeLabel(alarm.alarmCode),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alarm.description,
                      style: TextStyle(
                        fontSize: 12,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCleared
                      ? AppColors.accentGreen.withValues(alpha: 0.15)
                      : AppColors.accentRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isCleared ? l10n.statusResolved : l10n.statusActive,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isCleared ? AppColors.accentGreen : AppColors.accentRed,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Time info
          Container(
            padding: const EdgeInsets.all(12),
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
                          fontSize: 10,
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDateTime(alarm.occurredAt, l10n),
                        style: TextStyle(
                          fontSize: 12,
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
                    height: 30,
                    color: colors.border,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.alarmClearedAt,
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDateTime(alarm.clearedAt!, l10n),
                          style: TextStyle(
                            fontSize: 12,
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
