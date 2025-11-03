import 'package:flutter/material.dart';

/// Snackbar types for different message categories
enum SnackBarType {
  success,
  error,
  warning,
  info,
}

/// Toast positions
enum ToastPosition {
  top,
  bottom,
}

/// Error action for error snackbars
class ErrorAction {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const ErrorAction({
    required this.label,
    required this.onPressed,
    this.icon,
  });
}

/// Configuration for snackbar appearance
class SnackBarConfig {
  final Duration? duration;
  final SnackBarAction? action;
  final bool enableHaptic;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final DismissDirection dismissDirection;
  final bool showCloseButton;
  final VoidCallback? onDismissed;

  const SnackBarConfig({
    this.duration,
    this.action,
    this.enableHaptic = true,
    this.margin,
    this.width,
    this.dismissDirection = DismissDirection.horizontal,
    this.showCloseButton = false,
    this.onDismissed,
  });

  /// Default config for success messages
  static const SnackBarConfig success = SnackBarConfig(
    duration: Duration(seconds: 3),
    enableHaptic: true,
  );

  /// Default config for error messages
  static const SnackBarConfig error = SnackBarConfig(
    duration: Duration(seconds: 5),
    enableHaptic: true,
    showCloseButton: true,
  );

  /// Default config for warning messages
  static const SnackBarConfig warning = SnackBarConfig(
    duration: Duration(seconds: 4),
    enableHaptic: true,
  );

  /// Default config for info messages
  static const SnackBarConfig info = SnackBarConfig(
    duration: Duration(seconds: 3),
    enableHaptic: false,
  );

  /// Merge with another config
  SnackBarConfig merge(SnackBarConfig? other) {
    if (other == null) return this;
    return SnackBarConfig(
      duration: other.duration ?? duration,
      action: other.action ?? action,
      enableHaptic: other.enableHaptic,
      margin: other.margin ?? margin,
      width: other.width ?? width,
      dismissDirection: other.dismissDirection,
      showCloseButton: other.showCloseButton,
      onDismissed: other.onDismissed ?? onDismissed,
    );
  }
}