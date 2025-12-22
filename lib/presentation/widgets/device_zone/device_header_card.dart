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
    final t = GlassTheme.of(context);

    return GlassCard(
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
                      color: (isOn ? GlassColors.accentPrimary : Colors.grey)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.power_settings_new,
                      color: isOn ? GlassColors.accentPrimary : Colors.grey,
                      size: isSmall ? 16 : 20,
                    ),
                  ),
                  // Power toggle
                  GlassToggle(
                    value: isOn,
                    onChanged: isOnline ? onPowerChanged : null,
                  ),
                ],
              ),
              const Spacer(),
              // Device name
              Text(
                deviceName,
                style: isSmall ? t.typography.titleSmall : t.typography.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
              if (deviceType != null && !isSmall) ...[
                const SizedBox(height: 2),
                Text(
                  deviceType!,
                  style: t.typography.labelSmall.copyWith(
                    color: t.colors.textSecondary,
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
                        ? t.colors.textTertiary
                        : isOn
                            ? GlassColors.accentSuccess
                            : GlassColors.accentWarning,
                    isGlowing: isOn && isOnline,
                    size: isSmall ? 6 : 8,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _statusLabel,
                    style: t.typography.labelSmall.copyWith(
                      color: !isOnline
                          ? t.colors.textTertiary
                          : isOn
                              ? GlassColors.accentSuccess
                              : GlassColors.accentWarning,
                      fontSize: isSmall ? 10 : null,
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
