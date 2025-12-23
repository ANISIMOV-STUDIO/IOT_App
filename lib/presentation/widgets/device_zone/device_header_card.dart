/// Device power control card - compact toggle with status
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../common/glowing_status_dot.dart';

/// Compact power control card - toggle + status only
/// Device name is shown in DeviceSelectorHeader, no need to repeat
class DeviceHeaderCard extends StatelessWidget {
  final String deviceName;
  final String? deviceType;
  final bool isOn;
  final bool isOnline;
  final ValueChanged<bool>? onPowerChanged;

  const DeviceHeaderCard({
    super.key,
    required this.deviceName,
    this.deviceType,
    required this.isOn,
    this.isOnline = true,
    this.onPowerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final statusColor = !isOnline
        ? theme.colorScheme.mutedForeground
        : isOn
            ? AppColors.success
            : AppColors.warning;

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large power button
          GestureDetector(
            onTap: isOnline && onPowerChanged != null
                ? () => onPowerChanged!(!isOn)
                : null,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOn
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : theme.colorScheme.muted.withValues(alpha: 0.3),
                border: Border.all(
                  color: isOn ? AppColors.primary : theme.colorScheme.border,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.power_settings_new,
                size: 28,
                color: isOn ? AppColors.primary : theme.colorScheme.mutedForeground,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Status row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GlowingStatusDot(
                color: statusColor,
                isGlowing: isOn && isOnline,
                size: 8,
              ),
              const SizedBox(width: 6),
              Text(
                _statusLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String get _statusLabel {
    if (!isOnline) return 'Офлайн';
    return isOn ? 'Активно' : 'Ожидание';
  }
}
