/// Web Camera Handler
///
/// Manages web camera API access and QR code scanning for web platform
/// Provides fallback for unsupported browsers
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/theme/spacing.dart';
import 'camera_state_widget.dart';
import 'qr_scanner_responsive.dart';

enum WebCameraState {
  initial,
  requestingPermission,
  permissionGranted,
  permissionDenied,
  scanning,
  error,
  unsupported,
}

class WebCameraHandler extends StatefulWidget {
  final Function(String code) onCodeDetected;
  final VoidCallback? onPermissionDenied;
  final VoidCallback? onUnsupported;

  const WebCameraHandler({
    super.key,
    required this.onCodeDetected,
    this.onPermissionDenied,
    this.onUnsupported,
  });

  @override
  State<WebCameraHandler> createState() => _WebCameraHandlerState();
}

class _WebCameraHandlerState extends State<WebCameraHandler> {
  WebCameraState _state = WebCameraState.initial;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeWebCamera();
    } else {
      _state = WebCameraState.unsupported;
    }
  }

  Future<void> _initializeWebCamera() async {
    setState(() {
      _state = WebCameraState.requestingPermission;
    });

    // Simulate camera permission request
    await Future.delayed(const Duration(seconds: 1));

    // In production, this would interface with actual web camera APIs
    // For now, we'll show the unsupported state with helpful message
    setState(() {
      _state = WebCameraState.unsupported;
      _errorMessage = 'Web camera scanning requires additional setup. '
          'Please use manual entry or scan from mobile device.';
    });
    widget.onUnsupported?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = QrScannerResponsive(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(responsive.borderRadius),
      ),
      child: _buildStateContent(context, theme, responsive),
    );
  }

  Widget _buildStateContent(
    BuildContext context,
    ThemeData theme,
    QrScannerResponsive responsive,
  ) {
    switch (_state) {
      case WebCameraState.initial:
      case WebCameraState.requestingPermission:
        return const CameraStateWidget(
          type: CameraStateType.loading,
          message: 'Initializing camera...',
        );

      case WebCameraState.permissionDenied:
        return CameraStateWidget(
          type: CameraStateType.permissionDenied,
          message: 'Camera access is required to scan QR codes.\n'
              'Please enable camera permissions in your browser settings.',
          onRetry: _initializeWebCamera,
        );

      case WebCameraState.unsupported:
        return CameraStateWidget(
          type: CameraStateType.unsupported,
          message: _errorMessage,
        );

      case WebCameraState.error:
        return CameraStateWidget(
          type: CameraStateType.error,
          message: _errorMessage,
          onRetry: _initializeWebCamera,
        );

      case WebCameraState.scanning:
        return _buildScanningState(theme, responsive);

      case WebCameraState.permissionGranted:
        return _buildCameraView(theme, responsive);
    }
  }

  Widget _buildScanningState(
    ThemeData theme,
    QrScannerResponsive responsive,
  ) {
    return Stack(
      children: [
        _buildCameraView(theme, responsive),
        Center(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: HvacRadius.smRadius,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'Processing QR Code...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraView(
    ThemeData theme,
    QrScannerResponsive responsive,
  ) {
    // Placeholder for camera view
    // In production, this would show actual camera feed
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(responsive.borderRadius),
      ),
      child: const Center(
        child: Text(
          'Camera View',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
