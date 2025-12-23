/// Device system info card
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../common/glowing_status_dot.dart';

/// Card showing device system information (firmware, connection, metrics)
class DeviceSystemInfoCard extends StatelessWidget {
  final String deviceName;
  final String firmwareVersion;
  final String connectionType;
  final bool isOnline;
  final int efficiencyPercent;
  final int filterStatusPercent;
  final int uptimePercent;

  // Labels
  final String title;
  final String deviceLabel;
  final String firmwareLabel;
  final String connectionLabel;
  final String efficiencyLabel;
  final String filterLabel;
  final String uptimeLabel;

  const DeviceSystemInfoCard({
    super.key,
    required this.deviceName,
    this.firmwareVersion = 'v2.4.1',
    this.connectionType = 'Wi-Fi',
    this.isOnline = true,
    this.efficiencyPercent = 94,
    this.filterStatusPercent = 78,
    this.uptimePercent = 99,
    this.title = 'Состояние системы',
    this.deviceLabel = 'Устройство',
    this.firmwareLabel = 'Прошивка',
    this.connectionLabel = 'Связь',
    this.efficiencyLabel = 'КПД',
    this.filterLabel = 'Фильтр',
    this.uptimeLabel = 'Аптайм',
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.foreground,
                ),
              ),
              Row(
                children: [
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 14,
                      color: isOnline
                          ? AppColors.success
                          : theme.colorScheme.mutedForeground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GlowingStatusDot(
                    color: isOnline
                        ? AppColors.success
                        : theme.colorScheme.mutedForeground,
                    isGlowing: isOnline,
                    size: 10,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Content
          Expanded(
            child: Row(
              children: [
                // Left column - device info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _InfoRow(label: deviceLabel, value: deviceName),
                      _InfoRow(label: firmwareLabel, value: firmwareVersion),
                      _InfoRow(label: connectionLabel, value: connectionType),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Right column - metrics
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _EfficiencyRow(
                        label: efficiencyLabel,
                        percent: efficiencyPercent,
                        color: AppColors.success,
                      ),
                      _EfficiencyRow(
                        label: filterLabel,
                        percent: filterStatusPercent,
                        color: _getFilterColor(filterStatusPercent),
                      ),
                      _EfficiencyRow(
                        label: uptimeLabel,
                        percent: uptimePercent,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getFilterColor(int percent) {
    if (percent >= 80) return AppColors.success;
    if (percent >= 50) return AppColors.airGood;
    if (percent >= 30) return AppColors.warning;
    return AppColors.error;
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.foreground,
          ),
        ),
      ],
    );
  }
}

class _EfficiencyRow extends StatelessWidget {
  final String label;
  final int percent;
  final Color color;

  const _EfficiencyRow({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            Text(
              '$percent%',
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ShadProgress(
          value: percent / 100,
        ),
      ],
    );
  }
}
