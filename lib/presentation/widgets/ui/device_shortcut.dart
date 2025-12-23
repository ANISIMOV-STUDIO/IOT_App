/// Device Shortcut - Circular icon with toggle
/// Used in shortcuts grid for quick device control
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Device shortcut item data
class DeviceShortcutData {
  final String id;
  final String label;
  final IconData icon;
  final bool isOn;
  final bool isOnline;

  const DeviceShortcutData({
    required this.id,
    required this.label,
    required this.icon,
    this.isOn = false,
    this.isOnline = true,
  });

  DeviceShortcutData copyWith({bool? isOn, bool? isOnline}) {
    return DeviceShortcutData(
      id: id,
      label: label,
      icon: icon,
      isOn: isOn ?? this.isOn,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

/// Single device shortcut with icon and toggle
class DeviceShortcut extends StatelessWidget {
  final DeviceShortcutData data;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  const DeviceShortcut({
    super.key,
    required this.data,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = data.isOn && data.isOnline;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surfaceVariant,
              border: Border.all(
                color: isActive ? AppColors.primary : AppColors.textMuted.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              data.icon,
              size: 28,
              color: isActive ? AppColors.primary : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),

          // Label
          Text(
            data.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: data.isOnline ? AppColors.textPrimary : AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Toggle
          _MiniToggle(
            value: data.isOn,
            enabled: data.isOnline,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}

/// Compact toggle switch
class _MiniToggle extends StatelessWidget {
  final bool value;
  final bool enabled;
  final ValueChanged<bool>? onChanged;

  const _MiniToggle({
    required this.value,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'OFF',
            style: TextStyle(
              fontSize: 9,
              fontWeight: value ? FontWeight.w400 : FontWeight.w600,
              color: value ? AppColors.textMuted : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: value && enabled
                  ? AppColors.primary
                  : AppColors.textMuted.withValues(alpha: 0.3),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'ON',
            style: TextStyle(
              fontSize: 9,
              fontWeight: value ? FontWeight.w600 : FontWeight.w400,
              color: value ? AppColors.primary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Add device placeholder
class AddDeviceShortcut extends StatelessWidget {
  final VoidCallback? onTap;

  const AddDeviceShortcut({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: Icon(
              Icons.add,
              size: 28,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Добавить',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24), // Space for toggle area
        ],
      ),
    );
  }
}

/// Grid of device shortcuts
class DeviceShortcutsGrid extends StatelessWidget {
  final List<DeviceShortcutData> devices;
  final ValueChanged<(String, bool)>? onDeviceToggle;
  final ValueChanged<String>? onDeviceTap;
  final VoidCallback? onAddDevice;
  final int crossAxisCount;

  const DeviceShortcutsGrid({
    super.key,
    required this.devices,
    this.onDeviceToggle,
    this.onDeviceTap,
    this.onAddDevice,
    this.crossAxisCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ...devices.map((device) => DeviceShortcut(
              data: device,
              onToggle: onDeviceToggle != null
                  ? (value) => onDeviceToggle!((device.id, value))
                  : null,
              onTap: onDeviceTap != null ? () => onDeviceTap!(device.id) : null,
            )),
        if (onAddDevice != null) AddDeviceShortcut(onTap: onAddDevice),
      ],
    );
  }
}
