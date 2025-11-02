import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/utils/accessibility_utils.dart';

/// Comprehensive snackbar system for user feedback
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
    if (enableHaptic) {
      AccessibilityUtils.hapticFeedback(HapticType.light);
    }

    _show(
      context,
      message: message,
      title: title,
      type: SnackBarType.success,
      duration: duration,
      action: action,
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
    if (enableHaptic) {
      AccessibilityUtils.hapticFeedback(HapticType.medium);
    }

    _show(
      context,
      message: message,
      title: title,
      type: SnackBarType.error,
      duration: duration,
      action: action,
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
    if (enableHaptic) {
      AccessibilityUtils.hapticFeedback(HapticType.light);
    }

    _show(
      context,
      message: message,
      title: title,
      type: SnackBarType.warning,
      duration: duration,
      action: action,
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
    if (enableHaptic) {
      AccessibilityUtils.hapticFeedback(HapticType.selection);
    }

    _show(
      context,
      message: message,
      title: title,
      type: SnackBarType.info,
      duration: duration,
      action: action,
    );
  }

  /// Show custom snackbar
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
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
        elevation: elevation,
        width: width,
        dismissDirection: dismissDirection ?? DismissDirection.down,
      ),
    );
  }

  /// Show loading snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoading(
    BuildContext context, {
    required String message,
    bool indefinite = true,
  }) {
    final snackBar = SnackBar(
      content: _LoadingSnackBarContent(message: message),
      duration: indefinite ? const Duration(days: 365) : const Duration(seconds: 30),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      dismissDirection: DismissDirection.none,
    );

    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Internal method to show snackbar
  static void _show(
    BuildContext context, {
    required String message,
    String? title,
    required SnackBarType type,
    Duration? duration,
    SnackBarAction? action,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Announce to screen reader
    AccessibilityUtils.announce('${type.name} notification: ${title ?? ''} $message');

    // Clear any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    // Show new snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _SnackBarContent(
          message: message,
          title: title,
          type: type,
        ),
        backgroundColor: _getBackgroundColor(type, isDarkMode),
        behavior: SnackBarBehavior.floating,
        duration: duration ?? _getDefaultDuration(type),
        action: action,
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  static Color _getBackgroundColor(SnackBarType type, bool isDarkMode) {
    switch (type) {
      case SnackBarType.success:
        return isDarkMode ? Colors.green.shade800 : Colors.green.shade600;
      case SnackBarType.error:
        return isDarkMode ? Colors.red.shade800 : Colors.red.shade600;
      case SnackBarType.warning:
        return isDarkMode ? Colors.orange.shade800 : Colors.orange.shade600;
      case SnackBarType.info:
        return isDarkMode ? Colors.blue.shade800 : Colors.blue.shade600;
    }
  }

  static Duration _getDefaultDuration(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return const Duration(seconds: 3);
      case SnackBarType.error:
        return const Duration(seconds: 5);
      case SnackBarType.warning:
        return const Duration(seconds: 4);
      case SnackBarType.info:
        return const Duration(seconds: 3);
    }
  }
}

/// Snackbar content widget
class _SnackBarContent extends StatelessWidget {
  final String message;
  final String? title;
  final SnackBarType type;

  const _SnackBarContent({
    required this.message,
    this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          _getIcon(),
          color: Colors.white,
          size: ResponsiveUtils.scaledIconSize(context, 24),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveUtils.scaledFontSize(context, 14),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
              ],
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: ResponsiveUtils.scaledFontSize(context, 13),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIcon() {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.info:
        return Icons.info_outline;
    }
  }
}

/// Loading snackbar content
class _LoadingSnackBarContent extends StatelessWidget {
  final String message;

  const _LoadingSnackBarContent({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.onPrimary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontSize: ResponsiveUtils.scaledFontSize(context, 14),
            ),
          ),
        ),
      ],
    );
  }
}

/// Toast notification system
class AppToast {
  AppToast._();

  static OverlayEntry? _currentToast;

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
    if (enableHaptic) {
      HapticFeedback.selectionClick();
    }

    // Remove existing toast
    _currentToast?.remove();
    _currentToast = null;

    // Create new toast
    _currentToast = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        icon: icon,
        position: position,
        backgroundColor: backgroundColor,
        textColor: textColor,
        onDismiss: () {
          _currentToast?.remove();
          _currentToast = null;
        },
      ),
    );

    // Insert toast
    Overlay.of(context).insert(_currentToast!);

    // Auto dismiss
    Future.delayed(duration, () {
      _currentToast?.remove();
      _currentToast = null;
    });
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
      backgroundColor: Colors.green,
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
      backgroundColor: Colors.red,
      enableHaptic: true,
    );
  }

  /// Dismiss current toast
  static void dismiss() {
    _currentToast?.remove();
    _currentToast = null;
  }
}

/// Toast widget
class _ToastWidget extends StatefulWidget {
  final String message;
  final IconData? icon;
  final ToastPosition position;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    this.icon,
    required this.position,
    this.backgroundColor,
    this.textColor,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.position == ToastPosition.top ? -1 : 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Positioned(
      top: widget.position == ToastPosition.top
          ? mediaQuery.padding.top + AppSpacing.md
          : null,
      bottom: widget.position == ToastPosition.bottom
          ? mediaQuery.padding.bottom + AppSpacing.md
          : null,
      left: AppSpacing.md,
      right: AppSpacing.md,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: widget.onDismiss,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? theme.colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: widget.textColor ?? theme.colorScheme.onInverseSurface,
                        size: ResponsiveUtils.scaledIconSize(context, 20),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Flexible(
                      child: Text(
                        widget.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: widget.textColor ?? theme.colorScheme.onInverseSurface,
                          fontSize: ResponsiveUtils.scaledFontSize(context, 14),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Snackbar types
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