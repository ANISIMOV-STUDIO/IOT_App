/// Quick actions card
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';

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
        color: NeumorphicColors.accentError,
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
    final t = NeumorphicTheme.of(context);

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.typography.titleMedium),
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
    final t = NeumorphicTheme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Подтверждение',
          style: t.typography.titleMedium,
        ),
        content: Text(
          'Вы уверены, что хотите ${action.label.toLowerCase()}?',
          style: t.typography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Отмена',
              style: TextStyle(color: t.colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onActionPressed?.call(action.id);
            },
            child: Text(
              'Да',
              style: TextStyle(
                color: action.color ?? NeumorphicColors.accentPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
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
    final t = NeumorphicTheme.of(context);
    final color = action.color ?? NeumorphicColors.accentPrimary;

    return NeumorphicInteractiveCard(
      onTap: onPressed,
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Neumorphic(
            style: const NeumorphicStyle(
              depth: 2,
              intensity: 0.5,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(action.icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            action.label,
            style: t.typography.labelSmall.copyWith(color: color),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
