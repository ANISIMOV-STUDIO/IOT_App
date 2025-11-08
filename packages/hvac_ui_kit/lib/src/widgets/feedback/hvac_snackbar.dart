/// Comprehensive Snackbar System
/// Provides success, error, warning, info snackbars with Material 3 design
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../theme/typography.dart';

/// Snackbar types for different message categories
enum HvacSnackbarType {
  success,
  error,
  warning,
  info,
}

/// Configuration for snackbar appearance
class HvacSnackbarConfig {
  final Duration? duration;
  final SnackBarAction? action;
  final bool enableHaptic;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final DismissDirection dismissDirection;
  final bool showCloseButton;
  final VoidCallback? onDismissed;

  const HvacSnackbarConfig({
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
  static const success = HvacSnackbarConfig(
    duration: Duration(seconds: 3),
    enableHaptic: true,
  );

  /// Default config for error messages
  static const error = HvacSnackbarConfig(
    duration: Duration(seconds: 5),
    enableHaptic: true,
    showCloseButton: true,
  );

  /// Default config for warning messages
  static const warning = HvacSnackbarConfig(
    duration: Duration(seconds: 4),
    enableHaptic: true,
  );

  /// Default config for info messages
  static const info = HvacSnackbarConfig(
    duration: Duration(seconds: 3),
    enableHaptic: false,
  );

  /// Merge with another config
  HvacSnackbarConfig merge(HvacSnackbarConfig? other) {
    if (other == null) return this;
    return HvacSnackbarConfig(
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

/// Base snackbar widget with common functionality
class HvacSnackbar extends StatelessWidget {
  final String message;
  final String? title;
  final HvacSnackbarType type;
  final IconData icon;
  final Color backgroundColor;
  final HvacSnackbarConfig config;
  final Widget? customContent;

  const HvacSnackbar({
    super.key,
    required this.message,
    this.title,
    required this.type,
    required this.icon,
    required this.backgroundColor,
    required this.config,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: customContent ?? _buildDefaultContent(context),
      ),
    );
  }

  Widget _buildDefaultContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final horizontalPadding =
        isDesktop ? 24.0 : (screenWidth >= 600 ? 20.0 : 16.0);
    final verticalPadding =
        isDesktop ? 16.0 : (screenWidth >= 600 ? 14.0 : 12.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          _buildIcon(context),
          SizedBox(width: isDesktop ? 12.0 : 8.0),
          Expanded(child: _buildTextContent(context)),
          if (config.showCloseButton) _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize =
        screenWidth >= 1024 ? 24.0 : (screenWidth >= 600 ? 22.0 : 20.0);
    return Icon(
      icon,
      color: Colors.white,
      size: iconSize,
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: HvacTypography.bodyBold.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: HvacSpacing.xxs),
        ],
        Text(
          message,
          style: HvacTypography.bodyMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.95),
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.close,
        color: Colors.white.withValues(alpha: 0.8),
        size: 20.0,
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        config.onDismissed?.call();
      },
      tooltip: 'Dismiss',
    );
  }

  /// Show success snackbar
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    HvacSnackbarConfig? config,
  }) {
    _show(
      context,
      message: message,
      title: title,
      type: HvacSnackbarType.success,
      icon: Icons.check_circle,
      backgroundColor: HvacColors.success,
      config: config,
    );
  }

  /// Show error snackbar
  static void showError(
    BuildContext context,
    String message, {
    String? title,
    HvacSnackbarConfig? config,
  }) {
    _show(
      context,
      message: message,
      title: title,
      type: HvacSnackbarType.error,
      icon: Icons.error,
      backgroundColor: HvacColors.error,
      config: config,
    );
  }

  /// Show warning snackbar
  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
    HvacSnackbarConfig? config,
  }) {
    _show(
      context,
      message: message,
      title: title,
      type: HvacSnackbarType.warning,
      icon: Icons.warning_amber_rounded,
      backgroundColor: HvacColors.warning,
      config: config,
    );
  }

  /// Show info snackbar
  static void showInfo(
    BuildContext context,
    String message, {
    String? title,
    HvacSnackbarConfig? config,
  }) {
    _show(
      context,
      message: message,
      title: title,
      type: HvacSnackbarType.info,
      icon: Icons.info,
      backgroundColor: HvacColors.info,
      config: config,
    );
  }

  /// Generic show method
  static void _show(
    BuildContext context, {
    required String message,
    String? title,
    required HvacSnackbarType type,
    required IconData icon,
    required Color backgroundColor,
    HvacSnackbarConfig? config,
    Widget? customContent,
  }) {
    final finalConfig = _getDefaultConfig(type).merge(config);

    // Haptic feedback
    if (finalConfig.enableHaptic) {
      _triggerHapticFeedback(type);
    }

    // Clear existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    // Get responsive values
    final screenWidth = MediaQuery.of(context).size.width;
    final snackbarWidth = screenWidth < 600
        ? null
        : (screenWidth < 1024 ? 500.0 : (screenWidth < 1440 ? 450.0 : 480.0));
    final snackbarMargin = EdgeInsets.all(screenWidth < 600 ? 16.0 : 20.0);

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: HvacSnackbar(
          message: message,
          title: title,
          type: type,
          icon: icon,
          backgroundColor: backgroundColor,
          config: finalConfig,
          customContent: customContent,
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: finalConfig.duration ?? const Duration(seconds: 4),
        action: finalConfig.action,
        margin: finalConfig.margin ?? snackbarMargin,
        width: finalConfig.width ?? snackbarWidth,
        shape: RoundedRectangleBorder(
          borderRadius: HvacRadius.smRadius,
        ),
        dismissDirection: finalConfig.dismissDirection,
      ),
    );
  }

  static HvacSnackbarConfig _getDefaultConfig(HvacSnackbarType type) {
    switch (type) {
      case HvacSnackbarType.success:
        return HvacSnackbarConfig.success;
      case HvacSnackbarType.error:
        return HvacSnackbarConfig.error;
      case HvacSnackbarType.warning:
        return HvacSnackbarConfig.warning;
      case HvacSnackbarType.info:
        return HvacSnackbarConfig.info;
    }
  }

  static void _triggerHapticFeedback(HvacSnackbarType type) {
    switch (type) {
      case HvacSnackbarType.success:
        HapticFeedback.lightImpact();
        break;
      case HvacSnackbarType.error:
        HapticFeedback.mediumImpact();
        break;
      case HvacSnackbarType.warning:
        HapticFeedback.lightImpact();
        break;
      case HvacSnackbarType.info:
        HapticFeedback.selectionClick();
        break;
    }
  }
}
