import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import 'empty_state_types.dart';
import 'empty_state_illustration.dart';

/// Size variant for empty state
enum EmptyStateSize {
  compact, // For small containers
  medium, // Default
  large, // For full screen
}

/// Comprehensive empty state component with animations and illustrations
///
/// Features:
/// - Multiple empty state types with appropriate icons and colors
/// - Size variants (compact, medium, large)
/// - Animated illustrations with pulse effects
/// - Factory constructors for common scenarios
/// - Multiple action buttons support
/// - Accessibility support
///
/// Usage:
/// ```dart
/// // Simple empty state
/// HvacEmptyState(
///   title: 'No Devices',
///   message: 'Add your first device to get started',
///   actionLabel: 'Add Device',
///   onAction: () => addDevice(),
/// )
///
/// // Using factory constructor
/// HvacEmptyState.noDevices(
///   message: 'Start by adding your first HVAC device',
///   onAddDevice: () => showAddDeviceDialog(),
/// )
///
/// // With custom illustration
/// HvacEmptyState(
///   title: 'No Data',
///   message: 'No analytics data available',
///   type: EmptyStateType.noData,
///   customIllustration: MyCustomWidget(),
///   showAnimation: true,
/// )
/// ```
class HvacEmptyState extends StatelessWidget {
  /// Empty state type for icon and color selection
  final EmptyStateType type;

  /// Custom icon (overrides type's default icon)
  final IconData? customIcon;

  /// Custom illustration widget (overrides icon-based illustration)
  final Widget? customIllustration;

  /// Title text (optional)
  final String? title;

  /// Message text (required)
  final String message;

  /// Primary action button label
  final String? actionLabel;

  /// Primary action callback
  final VoidCallback? onAction;

  /// Additional action widgets
  final List<Widget>? additionalActions;

  /// Show entrance animation
  final bool showAnimation;

  /// Display as full screen (with Scaffold)
  final bool isFullScreen;

  /// Size variant
  final EmptyStateSize size;

  /// Custom icon color (overrides type's color)
  final Color? customIconColor;

  /// Accessibility label
  final String? semanticLabel;

  /// Accessibility hint
  final String? semanticHint;

  const HvacEmptyState({
    super.key,
    this.type = EmptyStateType.general,
    this.customIcon,
    this.customIllustration,
    this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.additionalActions,
    this.showAnimation = true,
    this.isFullScreen = false,
    this.size = EmptyStateSize.medium,
    this.customIconColor,
    this.semanticLabel,
    this.semanticHint,
  });

  /// Factory: No devices found
  factory HvacEmptyState.noDevices({
    required String message,
    String? title,
    VoidCallback? onAddDevice,
    String actionLabel = 'Add Device',
    EmptyStateSize size = EmptyStateSize.medium,
    bool showAnimation = true,
  }) {
    return HvacEmptyState(
      type: EmptyStateType.noDevices,
      title: title ?? 'No Devices Found',
      message: message,
      actionLabel: actionLabel,
      onAction: onAddDevice,
      size: size,
      showAnimation: showAnimation,
    );
  }

  /// Factory: No schedules
  factory HvacEmptyState.noSchedules({
    required String message,
    String? title,
    VoidCallback? onCreateSchedule,
    String actionLabel = 'Create Schedule',
    EmptyStateSize size = EmptyStateSize.medium,
    bool showAnimation = true,
  }) {
    return HvacEmptyState(
      type: EmptyStateType.noSchedules,
      title: title ?? 'No Schedules Set',
      message: message,
      actionLabel: actionLabel,
      onAction: onCreateSchedule,
      size: size,
      showAnimation: showAnimation,
    );
  }

  /// Factory: No data available
  factory HvacEmptyState.noData({
    required String message,
    String? title,
    VoidCallback? onRefresh,
    String actionLabel = 'Refresh',
    EmptyStateSize size = EmptyStateSize.medium,
    bool showAnimation = true,
  }) {
    return HvacEmptyState(
      type: EmptyStateType.noData,
      title: title ?? 'No Data Available',
      message: message,
      actionLabel: actionLabel,
      onAction: onRefresh,
      size: size,
      showAnimation: showAnimation,
    );
  }

  /// Factory: No notifications
  factory HvacEmptyState.noNotifications({
    required String message,
    String? title,
    EmptyStateSize size = EmptyStateSize.medium,
    bool showAnimation = true,
  }) {
    return HvacEmptyState(
      type: EmptyStateType.noNotifications,
      title: title ?? 'All Caught Up!',
      message: message,
      size: size,
      showAnimation: showAnimation,
    );
  }

  /// Factory: No search results
  factory HvacEmptyState.noSearchResults({
    required String message,
    String? title,
    VoidCallback? onClearSearch,
    String actionLabel = 'Clear Search',
    EmptyStateSize size = EmptyStateSize.medium,
    bool showAnimation = true,
  }) {
    return HvacEmptyState(
      type: EmptyStateType.noSearchResults,
      title: title ?? 'No Results Found',
      message: message,
      actionLabel: actionLabel,
      onAction: onClearSearch,
      size: size,
      showAnimation: showAnimation,
    );
  }

