/// Quick actions panel for schedule presets with web interactions
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Panel with quick action buttons for schedule presets
class QuickActionsPanel extends StatelessWidget {
  final VoidCallback onWeekdaySchedule;
  final VoidCallback onWeekendSchedule;
  final VoidCallback onDisableAll;

  const QuickActionsPanel({
    super.key,
    required this.onWeekdaySchedule,
    required this.onWeekendSchedule,
    required this.onDisableAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Быстрые действия',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  title: 'Будни',
                  subtitle: 'Пн-Пт 7:00-20:00',
                  icon: Icons.work_outline,
                  onPressed: onWeekdaySchedule,
                  color: HvacColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _QuickActionButton(
                  title: 'Выходные',
                  subtitle: 'Сб-Вс 9:00-22:00',
                  icon: Icons.weekend,
                  onPressed: onWeekendSchedule,
                  color: HvacColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            width: double.infinity,
            child: _QuickActionButton(
              title: 'Отключить всё',
              subtitle: 'Выключить расписание на всю неделю',
              icon: Icons.clear,
              onPressed: onDisableAll,
              color: HvacColors.error,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual quick action button with neumorphic styling
class _QuickActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final bool isFullWidth;

  const _QuickActionButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    required this.color,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return HvacNeumorphicButton(
      onPressed: onPressed,
      borderRadius: 8.0,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20.0,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.0,
                    color: HvacColors.textSecondary,
                  ),
                  overflow: isFullWidth ? TextOverflow.visible : TextOverflow.ellipsis,
                  maxLines: isFullWidth ? 2 : 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}