/// Camera State Widget
///
/// Displays different states for camera operations
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'qr_scanner_responsive.dart';

class CameraStateWidget extends StatelessWidget {
  final CameraStateType type;
  final String? message;
  final VoidCallback? onRetry;

  const CameraStateWidget({
    super.key,
    required this.type,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = QrScannerResponsive(context);

    switch (type) {
      case CameraStateType.loading:
        return _buildLoadingState(theme);
      case CameraStateType.error:
        return _buildErrorState(theme, responsive);
      case CameraStateType.permissionDenied:
        return _buildPermissionDeniedState(theme, responsive);
      case CameraStateType.unsupported:
        return _buildUnsupportedState(theme, responsive);
    }
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3.0,
          ),
          const HvacGap.lg(),
          Text(
            message ?? 'Initializing camera...',
            style: HvacTypography.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    ThemeData theme,
    QrScannerResponsive responsive,
  ) {
    return HvacErrorState(
      errorType: ErrorType.general,
      customIcon: Icons.error_outline,
      title: 'Camera Error',
      message: message ?? 'An error occurred while accessing the camera.',
      onRetry: onRetry,
    );
  }

  Widget _buildPermissionDeniedState(
    ThemeData theme,
    QrScannerResponsive responsive,
  ) {
    return HvacErrorState(
      errorType: ErrorType.permission,
      customIcon: Icons.camera_alt_outlined,
      title: 'Camera Permission Denied',
      message: message ??
          'Camera access is required to scan QR codes.\n'
              'Please enable camera permissions in your browser settings.',
      onRetry: onRetry,
    );
  }

  Widget _buildUnsupportedState(
    ThemeData theme,
    QrScannerResponsive responsive,
  ) {
    return HvacEmptyState(
      type: EmptyStateType.general,
      customIcon: Icons.qr_code_scanner,
      title: 'Web Camera Not Available',
      message: message ??
          'QR code scanning via camera is not available on web.\n'
              'Please use manual entry or scan from your mobile device.',
    );
  }
}

enum CameraStateType {
  loading,
  error,
  permissionDenied,
  unsupported,
}
