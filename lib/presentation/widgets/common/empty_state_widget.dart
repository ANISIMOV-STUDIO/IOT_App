import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

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

  factory EmptyStateWidget.noDevices({
    VoidCallback? onAddDevice,
  }) {
    return EmptyStateWidget(
      title: 'No Devices Found',
      message: 'Start by adding your first HVAC device to control it remotely.',
      icon: Icons.devices_other_rounded,
      onAction: onAddDevice,
      actionLabel: 'Add Device',
      type: EmptyStateType.noDevices,
    );
  }

  factory EmptyStateWidget.noSchedules({
    VoidCallback? onCreateSchedule,
  }) {
    return EmptyStateWidget(
      title: 'No Schedules Set',
      message: 'Create schedules to automate your HVAC system and save energy.',
      icon: Icons.schedule_rounded,
      onAction: onCreateSchedule,
      actionLabel: 'Create Schedule',
      type: EmptyStateType.noSchedules,
    );
  }

  factory EmptyStateWidget.noData({
    VoidCallback? onRefresh,
    String? customMessage,
  }) {
    return EmptyStateWidget(
      title: 'No Data Available',
      message: customMessage ?? 'There\'s no data to display at the moment.',
      icon: Icons.analytics_outlined,
      onAction: onRefresh,
      actionLabel: 'Refresh',
      type: EmptyStateType.noData,
    );
  }

  factory EmptyStateWidget.noNotifications() {
    return const EmptyStateWidget(
      title: 'All Caught Up!',
      message: 'You don\'t have any notifications right now.',
      icon: Icons.notifications_none_rounded,
      type: EmptyStateType.noNotifications,
    );
  }

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

    final effectiveIcon = icon ?? _getIconForType();
    final iconSize = ResponsiveUtils.scaledIconSize(context, 120.0);
    final iconColor = _getColorForType(theme);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: iconSize * 1.5,
            height: iconSize * 1.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.1),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background pulse animation
                if (showAnimation)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.5, end: 1.0),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    onEnd: () {},
                    builder: (context, pulseValue, child) {
                      return Container(
                        width: iconSize * 1.3 * pulseValue,
                        height: iconSize * 1.3 * pulseValue,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: iconColor.withValues(alpha: 0.05 * (2 - pulseValue)),
                        ),
                      );
                    },
                  ),
                Icon(
                  effectiveIcon,
                  size: iconSize * 0.7,
                  color: iconColor,
                  semanticLabel: 'Empty state icon',
                ),
              ],
            ),
          ),
        );
      },
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
            _getActionIconForType(),
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

  IconData _getIconForType() {
    switch (type) {
      case EmptyStateType.noDevices:
        return Icons.devices_other_rounded;
      case EmptyStateType.noSchedules:
        return Icons.schedule_rounded;
      case EmptyStateType.noData:
        return Icons.analytics_outlined;
      case EmptyStateType.noNotifications:
        return Icons.notifications_none_rounded;
      case EmptyStateType.noSearchResults:
        return Icons.search_off_rounded;
      case EmptyStateType.noConnection:
        return Icons.wifi_off_rounded;
      case EmptyStateType.general:
        return Icons.inbox_rounded;
    }
  }

  IconData _getActionIconForType() {
    switch (type) {
      case EmptyStateType.noDevices:
        return Icons.add_rounded;
      case EmptyStateType.noSchedules:
        return Icons.add_alarm_rounded;
      case EmptyStateType.noData:
        return Icons.refresh_rounded;
      case EmptyStateType.noSearchResults:
        return Icons.clear_rounded;
      case EmptyStateType.noConnection:
        return Icons.refresh_rounded;
      case EmptyStateType.general:
      case EmptyStateType.noNotifications:
        return Icons.arrow_forward_rounded;
    }
  }

  Color _getColorForType(ThemeData theme) {
    switch (type) {
      case EmptyStateType.noDevices:
        return Colors.blue;
      case EmptyStateType.noSchedules:
        return Colors.orange;
      case EmptyStateType.noData:
        return Colors.purple;
      case EmptyStateType.noNotifications:
        return Colors.green;
      case EmptyStateType.noSearchResults:
        return Colors.grey;
      case EmptyStateType.noConnection:
        return Colors.red;
      case EmptyStateType.general:
        return theme.colorScheme.primary;
    }
  }
}

/// Types of empty states
enum EmptyStateType {
  general,
  noDevices,
  noSchedules,
  noData,
  noNotifications,
  noSearchResults,
  noConnection,
}

/// Compact empty state for smaller spaces
class CompactEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;

  const CompactEmptyState({
    super.key,
    required this.message,
    required this.icon,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: message,
      hint: onAction != null ? 'Double tap to take action' : null,
      child: InkWell(
        onTap: onAction,
        borderRadius: BorderRadius.circular(HvacSpacing.md),
        child: Container(
          padding: const EdgeInsets.all(HvacSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: ResponsiveUtils.scaledIconSize(context, 48),
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              const SizedBox(height: HvacSpacing.sm),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: ResponsiveUtils.scaledFontSize(context, 14),
                ),
                textAlign: TextAlign.center,
              ),
              if (onAction != null) ...[
                const SizedBox(height: HvacSpacing.sm),
                Icon(
                  Icons.refresh_rounded,
                  size: ResponsiveUtils.scaledIconSize(context, 20),
                  color: theme.colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}