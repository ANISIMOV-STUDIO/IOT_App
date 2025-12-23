/// Device switcher card
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../common/glowing_status_dot.dart';

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
    return ShadButton.ghost(
      onPressed: onTap,
      size: ShadButtonSize.sm,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 18, color: AppColors.primary),
          SizedBox(width: 4),
          Text(
            'Добавить',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
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
    final theme = ShadTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : theme.colorScheme.muted.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : theme.colorScheme.border,
          ),
        ),
        child: Row(
          children: [
            // Device icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : theme.colorScheme.muted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                device.icon,
                size: 20,
                color: isSelected
                    ? AppColors.primary
                    : theme.colorScheme.mutedForeground,
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : theme.colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    device.type,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.mutedForeground,
                    ),
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
    final theme = ShadTheme.of(context);
    final color = !isOnline
        ? theme.colorScheme.mutedForeground
        : isActive
            ? AppColors.success
            : AppColors.warning;
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
          GlowingStatusDot(color: color, size: 6),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
            ),
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
    final theme = ShadTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_other,
            size: 48,
            color: theme.colorScheme.mutedForeground,
          ),
          const SizedBox(height: 12),
          Text(
            'Нет устройств',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Добавьте первое устройство',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.mutedForeground.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          ShadButton.outline(
            onPressed: onAddDevice,
            size: ShadButtonSize.sm,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 16),
                SizedBox(width: 4),
                Text('Добавить'),
              ],
            ),
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
                'Устройства',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.foreground,
                ),
              ),
              ShadButton.ghost(
                onPressed: onAddDevice,
                size: ShadButtonSize.sm,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 14, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Добавить',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
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
    final theme = ShadTheme.of(context);
    final statusColor = !device.isOnline
        ? theme.colorScheme.mutedForeground
        : device.isActive
            ? AppColors.success
            : AppColors.warning;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Icon container
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.muted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : theme.colorScheme.border,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    device.icon,
                    size: 24,
                    color: isSelected
                        ? AppColors.primary
                        : theme.colorScheme.mutedForeground,
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
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : theme.colorScheme.mutedForeground,
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
