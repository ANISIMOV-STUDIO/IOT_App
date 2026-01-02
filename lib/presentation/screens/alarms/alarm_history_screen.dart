/// Alarm History Screen - История аварий устройства
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/alarm_info.dart';
import '../../widgets/breez/breez_card.dart';

/// Экран истории аварий
class AlarmHistoryScreen extends StatelessWidget {
  final String deviceId;
  final String deviceName;
  final List<AlarmHistory> history;
  final bool isLoading;

  const AlarmHistoryScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
    this.history = const [],
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

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
              'История аварий',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.text,
              ),
            ),
            Text(
              deviceName,
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
              ? _buildEmptyState(colors)
              : _buildHistoryList(colors),
    );
  }

  Widget _buildEmptyState(BreezColors colors) {
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
            'История аварий пуста',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Аварий не зафиксировано',
            style: TextStyle(
              fontSize: 13,
              color: colors.textMuted.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BreezColors colors) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final alarm = history[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index < history.length - 1 ? 12 : 0),
          child: _AlarmHistoryCard(alarm: alarm),
        );
      },
    );
  }
}

/// Карточка истории аварии
class _AlarmHistoryCard extends StatelessWidget {
  final AlarmHistory alarm;

  const _AlarmHistoryCard({required this.alarm});

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
                      'Код ${alarm.alarmCode}',
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
                  isCleared ? 'РЕШЕНА' : 'АКТИВНА',
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
                        'Возникла',
                        style: TextStyle(
                          fontSize: 10,
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDateTime(alarm.occurredAt),
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
                          'Устранена',
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDateTime(alarm.clearedAt!),
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

  String _formatDateTime(DateTime dt) {
    final months = ['янв', 'фев', 'мар', 'апр', 'май', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
