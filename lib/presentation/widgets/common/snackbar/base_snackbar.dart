import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../core/theme/spacing.dart';
import 'snackbar_types.dart';

/// Base snackbar widget with common functionality
class BaseSnackBar extends StatelessWidget {
  final String message;
  final String? title;
  final SnackBarType type;
  final IconData icon;
  final Color backgroundColor;
  final SnackBarConfig config;
  final Widget? customContent;

  const BaseSnackBar({
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
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: customContent ?? _buildDefaultContent(context, theme),
      ),
    );
  }

  Widget _buildDefaultContent(BuildContext context, ThemeData theme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final horizontalPadding = isDesktop ? 24.0 : (screenWidth >= 600 ? 20.0 : 16.0);
    final verticalPadding = isDesktop ? 16.0 : (screenWidth >= 600 ? 14.0 : 12.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          _buildIcon(context),
          SizedBox(width: (isDesktop ? 12 : 8).w),
          Expanded(child: _buildTextContent(context, theme)),
          if (config.showCloseButton) _buildCloseButton(context),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth >= 1024 ? 24.0 : (screenWidth >= 600 ? 22.0 : 20.0);
    return Icon(
      icon,
      color: Colors.white,
      size: iconSize,
    );
  }

  Widget _buildTextContent(BuildContext context, ThemeData theme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth >= 1024 ? 14.0 : (screenWidth >= 600 ? 13.5 : 13.0);
    final messageFontSize = screenWidth >= 1024 ? 13.0 : (screenWidth >= 600 ? 12.5 : 12.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize,
            ),
          ),
          SizedBox(height: 4.h),
        ],
        Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.95),
            fontSize: messageFontSize,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final closeIconSize = screenWidth >= 1024 ? 20.0 : (screenWidth >= 600 ? 19.0 : 18.0);

    return IconButton(
      icon: Icon(
        Icons.close,
        color: Colors.white.withValues(alpha: 0.8),
        size: closeIconSize,
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        config.onDismissed?.call();
      },
      tooltip: 'Dismiss',
    );
  }

  /// Show the snackbar
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    required SnackBarType type,
    required IconData icon,
    required Color backgroundColor,
    SnackBarConfig? config,
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
    final snackbarMargin = EdgeInsets.all(AppSpacing.snackbarMargin(context));

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: BaseSnackBar(
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

  static SnackBarConfig _getDefaultConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return SnackBarConfig.success;
      case SnackBarType.error:
        return SnackBarConfig.error;
      case SnackBarType.warning:
        return SnackBarConfig.warning;
      case SnackBarType.info:
        return SnackBarConfig.info;
    }
  }

  static void _triggerHapticFeedback(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        HapticFeedback.lightImpact();
        break;
      case SnackBarType.error:
        HapticFeedback.mediumImpact();
        break;
      case SnackBarType.warning:
        HapticFeedback.lightImpact();
        break;
      case SnackBarType.info:
        HapticFeedback.selectionClick();
        break;
    }
  }
}