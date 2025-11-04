/// Snackbar Helper Mixin
///
/// Provides reusable snackbar methods for UI feedback
/// Part of code quality improvements to reduce duplication
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
/// Mixin providing snackbar helper methods
mixin SnackbarMixin<T extends StatefulWidget> on State<T> {
  /// Show success snackbar with green background
  void showSuccessSnackbar(String message, {Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: HvacColors.textPrimary,
              size: 20.sp,
            ),
            const SizedBox(width: HvacSpacing.smR),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: HvacColors.success,
        duration: duration ?? const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(HvacSpacing.mdR),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  /// Show error snackbar with red background
  void showErrorSnackbar(String message, {Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: HvacColors.textPrimary,
              size: 20.sp,
            ),
            const SizedBox(width: HvacSpacing.smR),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: HvacColors.error,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(HvacSpacing.mdR),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  /// Show info snackbar with blue background
  void showInfoSnackbar(String message, {Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: HvacColors.textPrimary,
              size: 20.sp,
            ),
            const SizedBox(width: HvacSpacing.smR),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: HvacColors.info,
        duration: duration ?? const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(HvacSpacing.mdR),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  /// Show warning snackbar with orange background
  void showWarningSnackbar(String message, {Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: HvacColors.textPrimary,
              size: 20.sp,
            ),
            const SizedBox(width: HvacSpacing.smR),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: HvacColors.warning,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(HvacSpacing.mdR),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  /// Show custom snackbar with action
  void showActionSnackbar({
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    Color? backgroundColor,
    Duration? duration,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        action: SnackBarAction(
          label: actionLabel,
          onPressed: onAction,
          textColor: HvacColors.textPrimary,
        ),
        backgroundColor: backgroundColor ?? HvacColors.backgroundCard,
        duration: duration ?? const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(HvacSpacing.mdR),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  /// Hide current snackbar
  void hideSnackbar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}