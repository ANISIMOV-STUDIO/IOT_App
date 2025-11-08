/// Device Details Dialog
///
/// Modal dialog for entering/confirming device details after QR scan
/// Responsive design for all screen sizes
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'device_form_widget.dart';

class DeviceDetailsDialog extends StatelessWidget {
  final String? initialMacAddress;
  final String? initialDeviceName;
  final Function(String macAddress, String deviceName, String location)
      onConfirm;

  const DeviceDetailsDialog({
    super.key,
    this.initialMacAddress,
    this.initialDeviceName,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    String? initialMacAddress,
    String? initialDeviceName,
    required Function(String macAddress, String deviceName, String location)
        onConfirm,
  }) {
    return HvacAlertDialog.show(
      context,
      title: AppLocalizations.of(context)!.addDevice,
      dismissible: false,
      contentWidget: DeviceDetailsDialog(
        initialMacAddress: initialMacAddress,
        initialDeviceName: initialDeviceName,
        onConfirm: onConfirm,
      ),
      actions: [], // Actions are in the custom content
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Info message
        if (initialMacAddress != null) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: theme.colorScheme.primary
                    .withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.qr_code_2,
                  color: theme.colorScheme.primary,
                  size: 20.0,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Device detected from QR code',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Form
        DeviceFormWidget(
          initialMacAddress: initialMacAddress,
          initialDeviceName: initialDeviceName,
          onSubmit: (mac, name, location) {
            Navigator.of(context).pop();
            onConfirm(mac, name, location);
          },
          isWebMode: false,
        ),
      ],
    );
  }
}
