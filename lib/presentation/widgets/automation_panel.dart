/// Automation Panel Widget
///
/// Displays and manages automation rules
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/automation_rule.dart';

class AutomationPanel extends StatelessWidget {
  final List<AutomationRule> rules;
  final ValueChanged<AutomationRule>? onRuleToggled;
  final VoidCallback? onManageRules;

  const AutomationPanel({
    super.key,
    required this.rules,
    this.onRuleToggled,
    this.onManageRules,
  });

  @override
  Widget build(BuildContext context) {
    final activeRules = rules.where((r) => r.enabled).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.warning,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Автоматизация',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Активно: $activeRules из ${rules.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Rules list
          ...rules.take(3).map((rule) => _buildRuleItem(rule)),

          const SizedBox(height: 12),

          // Manage button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onManageRules,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppTheme.primaryOrange,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, color: AppTheme.primaryOrange, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Управление правилами',
                    style: TextStyle(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(AutomationRule rule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: rule.enabled
              ? AppTheme.success.withValues(alpha: 0.3)
              : AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: rule.enabled ? AppTheme.success : AppTheme.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

          // Rule info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${rule.conditionDescription} → ${rule.actionDescription}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Toggle switch
          SizedBox(
            height: 24,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Switch(
                value: rule.enabled,
                onChanged: (value) {
                  if (onRuleToggled != null) {
                    onRuleToggled!(rule.copyWith(enabled: value));
                  }
                },
                activeThumbColor: Colors.white,
                activeTrackColor: AppTheme.success,
                inactiveThumbColor: AppTheme.textSecondary,
                inactiveTrackColor: AppTheme.backgroundCardBorder,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
