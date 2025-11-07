import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'base_snackbar.dart';
import 'snackbar_types.dart';

/// Warning snackbar variant
class WarningSnackBar {
  WarningSnackBar._();

  /// Show warning snackbar with responsive design
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
      duration: duration ?? const Duration(seconds: 4),
      action: action,
      enableHaptic: enableHaptic,
      showCloseButton: showCloseButton,
      onDismissed: onDismissed,
    );

    BaseSnackBar.show(
      context,
      message: message,
      title: title ?? 'Warning',
      type: SnackBarType.warning,
      icon: Icons.warning_amber_outlined,
      backgroundColor: _getBackgroundColor(context),
      config: config,
    );
  }

  /// Show low battery warning
  static void showLowBattery(
    BuildContext context, {
    required String deviceName,
    required int batteryLevel,
    VoidCallback? onViewDetails,
  }) {
    show(
      context,
      title: 'Low Battery',
      message: '$deviceName battery is at $batteryLevel%',
      action: onViewDetails != null
          ? SnackBarAction(
              label: 'VIEW',
              onPressed: onViewDetails,
              textColor: Colors.white,
            )
          : null,
      duration: const Duration(seconds: 5),
    );
  }

  /// Show maintenance reminder
  static void showMaintenanceReminder(
    BuildContext context, {
    required String equipment,
    required String maintenanceType,
    VoidCallback? onSchedule,
  }) {
    show(
      context,
      title: 'Maintenance Required',
      message: '$equipment requires $maintenanceType',
      action: onSchedule != null
          ? SnackBarAction(
              label: 'SCHEDULE',
              onPressed: onSchedule,
              textColor: Colors.white,
            )
          : null,
      duration: const Duration(seconds: 6),
    );
  }

  /// Show temperature warning
  static void showTemperatureWarning(
    BuildContext context, {
    required String zone,
    required double temperature,
    required String unit,
    bool isHigh = true,
  }) {
    show(
      context,
      title: 'Temperature Alert',
      message:
          '$zone temperature is ${isHigh ? "too high" : "too low"} (${temperature.toStringAsFixed(1)}°$unit)',
      duration: const Duration(seconds: 5),
      showCloseButton: true,
    );
  }

  /// Show system warning
  static void showSystemWarning(
    BuildContext context, {
    required String message,
    VoidCallback? onViewDetails,
  }) {
    show(
      context,
      title: 'System Warning',
      message: message,
      action: onViewDetails != null
          ? SnackBarAction(
              label: 'DETAILS',
              onPressed: onViewDetails,
              textColor: Colors.white,
            )
          : null,
      duration: const Duration(seconds: 5),
    );
  }

  /// Show connection unstable warning
  static void showUnstableConnection(BuildContext context) {
    show(
      context,
      title: 'Connection Unstable',
      message: 'Your connection may be experiencing issues',
      duration: const Duration(seconds: 3),
    );
  }

  /// Show data loss warning
  static void showDataLossWarning(
    BuildContext context, {
    required VoidCallback onContinue,
    VoidCallback? onCancel,
  }) {
    show(
      context,
      title: 'Unsaved Changes',
      message: 'You have unsaved changes that will be lost',
      action: SnackBarAction(
        label: 'CONTINUE',
        onPressed: onContinue,
        textColor: Colors.white,
      ),
      duration: const Duration(seconds: 6),
      showCloseButton: true,
      onDismissed: onCancel,
    );
  }

  /// Show resource limit warning
  static void showResourceLimit(
    BuildContext context, {
    required String resource,
    required int percentage,
    VoidCallback? onManage,
  }) {
    show(
      context,
      title: 'Resource Warning',
      message: '$resource usage is at $percentage%',
      action: onManage != null
          ? SnackBarAction(
              label: 'MANAGE',
              onPressed: onManage,
              textColor: Colors.white,
            )
          : null,
      duration: const Duration(seconds: 5),
    );
  }

  /// Show deprecation warning
  static void showDeprecationWarning(
    BuildContext context, {
    required String feature,
    String? alternativeFeature,
    VoidCallback? onLearnMore,
  }) {
    final message = alternativeFeature != null
        ? '$feature will be deprecated. Please use $alternativeFeature instead.'
        : '$feature will be deprecated in a future version.';

    show(
      context,
      title: 'Feature Deprecation',
      message: message,
      action: onLearnMore != null
          ? SnackBarAction(
              label: 'LEARN MORE',
              onPressed: onLearnMore,
              textColor: Colors.white,
            )
          : null,
      duration: const Duration(seconds: 6),
    );
  }

  /// Get warning background color
  static Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Use muted semantic color from luxury palette
    return HvacColors.warning.withValues(
      alpha: isDarkMode ? 0.95 : 1.0,
    );
  }
}
