/// Schedule-related dialogs with web-friendly interactions
///
/// Provides accessible confirmation and input dialogs for schedule management
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Accessible confirmation dialog with web-friendly hover states
class ScheduleConfirmDialog {
  /// Shows delete confirmation dialog
  static Future<bool> showDeleteConfirmation(
    BuildContext context, {
    required String scheduleName,
  }) async {
    final confirmed = await HvacConfirmDialog.show(
      context,
      title: 'Delete Schedule?',
      message: 'Are you sure you want to delete "$scheduleName"?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      dangerous: true,
    );

    return confirmed ?? false;
  }

  /// Generic confirmation dialog
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    Color? confirmColor,
    bool dangerous = false,
  }) async {
    final confirmed = await HvacConfirmDialog.show(
      context,
      title: title,
      message: message,
      confirmText: confirmLabel,
      cancelText: cancelLabel,
      confirmColor: confirmColor,
      dangerous: dangerous,
    );

    return confirmed ?? false;
  }
}
