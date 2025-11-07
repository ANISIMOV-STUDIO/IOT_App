/// Empty State Widget
///
/// Comprehensive empty state widget with illustrations and actions
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'empty_state/empty_state_types.dart';
import 'empty_state/empty_state_illustration.dart';

// Export sub-components
export 'empty_state/empty_state_types.dart';
export 'empty_state/empty_state_illustration.dart';
export 'empty_state/compact_empty_state.dart';

/// Comprehensive empty state widget with illustrations
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Widget? illustration;
  final VoidCallback? onAction;
  final String? actionLabel;
  final EmptyStateType type;
  final List<Widget>? additionalActions;
  final bool showAnimation;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.illustration,
    this.onAction,
    this.actionLabel,
    this.type = EmptyStateType.general,
    this.additionalActions,
    this.showAnimation = true,
  });

  /// Factory: No devices found
  factory EmptyStateWidget.noDevices({VoidCallback? onAddDevice}) {
    return EmptyStateWidget(
      title: 'No Devices Found',
      message: 'Start by adding your first HVAC device to control it remotely.',
      icon: Icons.devices_other_rounded,
      onAction: onAddDevice,
      actionLabel: 'Add Device',
      type: EmptyStateType.noDevices,
    );
  }

  /// Factory: No schedules
  factory EmptyStateWidget.noSchedules({VoidCallback? onCreateSchedule}) {
    return EmptyStateWidget(
      title: 'No Schedules Set',
      message: 'Create schedules to automate your HVAC system and save energy.',
      icon: Icons.schedule_rounded,
      onAction: onCreateSchedule,
      actionLabel: 'Create Schedule',
      type: EmptyStateType.noSchedules,
    );
  }

  /// Factory: No data available
  factory EmptyStateWidget.noData({VoidCallback? onRefresh, String? customMessage}) {
    return EmptyStateWidget(
      title: 'No Data Available',
      message: customMessage ?? 'There\'s no data to display at the moment.',
      icon: Icons.analytics_outlined,
      onAction: onRefresh,
      actionLabel: 'Refresh',
      type: EmptyStateType.noData,
    );
  }

  /// Factory: No notifications
  factory EmptyStateWidget.noNotifications() {
    return const EmptyStateWidget(
      title: 'All Caught Up!',
      message: 'You don\'t have any notifications right now.',
      icon: Icons.notifications_none_rounded,
      type: EmptyStateType.noNotifications,
    );
  }

  /// Factory: No search results
  factory EmptyStateWidget.noSearchResults({
    VoidCallback? onClearSearch,
    String? searchQuery,
  }) {
    return EmptyStateWidget(
      title: 'No Results Found',
      message: searchQuery != null
          ? 'No results found for "$searchQuery". Try adjusting your search.'
          : 'No results match your search criteria.',
      icon: Icons.search_off_rounded,
      onAction: onClearSearch,
      actionLabel: 'Clear Search',
      type: EmptyStateType.noSearchResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIllustration(context, theme),
        const SizedBox(height: HvacSpacing.xl),
        _buildTitle(context, theme),
        const SizedBox(height: HvacSpacing.sm),
        _buildMessage(context, theme),
        if (onAction != null) ...[
          const SizedBox(height: HvacSpacing.xl),
          _buildActionButton(context, theme),
        ],
        if (additionalActions != null && additionalActions!.isNotEmpty) ...[
          const SizedBox(height: HvacSpacing.md),
          ...additionalActions!,
        ],
      ],
    );

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
      label: '$title. $message',
      hint: onAction != null ? 'Double tap to ${actionLabel ?? "take action"}' : null,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveUtils.getMaxContentWidth(context) * 0.8,
          ),
          padding: EdgeInsets.all(
            ResponsiveUtils.scaledSpacing(context, HvacSpacing.xl),
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context, ThemeData theme) {
    if (illustration != null) {
      return illustration!;
    }

    final effectiveIcon = icon ?? type.defaultIcon;
    final iconColor = type.getColor(theme);

    return EmptyStateIllustration(
      icon: effectiveIcon,
      color: iconColor,
      showAnimation: showAnimation,
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: ResponsiveUtils.scaledFontSize(context, 22),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(BuildContext context, ThemeData theme) {
    return Text(
      message,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        fontSize: ResponsiveUtils.scaledFontSize(context, 15),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    final effectiveLabel = actionLabel ?? 'Take Action';

    return Semantics(
      button: true,
      label: effectiveLabel,
      child: SizedBox(
        height: 48.0, // Minimum touch target
        child: ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            onAction!();
          },
          icon: Icon(
            type.actionIcon,
            size: ResponsiveUtils.scaledIconSize(context, 20),
          ),
          label: Text(
            effectiveLabel,
            style: TextStyle(
              fontSize: ResponsiveUtils.scaledFontSize(context, 16),
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ElevatedButton.styleFrom(
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
}
