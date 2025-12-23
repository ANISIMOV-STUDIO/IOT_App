/// Device header card with status and power toggle
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../common/glowing_status_dot.dart';

/// Header card showing device name, status, and power control
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

    return ShadCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxHeight < 120;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Power icon
                  Container(
                    padding: EdgeInsets.all(isSmall ? 6 : 8),
                    decoration: BoxDecoration(
                      color: (isOn ? AppColors.primary : Colors.grey)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.power_settings_new,
                      color: isOn ? AppColors.primary : Colors.grey,
                      size: isSmall ? 16 : 20,
                    ),
                  ),
                  // Power toggle
                  ShadSwitch(
                    value: isOn,
                    onChanged: isOnline ? onPowerChanged : null,
                  ),
                ],
              ),
              const Spacer(),
              // Device name
              Text(
                deviceName,
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.foreground,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (deviceType != null && !isSmall) ...[
                const SizedBox(height: 2),
                Text(
                  deviceType!,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.mutedForeground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: isSmall ? 2 : 4),
              // Status indicator
              Row(
                children: [
                  GlowingStatusDot(
                    color: !isOnline
                        ? theme.colorScheme.mutedForeground
                        : isOn
                            ? AppColors.success
                            : AppColors.warning,
                    isGlowing: isOn && isOnline,
                    size: isSmall ? 6 : 8,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: isSmall ? 10 : 12,
                      color: !isOnline
                          ? theme.colorScheme.mutedForeground
                          : isOn
                              ? AppColors.success
                              : AppColors.warning,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String get _statusLabel {
    if (!isOnline) return 'Офлайн';
    return isOn ? 'Активно' : 'Ожидание';
  }
}
