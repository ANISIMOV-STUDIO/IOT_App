/// Automation Panel Widget
///
/// Displays and manages automation rules
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
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
      padding: const EdgeInsets.all(HvacSpacing.lgR),
      decoration: HvacDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(HvacSpacing.smR),
                decoration: HvacDecorations.iconContainer(
                  color: HvacColors.warning,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: HvacColors.warning,
                  size: 20,
                ),
              ),
              const SizedBox(width: HvacSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Автоматизация',
                      style: HvacTypography.titleMedium.copyWith(
                        color: HvacColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: HvacSpacing.xxs),
                    Text(
                      'Активно: $activeRules из ${rules.length}',
                      style: HvacTypography.caption.copyWith(
                        color: HvacColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: HvacSpacing.md),

          // Rules list
          ...rules.take(3).map((rule) => _buildRuleItem(rule)),

          const SizedBox(height: HvacSpacing.sm),

          // Manage button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onManageRules,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: HvacColors.primaryOrange,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: HvacRadius.smRadius,
                ),
                padding: const EdgeInsets.symmetric(vertical: HvacSpacing.smR),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.settings,
                      color: HvacColors.primaryOrange, size: 16),
                  const SizedBox(width: HvacSpacing.xs),
                  Text(
                    'Управление правилами',
                    style: HvacTypography.labelLarge.copyWith(
                      color: HvacColors.primaryOrange,
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
      margin: const EdgeInsets.only(bottom: HvacSpacing.smR),
      padding: const EdgeInsets.all(HvacSpacing.mdR),
      decoration: HvacDecorations.cardFlat(
        color: HvacColors.backgroundDark,
        radius: HvacRadius.sm,
      ).copyWith(
        border: Border.all(
          color: rule.enabled
              ? HvacColors.success.withValues(alpha: 0.3)
              : HvacColors.backgroundCardBorder,
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
              color:
                  rule.enabled ? HvacColors.success : HvacColors.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: HvacSpacing.sm),

          // Rule info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.name,
                  style: HvacTypography.labelLarge.copyWith(
                    color: HvacColors.textPrimary,
                  ),
                ),
                const SizedBox(height: HvacSpacing.xxs),
                Text(
                  '${rule.conditionDescription} → ${rule.actionDescription}',
                  style: HvacTypography.caption.copyWith(
                    color: HvacColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: HvacSpacing.xs),

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
                activeTrackColor: HvacColors.success,
                inactiveThumbColor: HvacColors.textSecondary,
                inactiveTrackColor: HvacColors.backgroundCardBorder,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
