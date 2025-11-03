import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'snackbar_types.dart';
import 'toast_widget.dart';

/// Toast notification system for quick messages
class ToastNotification {
  ToastNotification._();

  static OverlayEntry? _currentToast;
  static Timer? _dismissTimer;

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
    VoidCallback? onTap,
  }) {
    if (enableHaptic) {
      HapticFeedback.selectionClick();
    }

    // Remove existing toast
    dismiss();

    // Create new toast
    _currentToast = OverlayEntry(
      builder: (context) => ToastWidget(
        message: message,
        icon: icon,
        position: position,
        backgroundColor: backgroundColor,
        textColor: textColor,
        onTap: onTap,
        onDismiss: dismiss,
      ),
    );

    // Insert toast
    Overlay.of(context).insert(_currentToast!);

    // Auto dismiss
    _dismissTimer = Timer(duration, dismiss);
  }

  /// Show success toast
  static void showSuccess(
    BuildContext context, {
    required String message,
    ToastPosition position = ToastPosition.top,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context,
      message: message,
      icon: Icons.check_circle,
      position: position,
      duration: duration,
      backgroundColor: HvacColors.success,
      enableHaptic: true,
    );
  }

  /// Show error toast
  static void showError(
    BuildContext context, {
    required String message,
    ToastPosition position = ToastPosition.top,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      icon: Icons.error,
      position: position,
      duration: duration,
      backgroundColor: HvacColors.error,
      enableHaptic: true,
    );
  }

  /// Show warning toast
  static void showWarning(
    BuildContext context, {
    required String message,
    ToastPosition position = ToastPosition.top,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      icon: Icons.warning,
      position: position,
      duration: duration,
      backgroundColor: HvacColors.warning,
      enableHaptic: true,
    );
  }

  /// Show info toast
  static void showInfo(
    BuildContext context, {
    required String message,
    ToastPosition position = ToastPosition.bottom,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context,
      message: message,
      icon: Icons.info,
      position: position,
      duration: duration,
      backgroundColor: HvacColors.backgroundCard,
    );
  }

  /// Show quick action completed
  static void showActionCompleted(
    BuildContext context, {
    required String action,
  }) {
    showSuccess(
      context,
      message: '$action completed',
      duration: const Duration(milliseconds: 1500),
    );
  }

  /// Show copied to clipboard
  static void showCopied(BuildContext context) {
    show(
      context,
      message: 'Copied to clipboard',
      icon: Icons.content_copy,
      position: ToastPosition.bottom,
      duration: const Duration(milliseconds: 1500),
      enableHaptic: true,
    );
  }

  /// Show deleted with undo option
  static void showDeleted(
    BuildContext context, {
    required String itemName,
    VoidCallback? onUndo,
  }) {
    show(
      context,
      message: '$itemName deleted',
      icon: Icons.delete_outline,
      position: ToastPosition.bottom,
      duration: const Duration(seconds: 3),
      backgroundColor: HvacColors.textSecondary,
      onTap: onUndo,
      enableHaptic: true,
    );
  }

  /// Show network status change
  static void showNetworkStatus(
    BuildContext context, {
    required bool isOnline,
  }) {
    show(
      context,
      message: isOnline ? 'Back online' : 'No connection',
      icon: isOnline ? Icons.wifi : Icons.wifi_off,
      position: ToastPosition.top,
      duration: const Duration(seconds: 2),
      backgroundColor: isOnline ? HvacColors.success : HvacColors.backgroundCard,
    );
  }

  /// Dismiss current toast
  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentToast?.remove();
    _currentToast = null;
  }
}