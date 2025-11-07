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
import 'qr_scanner_responsive.dart';

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
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeviceDetailsDialog(
        initialMacAddress: initialMacAddress,
        initialDeviceName: initialDeviceName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final responsive = QrScannerResponsive(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.borderRadius),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: responsive.isMobile ? 24.0 : 40.0,
        vertical: 24.0,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: responsive.dialogWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(responsive.borderRadius),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.devices,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 28.0,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.addDevice,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 24.0,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 48.0,
                      minHeight: 48.0,
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(responsive.borderRadius),
                ),
                border: const Border(
                  top: BorderSide(
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      minimumSize: const Size(80.0, 40.0),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: HvacTypography.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () {
                      // Submit is handled by the form widget
                      final formWidget = context
                          .findAncestorWidgetOfExactType<DeviceFormWidget>();
                      if (formWidget != null) {
                        // The form handles its own submission
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      minimumSize: const Size(80.0, 40.0),
                    ),
                    child: Text(
                      l10n.add,
                      style: HvacTypography.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
