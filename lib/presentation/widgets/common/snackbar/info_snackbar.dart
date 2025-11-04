import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'base_snackbar.dart';
import 'snackbar_types.dart';

/// Info snackbar variant for informational messages
class InfoSnackBar {
  InfoSnackBar._();

  /// Show info snackbar with responsive design
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    Duration? duration,
    SnackBarAction? action,
    bool enableHaptic = false,
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
      type: SnackBarType.info,
      icon: Icons.info_outline,
      backgroundColor: _getBackgroundColor(context),
      config: config,
    );
  }

  /// Show quick tip
  static void showTip(
    BuildContext context, {
    required String tip,
    VoidCallback? onLearnMore,
  }) {
    show(
      context,
      title: 'Tip',
      message: tip,
      action: onLearnMore != null ? SnackBarAction(
        label: 'LEARN MORE',
        onPressed: onLearnMore,
        textColor: Colors.white,
      ) : null,
      duration: const Duration(seconds: 4),
    );
  }

  /// Show update available
  static void showUpdateAvailable(
    BuildContext context, {
    required String version,
    VoidCallback? onUpdate,
    VoidCallback? onLater,
  }) {
    show(
      context,
      title: 'Update Available',
      message: 'Version $version is ready to install',
      action: onUpdate != null ? SnackBarAction(
        label: 'UPDATE',
        onPressed: onUpdate,
        textColor: Colors.white,
      ) : null,
      duration: const Duration(seconds: 6),
      showCloseButton: true,
      onDismissed: onLater,
    );
  }

  /// Show feature announcement
  static void showNewFeature(
    BuildContext context, {
    required String featureName,
    String? description,
    VoidCallback? onTryNow,
  }) {
    show(
      context,
      title: 'New Feature',
      message: description ?? '$featureName is now available',
      action: onTryNow != null ? SnackBarAction(
        label: 'TRY NOW',
        onPressed: onTryNow,
        textColor: Colors.white,
      ) : null,
      duration: const Duration(seconds: 5),
    );
  }

  /// Show sync status
  static void showSyncStatus(
    BuildContext context, {
    required bool isSyncing,
    String? lastSyncTime,
  }) {
    final message = isSyncing
      ? 'Syncing your data...'
      : lastSyncTime != null
        ? 'Last synced: $lastSyncTime'
        : 'Data is up to date';

    show(
      context,
      message: message,
      duration: const Duration(seconds: 2),
    );
  }

  /// Show offline mode info
  static void showOfflineMode(BuildContext context) {
    show(
      context,
      title: 'Offline Mode',
      message: 'You are working offline. Changes will sync when connected.',
      duration: const Duration(seconds: 4),
      showCloseButton: true,
    );
  }

  /// Show scheduled maintenance info
  static void showScheduledMaintenance(
    BuildContext context, {
    required DateTime startTime,
    required Duration expectedDuration,
    VoidCallback? onViewDetails,
  }) {
    final hours = expectedDuration.inHours;
    final minutes = expectedDuration.inMinutes % 60;
    final durationText = hours > 0
      ? '$hours hour${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes min' : ''}'
      : '$minutes minutes';

    show(
      context,
      title: 'Scheduled Maintenance',
      message: 'System maintenance scheduled for ${_formatDateTime(startTime)} (Est. $durationText)',
      action: onViewDetails != null ? SnackBarAction(
        label: 'DETAILS',
        onPressed: onViewDetails,
        textColor: Colors.white,
      ) : null,
      duration: const Duration(seconds: 6),
    );
  }

  /// Show energy saving tip
  static void showEnergySavingTip(
    BuildContext context, {
    required String tip,
    VoidCallback? onApply,
  }) {
    show(
      context,
      title: 'Energy Saving Tip',
      message: tip,
      action: onApply != null ? SnackBarAction(
        label: 'APPLY',
        onPressed: onApply,
        textColor: Colors.white,
      ) : null,
      duration: const Duration(seconds: 5),
    );
  }

  /// Show quota info
  static void showQuotaInfo(
    BuildContext context, {
    required String resource,
    required int used,
    required int total,
    VoidCallback? onManage,
  }) {
    final percentage = ((used / total) * 100).toStringAsFixed(0);

    show(
      context,
      title: '$resource Usage',
      message: 'Using $used of $total ($percentage%)',
      action: onManage != null ? SnackBarAction(
        label: 'MANAGE',
        onPressed: onManage,
        textColor: Colors.white,
      ) : null,
      duration: const Duration(seconds: 4),
    );
  }

  /// Show help hint
  static void showHint(
    BuildContext context, {
    required String hint,
    String? helpTopic,
    VoidCallback? onGetHelp,
  }) {
    show(
      context,
      title: helpTopic ?? 'Hint',
      message: hint,
      action: onGetHelp != null ? SnackBarAction(
        label: 'HELP',
        onPressed: onGetHelp,
        textColor: Colors.white,
      ) : null,
      duration: const Duration(seconds: 4),
    );
  }

  /// Get info background color
  static Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Use neutral color for info (not bright blue)
    return isDarkMode
      ? HvacColors.neutral400
      : HvacColors.neutral300;
  }

  /// Format date time for display
  static String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays == 0) {
      // Today
      return 'Today at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // Tomorrow
      return 'Tomorrow at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      // Specific date
      return '${dateTime.day}/${dateTime.month} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}