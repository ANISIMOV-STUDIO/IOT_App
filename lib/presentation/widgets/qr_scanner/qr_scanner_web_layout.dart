/// QR Scanner Web Layout
///
/// Web-specific layout for QR scanner screen
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/theme/spacing.dart';
import 'device_form_widget.dart';
import 'qr_scanner_controller.dart';
import 'qr_scanner_responsive.dart';
import 'web_camera_handler.dart';

class QrScannerWebLayout extends StatelessWidget {
  final QrScannerController controller;
  final Function(String macAddress, String deviceName, String location)
      onAddDevice;
  final Function(String code) onCodeDetected;

  const QrScannerWebLayout({
    super.key,
    required this.controller,
    required this.onAddDevice,
    required this.onCodeDetected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = QrScannerResponsive(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.horizontalPadding),
        child: Container(
          constraints: BoxConstraints(maxWidth: responsive.formMaxWidth),
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: HvacTheme.deviceCard(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.devices_other,
                size: responsive.iconSize,
                color: HvacColors.primaryOrange,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Add HVAC Device',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: responsive.isDesktop ? 28.0 : 24.0,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter device information manually or use camera',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Tab selector for web
              if (responsive.isDesktop) ...[
                _WebTabSelector(
                  controller: controller,
                  theme: theme,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Content based on mode
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.isManualMode
                    ? DeviceFormWidget(
                        key: const ValueKey('manual'),
                        onSubmit: onAddDevice,
                        isWebMode: true,
                      )
                    : SizedBox(
                        key: const ValueKey('camera'),
                        height: 400.0,
                        child: WebCameraHandler(
                          onCodeDetected: onCodeDetected,
                          onUnsupported: () =>
                              controller.setMode(ScannerMode.manual),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebTabSelector extends StatelessWidget {
  final QrScannerController controller;
  final ThemeData theme;

  const _WebTabSelector({
    required this.controller,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: HvacRadius.mdRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Manual Entry',
              icon: Icons.keyboard,
              isSelected: controller.isManualMode,
              onTap: () => controller.setMode(ScannerMode.manual),
              theme: theme,
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Camera Scan',
              icon: Icons.qr_code_scanner,
              isSelected: !controller.isManualMode,
              onTap: () => controller.setMode(ScannerMode.web),
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: HvacRadius.smRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20.0,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}