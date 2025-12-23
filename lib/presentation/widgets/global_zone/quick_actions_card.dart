/// Quick actions card
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';

/// Quick action item definition
class QuickActionItem {
  final String id;
  final IconData icon;
  final String label;
  final Color? color;
  final bool requiresConfirmation;

  const QuickActionItem({
    required this.id,
    required this.icon,
    required this.label,
    this.color,
    this.requiresConfirmation = false,
  });
}

/// Card with quick action buttons
class QuickActionsCard extends StatelessWidget {
  final List<QuickActionItem> actions;
  final ValueChanged<String>? onActionPressed;
  final String title;

  const QuickActionsCard({
    super.key,
    required this.actions,
    this.onActionPressed,
    this.title = 'Быстрые действия',
  });

  /// Default quick actions
  static List<QuickActionItem> defaultActions({
    String allOffLabel = 'Выкл. всё',
    String syncLabel = 'Синхр.',
    String scheduleLabel = 'Расписание',
    String settingsLabel = 'Настройки',
  }) {
    return [
      QuickActionItem(
        id: 'all_off',
        icon: Icons.power_settings_new,
        label: allOffLabel,
        color: AppColors.error,
        requiresConfirmation: true,
      ),
      QuickActionItem(
        id: 'sync',
        icon: Icons.sync,
        label: syncLabel,
      ),
      QuickActionItem(
        id: 'schedule',
        icon: Icons.calendar_today,
        label: scheduleLabel,
      ),
      QuickActionItem(
        id: 'settings',
        icon: Icons.settings,
        label: settingsLabel,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: actions.map((action) {
                final isLast = action == actions.last;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : 8),
                    child: _QuickActionButton(
                      action: action,
                      onPressed: onActionPressed != null
                          ? () => _handleAction(context, action)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, QuickActionItem action) {
    if (action.requiresConfirmation) {
      _showConfirmationDialog(context, action);
    } else {
      onActionPressed?.call(action.id);
    }
  }

  void _showConfirmationDialog(BuildContext context, QuickActionItem action) {
    ShadTheme.of(context);

    showShadDialog(
      context: context,
      builder: (ctx) => ShadDialog.alert(
        title: const Text('Подтверждение'),
        description: Text('Вы уверены, что хотите ${action.label.toLowerCase()}?'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Отмена'),
          ),
          ShadButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onActionPressed?.call(action.id);
            },
            child: const Text('Да'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final QuickActionItem action;
  final VoidCallback? onPressed;

  const _QuickActionButton({
    required this.action,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final color = action.color ?? AppColors.primary;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.muted.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.border,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 60;

            if (isCompact) {
              // Horizontal layout for very small heights
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action.icon, color: color, size: 18),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      action.label,
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.1),
                  ),
                  child: Icon(action.icon, color: color, size: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  action.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
