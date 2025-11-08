/// QR Code Scanner Screen
///
/// Main screen for QR code scanning with responsive design
/// Supports mobile camera, web camera API, and manual entry
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../core/theme/spacing.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../widgets/qr_scanner/device_details_dialog.dart';
import '../widgets/qr_scanner/qr_scanner_controller.dart';
import '../widgets/qr_scanner/qr_scanner_mobile_layout.dart';
import '../widgets/qr_scanner/qr_scanner_web_layout.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late final QrScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QrScannerController(
      initialMode: kIsWeb ? ScannerMode.web : ScannerMode.camera,
    );
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (_controller.lastScannedCode != null && !_controller.isProcessing) {
      final code = _controller.lastScannedCode!;
      _showDeviceDetailsDialog(code.macAddress, code.deviceName);
      _controller.clearLastScannedCode();
    }
  }

  void _handleQrCode(String code) async {
    final success = await _controller.processQrCode(code);
    if (!success && mounted) {
      _showErrorSnackBar(_controller.errorMessage ?? 'Invalid QR code');
    }
  }

  void _showDeviceDetailsDialog(String macAddress, String? suggestedName) {
    DeviceDetailsDialog.show(
      context: context,
      initialMacAddress: macAddress,
      initialDeviceName: suggestedName ?? 'HVAC Device',
      onConfirm: _handleAddDevice,
    );
  }

  void _handleAddDevice(String macAddress, String deviceName, String location) {
    context.read<HvacListBloc>().add(
          AddDeviceEvent(
            macAddress: macAddress,
            name: deviceName,
            location: location.isNotEmpty ? location : null,
          ),
        );

    Navigator.of(context).pop(); // Return to previous screen
    _showSuccessSnackBar(AppLocalizations.of(context)!.deviceAdded);
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: HvacRadius.smRadius,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: HvacRadius.smRadius,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        // Web layout
        if (kIsWeb) {
          return Scaffold(
            appBar: HvacAppBar(
              title: l10n.addDevice,
            ),
            body: QrScannerWebLayout(
              controller: _controller,
              onAddDevice: _handleAddDevice,
              onCodeDetected: _handleQrCode,
            ),
          );
        }

        // Mobile/Tablet layout
        return Scaffold(
          appBar: HvacAppBar(
            title: _controller.isManualMode ? l10n.addDevice : l10n.scanQrCode,
          ),
          body: QrScannerMobileLayout(
            controller: _controller,
            l10n: l10n,
            onAddDevice: _handleAddDevice,
            onCodeDetected: _handleQrCode,
          ),
        );
      },
    );
  }
}
