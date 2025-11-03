import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'base_snackbar.dart';
import 'snackbar_types.dart';

/// Success snackbar variant
class SuccessSnackBar {
  SuccessSnackBar._();

  /// Show success snackbar with responsive design
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    SnackBarAction? action,
    bool enableHaptic = true,
    bool showCloseButton = false,
    VoidCallback? onDismissed,
  }) {
    final config = SnackBarConfig(
      duration: duration ?? const Duration(seconds: 3),
      action: action,
      enableHaptic: enableHaptic,
      showCloseButton: showCloseButton,
      onDismissed: onDismissed,
    );

    BaseSnackBar.show(
      context,
      message: message,
      title: title,
      type: SnackBarType.success,
      icon: Icons.check_circle_outline,
      backgroundColor: _getBackgroundColor(context),
      config: config,
    );
  }

  /// Show quick success message
  static void showQuick(BuildContext context, String message) {
    show(
      context,
      message: message,
      duration: const Duration(seconds: 2),
      enableHaptic: true,
    );
  }

  /// Show success with custom action
  static void showWithAction(
    BuildContext context, {
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    String? title,
  }) {
    show(
      context,
      message: message,
      title: title,
      action: SnackBarAction(
        label: actionLabel,
        onPressed: onAction,
        textColor: Colors.white,
      ),
    );
  }

  /// Show success with undo action
  static void showWithUndo(
    BuildContext context, {
    required String message,
    required VoidCallback onUndo,
    String? title,
  }) {
    showWithAction(
      context,
      message: message,
      title: title,
      actionLabel: 'UNDO',
      onAction: onUndo,
    );
  }

  /// Get success background color
  static Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Use muted semantic color from luxury palette
    return HvacColors.success.withValues(
      alpha: isDarkMode ? 0.95 : 1.0,
    );
  }

  /// Show operation completed successfully
  static void showCompleted(
    BuildContext context, {
    required String operation,
    String? details,
  }) {
    show(
      context,
      title: '$operation Completed',
      message: details ?? 'Operation completed successfully',
      duration: const Duration(seconds: 3),
    );
  }

  /// Show saved successfully
  static void showSaved(BuildContext context, {String? itemName}) {
    show(
      context,
      message: itemName != null
        ? '$itemName saved successfully'
        : 'Changes saved successfully',
      duration: const Duration(seconds: 2),
    );
  }

  /// Show created successfully
  static void showCreated(BuildContext context, {required String itemName}) {
    show(
      context,
      message: '$itemName created successfully',
      duration: const Duration(seconds: 3),
    );
  }

  /// Show updated successfully
  static void showUpdated(BuildContext context, {required String itemName}) {
    show(
      context,
      message: '$itemName updated successfully',
      duration: const Duration(seconds: 2),
    );
  }

  /// Show deleted successfully with undo
  static void showDeleted(
    BuildContext context, {
    required String itemName,
    VoidCallback? onUndo,
  }) {
    if (onUndo != null) {
      showWithUndo(
        context,
        message: '$itemName deleted',
        onUndo: onUndo,
      );
    } else {
      show(
        context,
        message: '$itemName deleted successfully',
        duration: const Duration(seconds: 3),
      );
    }
  }
}