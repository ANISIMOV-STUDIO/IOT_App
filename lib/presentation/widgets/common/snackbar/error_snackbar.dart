import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'base_snackbar.dart';
import 'snackbar_types.dart';

/// Error snackbar variant with enhanced error handling
class ErrorSnackBar {
  ErrorSnackBar._();

  /// Show error snackbar with responsive design
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    SnackBarAction? action,
    bool enableHaptic = true,
    bool showCloseButton = true,
    String? errorCode,
    VoidCallback? onRetry,
    VoidCallback? onDismissed,
  }) {
    final config = SnackBarConfig(
      duration: duration ?? const Duration(seconds: 5),
      action: action ?? (onRetry != null ? SnackBarAction(
        label: 'RETRY',
        onPressed: onRetry,
        textColor: Colors.white,
      ) : null),
      enableHaptic: enableHaptic,
      showCloseButton: showCloseButton,
      onDismissed: onDismissed,
    );

    // Add error code to message if provided
    final fullMessage = errorCode != null
      ? '$message (Code: $errorCode)'
      : message;

    BaseSnackBar.show(
      context,
      message: fullMessage,
      title: title ?? 'Error',
      type: SnackBarType.error,
      icon: Icons.error_outline,
      backgroundColor: _getBackgroundColor(context),
      config: config,
    );
  }

  /// Show network error
  static void showNetworkError(
    BuildContext context, {
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    show(
      context,
      title: 'Connection Error',
      message: customMessage ?? 'Unable to connect. Please check your internet connection.',
      onRetry: onRetry,
      showCloseButton: true,
    );
  }

  /// Show server error
  static void showServerError(
    BuildContext context, {
    String? errorCode,
    VoidCallback? onRetry,
  }) {
    show(
      context,
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
      errorCode: errorCode,
      onRetry: onRetry,
      duration: const Duration(seconds: 6),
    );
  }

  /// Show validation error
  static void showValidationError(
    BuildContext context, {
    required String field,
    required String message,
  }) {
    show(
      context,
      title: 'Validation Error',
      message: '$field: $message',
      duration: const Duration(seconds: 4),
      showCloseButton: true,
    );
  }

  /// Show permission error
  static void showPermissionError(
    BuildContext context, {
    required String permission,
    VoidCallback? onOpenSettings,
  }) {
    show(
      context,
      title: 'Permission Required',
      message: 'Please grant $permission permission to continue.',
      action: onOpenSettings != null ? SnackBarAction(
        label: 'SETTINGS',
        onPressed: onOpenSettings,
        textColor: Colors.white,
      ) : null,
      duration: const Duration(seconds: 6),
    );
  }

  /// Show authentication error
  static void showAuthError(
    BuildContext context, {
    String? message,
    VoidCallback? onSignIn,
  }) {
    show(
      context,
      title: 'Authentication Failed',
      message: message ?? 'Please sign in to continue.',
      action: onSignIn != null ? SnackBarAction(
        label: 'SIGN IN',
        onPressed: onSignIn,
        textColor: Colors.white,
      ) : null,
    );
  }

  /// Show timeout error
  static void showTimeoutError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    show(
      context,
      title: 'Request Timeout',
      message: 'The request took too long. Please try again.',
      onRetry: onRetry,
      duration: const Duration(seconds: 4),
    );
  }

  /// Show generic error with details
  static void showWithDetails(
    BuildContext context, {
    required String message,
    String? technicalDetails,
    VoidCallback? onShowDetails,
    VoidCallback? onRetry,
  }) {
    show(
      context,
      message: message,
      action: onShowDetails != null ? SnackBarAction(
        label: 'DETAILS',
        onPressed: () {
          onShowDetails();
          // Show details in dialog or bottom sheet
          _showErrorDetailsDialog(context, message, technicalDetails);
        },
        textColor: Colors.white,
      ) : (onRetry != null ? SnackBarAction(
        label: 'RETRY',
        onPressed: onRetry,
        textColor: Colors.white,
      ) : null),
    );
  }

  /// Get error background color
  static Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Use muted semantic color from luxury palette
    return HvacColors.error.withValues(
      alpha: isDarkMode ? 0.95 : 1.0,
    );
  }

  /// Show error details in a dialog
  static void _showErrorDetailsDialog(
    BuildContext context,
    String message,
    String? technicalDetails,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Message:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 8.h),
              Text(message),
              if (technicalDetails != null) ...[
                SizedBox(height: 16.h),
                Text(
                  'Technical Details:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: HvacRadius.xsRadius,
                  ),
                  child: SelectableText(
                    technicalDetails,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}