/// Camera State Widget
///
/// Displays different states for camera operations
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          CircularProgressIndicator(
            strokeWidth: 3.w,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: AppSpacing.lgR),
          Text(
            message ?? 'Initializing camera...',
            style: TextStyle(
              fontSize: 16.sp,
              color: theme.colorScheme.onSurfaceVariant,
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
            SizedBox(height: AppSpacing.lgR),
            Text(
              'Camera Error',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppSpacing.mdR),
            Text(
              message ?? 'An error occurred while accessing the camera.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.xlR),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh, size: 20.w),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200.w, responsive.buttonHeight),
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
            SizedBox(height: AppSpacing.lgR),
            Text(
              'Camera Permission Denied',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppSpacing.mdR),
            Text(
              message ??
                  'Camera access is required to scan QR codes.\n'
                      'Please enable camera permissions in your browser settings.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.xlR),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh, size: 20.w),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200.w, responsive.buttonHeight),
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
            SizedBox(height: AppSpacing.lgR),
            Text(
              'Web Camera Not Available',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppSpacing.mdR),
            Text(
              message ??
                  'QR code scanning via camera is not available on web.\n'
                      'Please use manual entry or scan from your mobile device.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurfaceVariant,
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