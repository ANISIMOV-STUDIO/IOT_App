/// QR Scanner Camera Widget
///
/// Handles mobile camera functionality for QR code scanning
/// Manages camera lifecycle and error states
library;

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'camera_state_widget.dart';
import 'camera_toolbar.dart';
import 'qr_scanner_overlay.dart';

class QrScannerCamera extends StatefulWidget {
  final Function(String code) onCodeDetected;
  final bool enableTorch;
  final VoidCallback? onTorchToggle;

  const QrScannerCamera({
    super.key,
    required this.onCodeDetected,
    this.enableTorch = false,
    this.onTorchToggle,
  });

  @override
  State<QrScannerCamera> createState() => _QrScannerCameraState();
}

class _QrScannerCameraState extends State<QrScannerCamera>
    with WidgetsBindingObserver {
  MobileScannerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _controller!.start();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _controller!.stop();
        break;
      default:
        break;
    }
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _hasError = false;
        _errorMessage = null;
      });

      _controller = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: widget.enableTorch,
      );

      await _controller!.start();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() => _isProcessing = true);
        widget.onCodeDetected(barcode.rawValue!);

        // Reset after a delay to allow for new scans
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _isProcessing = false);
          }
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: CameraStateWidget(
          type: CameraStateType.error,
          message: _errorMessage ?? 'Failed to initialize camera',
          onRetry: _initializeCamera,
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return Container(
        color: Colors.black,
        child: const CameraStateWidget(
          type: CameraStateType.loading,
          message: 'Initializing camera...',
        ),
      );
    }

    return Stack(
      children: [
        // Camera view
        MobileScanner(
          controller: _controller!,
          onDetect: _handleBarcode,
        ),

        // QR Scanner overlay
        QrScannerOverlay(
          isScanning: !_isProcessing,
          statusMessage: _isProcessing ? 'Processing...' : 'Scanning...',
        ),

        // Camera toolbar
        CameraToolbar(
          controller: _controller!,
          onTorchToggle: widget.onTorchToggle,
        ),
      ],
    );
  }
}