  /// Factory: No connection
  factory HvacEmptyState.noConnection({
    required String message,
    String? title,
    VoidCallback? onRetry,
    String actionLabel = 'Retry',
    EmptyStateSize size = EmptyStateSize.medium,
    bool showAnimation = true,
  }) {
    return HvacEmptyState(
      type: EmptyStateType.noConnection,
      title: title ?? 'No Connection',
      message: message,
      actionLabel: actionLabel,
      onAction: onRetry,
      size: size,
      showAnimation: showAnimation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _EmptyStateContent(
      type: type,
      customIcon: customIcon,
      customIllustration: customIllustration,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      additionalActions: additionalActions,
      showAnimation: showAnimation,
      size: size,
      customIconColor: customIconColor,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
    );

    if (isFullScreen) {
      return Scaffold(
        backgroundColor: HvacColors.backgroundDark,
        body: SafeArea(child: Center(child: content)),
      );
    }

    return Center(child: content);
  }
}

class _EmptyStateContent extends StatelessWidget {
  final EmptyStateType type;
  final IconData? customIcon;
  final Widget? customIllustration;
  final String? title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<Widget>? additionalActions;
  final bool showAnimation;
  final EmptyStateSize size;
  final Color? customIconColor;
  final String? semanticLabel;
  final String? semanticHint;

  const _EmptyStateContent({
    required this.type,
    required this.customIcon,
    required this.customIllustration,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.additionalActions,
    required this.showAnimation,
    required this.size,
    required this.customIconColor,
    required this.semanticLabel,
    required this.semanticHint,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = _getSpacing();

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Illustration
        _buildIllustration(context),
        SizedBox(height: spacing.titleGap),

        // Title (optional)
        if (title != null) ...[
          Text(
            title!,
            style: _getTitleStyle(),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.messageGap),
        ],

        // Message
        Text(
          message,
          style: _getMessageStyle(),
          textAlign: TextAlign.center,
          maxLines: size == EmptyStateSize.compact ? 2 : null,
          overflow: size == EmptyStateSize.compact ? TextOverflow.ellipsis : null,
        ),

        // Primary action button
        if (actionLabel != null && onAction != null) ...[
          SizedBox(height: spacing.buttonGap),
          _buildActionButton(context),
        ],

        // Additional actions
        if (additionalActions != null && additionalActions!.isNotEmpty) ...[
          SizedBox(height: spacing.messageGap),
          ...additionalActions!,
        ],
      ],
    );

    // Wrap with animation if enabled
    if (showAnimation) {
      content = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: content,
      );
    }

    return Semantics(
      label: semanticLabel ?? '${title ?? 'Empty state'}. $message',
      hint: semanticHint ?? (onAction != null ? 'Double tap to ${actionLabel ?? "take action"}' : null),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.padding),
        child: content,
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    // Use custom illustration if provided
    if (customIllustration != null) {
      return customIllustration!;
    }

    // Get icon and color
    final iconData = customIcon ?? type.defaultIcon;
    final iconColor = customIconColor ?? type.getColor(Theme.of(context));

    return EmptyStateIllustration(
      icon: iconData,
      color: iconColor,
      showAnimation: showAnimation,
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Semantics(
      button: true,
      label: actionLabel!,
      child: SizedBox(
        height: 48.0, // Minimum touch target
        child: ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            onAction!();
          },
          icon: Icon(
            type.actionIcon,
            size: 20,
          ),
          label: Text(
            actionLabel!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: HvacColors.primaryOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: HvacSpacing.xl,
              vertical: HvacSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(HvacSpacing.md),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  _SizeConfig _getSpacing() {
    switch (size) {
      case EmptyStateSize.compact:
        return _SizeConfig(
          padding: HvacSpacing.md,
          titleGap: HvacSpacing.sm,
          messageGap: HvacSpacing.xs,
          buttonGap: HvacSpacing.md,
        );
      case EmptyStateSize.medium:
        return _SizeConfig(
          padding: HvacSpacing.xl,
          titleGap: HvacSpacing.md,
          messageGap: HvacSpacing.sm,
          buttonGap: HvacSpacing.xl,
        );
      case EmptyStateSize.large:
        return _SizeConfig(
          padding: HvacSpacing.xxl,
          titleGap: HvacSpacing.lg,
          messageGap: HvacSpacing.md,
          buttonGap: HvacSpacing.xxl,
        );
    }
  }

  TextStyle _getTitleStyle() {
    switch (size) {
      case EmptyStateSize.compact:
        return HvacTypography.h4.copyWith(color: HvacColors.textPrimary);
      case EmptyStateSize.medium:
        return HvacTypography.h3.copyWith(color: HvacColors.textPrimary);
      case EmptyStateSize.large:
        return HvacTypography.h2.copyWith(color: HvacColors.textPrimary);
    }
  }

  TextStyle _getMessageStyle() {
    switch (size) {
      case EmptyStateSize.compact:
        return HvacTypography.bodySmall.copyWith(color: HvacColors.textSecondary);
      case EmptyStateSize.medium:
        return HvacTypography.bodyMedium.copyWith(color: HvacColors.textSecondary);
      case EmptyStateSize.large:
        return HvacTypography.bodyLarge.copyWith(color: HvacColors.textSecondary);
    }
  }
}

class _SizeConfig {
  final double padding;
  final double titleGap;
  final double messageGap;
  final double buttonGap;

  _SizeConfig({
    required this.padding,
    required this.titleGap,
    required this.messageGap,
    required this.buttonGap,
  });
}
