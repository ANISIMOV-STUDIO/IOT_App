/// Device system info card
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';
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
    final t = NeumorphicTheme.of(context);

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: t.typography.titleLarge),
              Row(
                children: [
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: t.typography.bodyMedium.copyWith(
                      color: isOnline
                          ? NeumorphicColors.accentSuccess
                          : t.colors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GlowingStatusDot(
                    color: isOnline
                        ? NeumorphicColors.accentSuccess
                        : t.colors.textTertiary,
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
                        color: NeumorphicColors.accentSuccess,
                      ),
                      _EfficiencyRow(
                        label: filterLabel,
                        percent: filterStatusPercent,
                        color: _getFilterColor(filterStatusPercent),
                      ),
                      _EfficiencyRow(
                        label: uptimeLabel,
                        percent: uptimePercent,
                        color: NeumorphicColors.accentPrimary,
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
    if (percent >= 80) return NeumorphicColors.accentSuccess;
    if (percent >= 50) return NeumorphicColors.airQualityGood;
    if (percent >= 30) return NeumorphicColors.accentWarning;
    return NeumorphicColors.accentError;
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final t = NeumorphicTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: t.typography.bodySmall.copyWith(
            color: t.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: t.typography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
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
    final t = NeumorphicTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: t.typography.bodySmall.copyWith(
                color: t.colors.textSecondary,
              ),
            ),
            Text(
              '$percent%',
              style: t.typography.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        LinearProgressIndicator(
          value: percent / 100,
          backgroundColor: t.colors.textTertiary.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation(color),
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }
}
