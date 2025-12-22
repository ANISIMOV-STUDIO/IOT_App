/// Device Selector Header - informative device switcher as zone header
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';
import '../common/glowing_status_dot.dart';

/// Device info model for the selector
class DeviceSelectorItem {
  final String id;
  final String name;
  final String brand;
  final String type;
  final bool isOnline;
  final bool isActive;
  final IconData icon;

  const DeviceSelectorItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.isOnline,
    this.isActive = false,
    this.icon = Icons.air,
  });
}

/// Header card for Device Zone with device selector
class DeviceSelectorHeader extends StatelessWidget {
  final List<DeviceSelectorItem> devices;
  final String? selectedDeviceId;
  final ValueChanged<String>? onDeviceSelected;
  final VoidCallback? onAddDevice;
  final VoidCallback? onManageDevices;

  const DeviceSelectorHeader({
    super.key,
    required this.devices,
    this.selectedDeviceId,
    this.onDeviceSelected,
    this.onAddDevice,
    this.onManageDevices,
  });

  DeviceSelectorItem? get _selectedDevice {
    if (devices.isEmpty) return null;
    return devices.firstWhere(
      (d) => d.id == selectedDeviceId,
      orElse: () => devices.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = GlassTheme.of(context);
    final selected = _selectedDevice;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GlassSpacing.md,
        vertical: GlassSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: GlassColors.accentPrimary.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          // Device icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GlassColors.accentPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              selected?.icon ?? Icons.device_hub,
              color: GlassColors.accentPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Device name and type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        selected?.name ?? 'Устройство',
                        style: t.typography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GlowingStatusDot(
                      color: selected?.isOnline == true
                          ? GlassColors.accentSuccess
                          : t.colors.textTertiary,
                      isGlowing: selected?.isOnline == true,
                      size: 6,
                    ),
                  ],
                ),
                Text(
                  '${selected?.brand ?? ''} • ${selected?.type ?? ''}',
                  style: t.typography.labelSmall.copyWith(
                    color: t.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Device tabs inline
          Expanded(
            flex: 2,
            child: _DeviceTabs(
              devices: devices,
              selectedDeviceId: selectedDeviceId,
              onDeviceSelected: onDeviceSelected,
              onAddDevice: onAddDevice,
            ),
          ),

          // Manage button
          if (onManageDevices != null) ...[
            const SizedBox(width: 8),
            GlassIconButton(
              icon: Icons.settings,
              size: 32,
              iconColor: t.colors.textTertiary,
              onPressed: onManageDevices,
            ),
          ],
        ],
      ),
    );
  }
}

class _DeviceTabs extends StatelessWidget {
  final List<DeviceSelectorItem> devices;
  final String? selectedDeviceId;
  final ValueChanged<String>? onDeviceSelected;
  final VoidCallback? onAddDevice;

  const _DeviceTabs({
    required this.devices,
    this.selectedDeviceId,
    this.onDeviceSelected,
    this.onAddDevice,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Device tabs
          ...devices.asMap().entries.map((entry) {
            final index = entry.key;
            final device = entry.value;
            final isSelected = device.id == selectedDeviceId;

            return Padding(
              padding: EdgeInsets.only(right: index < devices.length - 1 ? 8 : 0),
              child: _DeviceTab(
                device: device,
                index: index + 1,
                isSelected: isSelected,
                onTap: () => onDeviceSelected?.call(device.id),
              ),
            );
          }),

          // Add button
          if (onAddDevice != null) ...[
            const SizedBox(width: 8),
            _AddDeviceTab(onTap: onAddDevice),
          ],
        ],
      ),
    );
  }
}

class _DeviceTab extends StatelessWidget {
  final DeviceSelectorItem device;
  final int index;
  final bool isSelected;
  final VoidCallback? onTap;

  const _DeviceTab({
    required this.device,
    required this.index,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? GlassColors.accentPrimary
              : t.colors.cardSurface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? null : t.shadows.convexSmall,
          border: isSelected
              ? null
              : Border.all(
                  color: t.colors.textTertiary.withValues(alpha: 0.1),
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status dot
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white.withValues(alpha: 0.9) : statusColor,
              ),
            ),
            const SizedBox(width: 6),

            // Device label
            Text(
              'ПВ-$index',
              style: t.typography.labelSmall.copyWith(
                color: isSelected ? Colors.white : t.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Offline indicator
            if (!device.isOnline) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.cloud_off,
                size: 12,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.7)
                    : t.colors.textTertiary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddDeviceTab extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddDeviceTab({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: GlassColors.accentPrimary.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(
          Icons.add,
          size: 16,
          color: GlassColors.accentPrimary,
        ),
      ),
    );
  }
}
