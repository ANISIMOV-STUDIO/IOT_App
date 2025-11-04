/// QR Scanner Mobile Layout
///
/// Mobile and tablet layout for QR scanner screen
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../widgets/gradient_button.dart';
import 'device_form_widget.dart';
import 'qr_scanner_camera.dart';
import 'qr_scanner_controller.dart';
import 'qr_scanner_responsive.dart';

class QrScannerMobileLayout extends StatelessWidget {
  final QrScannerController controller;
  final AppLocalizations l10n;
  final Function(String macAddress, String deviceName, String location)
      onAddDevice;
  final Function(String code) onCodeDetected;

  const QrScannerMobileLayout({
    super.key,
    required this.controller,
    required this.l10n,
    required this.onAddDevice,
    required this.onCodeDetected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = QrScannerResponsive(context);

    return Column(
      children: [
        // Camera or form section
        Expanded(
          flex: responsive.cameraFlexRatio,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.isManualMode
                ? _ManualEntrySection(
                    key: const ValueKey('manual'),
                    onAddDevice: onAddDevice,
                    theme: theme,
                    responsive: responsive,
                  )
                : QrScannerCamera(
                    key: const ValueKey('camera'),
                    onCodeDetected: onCodeDetected,
                  ),
          ),
        ),

        // Toggle section
        _ToggleSection(
          controller: controller,
          l10n: l10n,
          theme: theme,
          responsive: responsive,
        ),
      ],
    );
  }
}

class _ManualEntrySection extends StatelessWidget {
  final Function(String macAddress, String deviceName, String location)
      onAddDevice;
  final ThemeData theme;
  final QrScannerResponsive responsive;

  const _ManualEntrySection({
    super.key,
    required this.onAddDevice,
    required this.theme,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsive.horizontalPadding),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: responsive.formMaxWidth,
            ),
            padding: EdgeInsets.all(AppSpacing.lgR),
            decoration: HvacTheme.deviceCard(),
            child: DeviceFormWidget(
              onSubmit: onAddDevice,
              isWebMode: false,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleSection extends StatelessWidget {
  final QrScannerController controller;
  final AppLocalizations l10n;
  final ThemeData theme;
  final QrScannerResponsive responsive;

  const _ToggleSection({
    required this.controller,
    required this.l10n,
    required this.theme,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lgR),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(responsive.borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            controller.isManualMode
                ? l10n.scanQrCode
                : l10n.enterMacManually,
            style: HvacTypography.bodyLarge,
          ),
          SizedBox(height: AppSpacing.mdR),
          GradientButton(
            onPressed: () => controller.toggleMode(),
            text:
                controller.isManualMode ? l10n.scanQrCode : 'Enter Manually',
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}