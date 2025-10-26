/// QR Code Scanner Screen
///
/// Allows users to scan QR codes to add devices
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../widgets/gradient_button.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  final TextEditingController _macController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  bool _manualEntry = false;

  @override
  void dispose() {
    _controller.dispose();
    _macController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _handleQrCode(String? code) {
    if (code == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Parse QR code - expecting format: MAC_ADDRESS|DEVICE_NAME
    final parts = code.split('|');
    final macAddress = parts.isNotEmpty ? parts[0] : code;
    final deviceName = parts.length > 1 ? parts[1] : 'HVAC Device';

    _showDeviceDetailsDialog(macAddress, deviceName);
  }

  void _showDeviceDetailsDialog(String macAddress, String? suggestedName) {
    _macController.text = macAddress;
    _nameController.text = suggestedName ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(l10n.addDevice),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _macController,
                    decoration: InputDecoration(
                      labelText: l10n.macAddress,
                      prefixIcon: const Icon(Icons.router),
                    ),
                    readOnly: !_manualEntry,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.fillRequiredFields;
                      }
                      // Basic MAC address validation
                      final macRegex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
                      if (!macRegex.hasMatch(value)) {
                        return 'Invalid MAC address format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.deviceName,
                      hintText: l10n.livingRoom,
                      prefixIcon: const Icon(Icons.label),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.fillRequiredFields;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: l10n.location,
                      hintText: l10n.optional,
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isProcessing = false;
                  _manualEntry = false;
                });
                _clearControllers();
              },
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: _addDevice,
              child: Text(l10n.add),
            ),
          ],
        );
      },
    );
  }

  void _clearControllers() {
    _macController.clear();
    _nameController.clear();
    _locationController.clear();
  }

  void _addDevice() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final macAddress = _macController.text;
    final deviceName = _nameController.text;
    final location = _locationController.text;

    // Add device through bloc
    context.read<HvacListBloc>().add(
      AddDeviceEvent(
        macAddress: macAddress,
        name: deviceName,
        location: location.isNotEmpty ? location : null,
      ),
    );

    Navigator.of(context).pop(); // Close dialog
    Navigator.of(context).pop(); // Return to previous screen

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.deviceAdded),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _toggleManualEntry() {
    setState(() {
      _manualEntry = !_manualEntry;
    });

    if (_manualEntry) {
      _controller.stop();
      _showDeviceDetailsDialog('', null);
    } else {
      _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanQrCode),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_controller.torchEnabled ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              _controller.toggleTorch();
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      _handleQrCode(barcode.rawValue);
                    }
                  },
                ),

                // QR Frame Overlay
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Corner decorations
                        Positioned(
                          top: 0,
                          left: 0,
                          child: _buildCorner(true, true),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: _buildCorner(true, false),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: _buildCorner(false, true),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: _buildCorner(false, false),
                        ),
                      ],
                    ),
                  ),
                ),

                // Scanning indicator
                if (!_manualEntry)
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Scanning...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Manual entry section
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.enterMacManually,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  GradientButton(
                    onPressed: _toggleManualEntry,
                    text: _manualEntry ? l10n.scanQrCode : 'Enter Manually',
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                )
              : BorderSide.none,
          bottom: !isTop
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                )
              : BorderSide.none,
          left: isLeft
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                )
              : BorderSide.none,
          right: !isLeft
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                )
              : BorderSide.none,
        ),
      ),
    );
  }
}