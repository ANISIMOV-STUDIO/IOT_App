/// Modular Snackbar System for BREEZ Home App
///
/// This is the main entry point for all snackbar functionality.
/// It provides a unified API that maintains backward compatibility
/// while offering enhanced features for web-responsive design.
library;

// Export all snackbar components
export 'snackbar_types.dart';
export 'base_snackbar.dart' show BaseSnackBar;
export 'success_snackbar.dart' show SuccessSnackBar;
export 'error_snackbar.dart' show ErrorSnackBar;
export 'warning_snackbar.dart' show WarningSnackBar;
export 'info_snackbar.dart' show InfoSnackBar;
export 'loading_snackbar.dart' show LoadingSnackBar;
export 'toast_notification.dart' show ToastNotification;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'success_snackbar.dart';
import 'error_snackbar.dart';
import 'warning_snackbar.dart';
import 'info_snackbar.dart';
import 'loading_snackbar.dart';
import 'toast_notification.dart';
import 'snackbar_types.dart';

/// Main AppSnackBar class for backward compatibility
///
/// This class provides static methods that delegate to the
/// specific snackbar variant classes while maintaining the
/// same API as the original implementation.
class AppSnackBar {
  AppSnackBar._();

  /// Show success snackbar
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    SnackBarAction? action,
    bool enableHaptic = true,
  }) {
    SuccessSnackBar.show(
      context,
      message: message,
      title: title,
      duration: duration,
      action: action,
      enableHaptic: enableHaptic,
    );
  }

  /// Show error snackbar
  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    SnackBarAction? action,
    bool enableHaptic = true,
  }) {
    ErrorSnackBar.show(
      context,
      message: message,
      title: title,
      duration: duration,
      action: action,
      enableHaptic: enableHaptic,
    );
  }

  /// Show warning snackbar
  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    SnackBarAction? action,
    bool enableHaptic = true,
  }) {
    WarningSnackBar.show(
      context,
      message: message,
      title: title,
      duration: duration,
      action: action,
      enableHaptic: enableHaptic,
    );
  }

  /// Show info snackbar
  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    SnackBarAction? action,
    bool enableHaptic = false,
  }) {
    InfoSnackBar.show(
      context,
      message: message,
      title: title,
      duration: duration,
      action: action,
      enableHaptic: enableHaptic,
    );
  }

  /// Show loading snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoading(
    BuildContext context, {
    required String message,
    bool indefinite = true,
  }) {
    return LoadingSnackBar.show(
      context,
      message: message,
      indefinite: indefinite,
    );
  }

  /// Show custom snackbar (for special cases)
  static void showCustom(
    BuildContext context, {
    required Widget content,
    Duration? duration,
    SnackBarAction? action,
    Color? backgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    SnackBarBehavior? behavior,
    ShapeBorder? shape,
    double? elevation,
    double? width,
    DismissDirection? dismissDirection,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: content,
        duration: duration ?? const Duration(seconds: 4),
        action: action,
        backgroundColor: backgroundColor,
        margin: margin,
        padding: padding,
        behavior: behavior ?? SnackBarBehavior.floating,
        shape: shape ?? RoundedRectangleBorder(
          borderRadius: HvacRadius.smRadius,
        ),
        elevation: elevation,
        width: width,
        dismissDirection: dismissDirection ?? DismissDirection.down,
      ),
    );
  }
}

/// Main AppToast class for backward compatibility
///
/// This class provides static methods that delegate to the
/// ToastNotification class while maintaining the same API.
class AppToast {
  AppToast._();

  /// Show toast notification
  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    ToastPosition position = ToastPosition.bottom,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Color? textColor,
    bool enableHaptic = false,
  }) {
    ToastNotification.show(
      context,
      message: message,
      icon: icon,
      position: position,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      enableHaptic: enableHaptic,
    );
  }

  /// Show success toast
  static void showSuccess(
    BuildContext context, {
    required String message,
    ToastPosition position = ToastPosition.top,
    Duration duration = const Duration(seconds: 2),
  }) {
    ToastNotification.showSuccess(
      context,
      message: message,
      position: position,
      duration: duration,
    );
  }

  /// Show error toast
  static void showError(
    BuildContext context, {
    required String message,
    ToastPosition position = ToastPosition.top,
    Duration duration = const Duration(seconds: 3),
  }) {
    ToastNotification.showError(
      context,
      message: message,
      position: position,
      duration: duration,
    );
  }

  /// Dismiss current toast
  static void dismiss() {
    ToastNotification.dismiss();
  }
}