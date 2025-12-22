/// Device header card with status and power toggle
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';
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
    final t = NeumorphicTheme.of(context);

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Power icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isOn ? NeumorphicColors.accentPrimary : Colors.grey)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.power_settings_new,
                  color: isOn ? NeumorphicColors.accentPrimary : Colors.grey,
                  size: 20,
                ),
              ),
              // Power toggle
              NeumorphicToggle(
                value: isOn,
                onChanged: isOnline ? onPowerChanged : null,
              ),
            ],
          ),
          const Spacer(),
          // Device name
          Text(deviceName, style: t.typography.titleMedium),
          if (deviceType != null) ...[
            const SizedBox(height: 2),
            Text(
              deviceType!,
              style: t.typography.bodySmall.copyWith(
                color: t.colors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 4),
          // Status indicator
          Row(
            children: [
              GlowingStatusDot(
                color: !isOnline
                    ? t.colors.textTertiary
                    : isOn
                        ? NeumorphicColors.accentSuccess
                        : NeumorphicColors.accentWarning,
                isGlowing: isOn && isOnline,
              ),
              const SizedBox(width: 6),
              Text(
                _statusLabel,
                style: t.typography.labelSmall.copyWith(
                  color: !isOnline
                      ? t.colors.textTertiary
                      : isOn
                          ? NeumorphicColors.accentSuccess
                          : NeumorphicColors.accentWarning,
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
