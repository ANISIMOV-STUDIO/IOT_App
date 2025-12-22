import 'package:smart_ui_kit/smart_ui_kit.dart';

/// Device model for the switcher
class DeviceInfo {
  final String id;
  final String name;
  final String type;
  final bool isOnline;
  final bool isActive;
  final IconData icon;

  const DeviceInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.isOnline,
    this.isActive = false,
    this.icon = Icons.device_hub,
  });
}

/// Device switcher card - shows connected devices with ability to add more
class DeviceSwitcherCard extends StatelessWidget {
  final List<DeviceInfo> devices;
  final String? selectedDeviceId;
  final ValueChanged<String>? onDeviceSelected;
  final VoidCallback? onAddDevice;
  final String title;

  const DeviceSwitcherCard({
    super.key,
    required this.devices,
    this.selectedDeviceId,
    this.onDeviceSelected,
    this.onAddDevice,
    this.title = 'Устройства',
  });

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Add device button
              _AddDeviceButton(onTap: onAddDevice),
            ],
          ),
          const SizedBox(height: 16),

          // Device list
          Expanded(
            child: devices.isEmpty
                ? _EmptyState(onAddDevice: onAddDevice)
                : ListView.separated(
                    itemCount: devices.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      final isSelected = device.id == selectedDeviceId;
                      return _DeviceListItem(
                        device: device,
                        isSelected: isSelected,
                        onTap: () => onDeviceSelected?.call(device.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AddDeviceButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddDeviceButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassInteractiveCard(
      onTap: onTap,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add,
            size: 18,
            color: GlassColors.accentPrimary,
          ),
          const SizedBox(width: 4),
          Text(
            'Добавить',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: GlassColors.accentPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceListItem extends StatelessWidget {
  final DeviceInfo device;
  final bool isSelected;
  final VoidCallback? onTap;

  const _DeviceListItem({
    required this.device,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlassTheme.of(context);

    return GlassCard(
      onTap: onTap,
      borderRadius: 12,
      variant: isSelected ? GlassCardVariant.concave : GlassCardVariant.convex,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Device icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? GlassColors.accentPrimary.withValues(alpha: 0.2)
                  : t.colors.glassSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              device.icon,
              size: 20,
              color: isSelected
                  ? GlassColors.accentPrimary
                  : t.colors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),

          // Device info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: t.typography.titleSmall.copyWith(
                    color: isSelected
                        ? GlassColors.accentPrimary
                        : t.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  device.type,
                  style: t.typography.bodySmall,
                ),
              ],
            ),
          ),

          // Status indicator
          _StatusIndicator(
            isOnline: device.isOnline,
            isActive: device.isActive,
          ),
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final bool isOnline;
  final bool isActive;

  const _StatusIndicator({
    required this.isOnline,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlassTheme.of(context);
    final color = !isOnline
        ? t.colors.textTertiary
        : isActive
            ? GlassColors.accentSuccess
            : GlassColors.accentWarning;
    final label = !isOnline
        ? 'Офлайн'
        : isActive
            ? 'Активно'
            : 'Ожидание';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glowing status dot
          _GlowingDot(color: color, size: 6),
          const SizedBox(width: 4),
          Text(
            label,
            style: t.typography.labelSmall.copyWith(
              color: color,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Status dot with glow effect
class _GlowingDot extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowingDot({
    required this.color,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.6),
            blurRadius: size,
            spreadRadius: size * 0.3,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback? onAddDevice;

  const _EmptyState({this.onAddDevice});

  @override
  Widget build(BuildContext context) {
    final t = GlassTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_other,
            size: 48,
            color: t.colors.textTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            'Нет устройств',
            style: t.typography.titleSmall.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Добавьте первое устройство',
            style: t.typography.bodySmall.copyWith(
              color: t.colors.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          GlassButton(
            onPressed: onAddDevice,
            size: GlassButtonSize.small,
            icon: Icons.add,
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}

/// Horizontal minimalist device switcher with icons
class DeviceSwitcherHorizontal extends StatelessWidget {
  final List<DeviceInfo> devices;
  final String? selectedDeviceId;
  final ValueChanged<String>? onDeviceSelected;
  final VoidCallback? onAddDevice;

  const DeviceSwitcherHorizontal({
    super.key,
    required this.devices,
    this.selectedDeviceId,
    this.onDeviceSelected,
    this.onAddDevice,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlassTheme.of(context);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Устройства', style: t.typography.titleMedium),
              GlassInteractiveCard(
                onTap: onAddDevice,
                borderRadius: 10,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 14, color: GlassColors.accentPrimary),
                    const SizedBox(width: 4),
                    Text(
                      'Добавить',
                      style: t.typography.labelSmall.copyWith(
                        color: GlassColors.accentPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal device icons
          Row(
            children: [
              ...devices.map((device) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _DeviceIconButton(
                  device: device,
                  isSelected: device.id == selectedDeviceId,
                  onTap: () => onDeviceSelected?.call(device.id),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeviceIconButton extends StatelessWidget {
  final DeviceInfo device;
  final bool isSelected;
  final VoidCallback? onTap;

  const _DeviceIconButton({
    required this.device,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlassTheme.of(context);
    final statusColor = !device.isOnline
        ? t.colors.textTertiary
        : device.isActive
            ? GlassColors.accentSuccess
            : GlassColors.accentWarning;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Glass icon container
          GlassCard(
            width: 56,
            height: 56,
            padding: EdgeInsets.zero,
            variant: isSelected
                ? GlassCardVariant.concave
                : GlassCardVariant.convex,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    device.icon,
                    size: 24,
                    color: isSelected
                        ? GlassColors.accentPrimary
                        : t.colors.textSecondary,
                  ),
                ),
                // Status dot
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Device name
          SizedBox(
            width: 60,
            child: Text(
              device.name.split(' ').first,
              style: t.typography.labelSmall.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? GlassColors.accentPrimary
                    : t.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
