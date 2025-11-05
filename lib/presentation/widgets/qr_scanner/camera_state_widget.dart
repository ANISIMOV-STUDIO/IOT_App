/// Camera State Widget
///
/// Displays different states for camera operations
library;

import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
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
          const SizedBox(height: AppSpacing.lg),
          Text(
            message ?? 'Initializing camera...',
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    ThemeData theme,
    QrScannerResponsive responsive,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(responsive.horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: responsive.iconSize,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Camera Error',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message ?? 'An error occurred while accessing the camera.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 20.0),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200.0, responsive.buttonHeight),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDeniedState(
    ThemeData theme,
    QrScannerResponsive responsive,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(responsive.horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: responsive.iconSize,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Camera Permission Denied',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message ??
                  'Camera access is required to scan QR codes.\n'
                      'Please enable camera permissions in your browser settings.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 20.0),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200.0, responsive.buttonHeight),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUnsupportedState(
    ThemeData theme,
    QrScannerResponsive responsive,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(responsive.horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: responsive.iconSize,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Web Camera Not Available',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message ??
                  'QR code scanning via camera is not available on web.\n'
                      'Please use manual entry or scan from your mobile device.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum CameraStateType {
  loading,
  error,
  permissionDenied,
  unsupported,
}