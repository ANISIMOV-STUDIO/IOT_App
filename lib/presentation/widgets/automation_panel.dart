/// Automation Panel Widget
///
/// Displays and manages automation rules with consistent HVAC UI Kit styling
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/automation_rule.dart';
import '../../generated/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final activeRules = rules.where((r) => r.enabled).length;

    return HvacCard(
      padding: const EdgeInsets.all(HvacSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(HvacSpacing.sm),
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
                      l10n.automation,
                      style: HvacTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: HvacColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: HvacSpacing.xxs),
                    Text(
                      l10n.activeRulesFormat(activeRules, rules.length),
                      style: HvacTypography.labelSmall.copyWith(
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
          ...rules.take(3).map((rule) => _buildRuleItem(context, rule)),

          const SizedBox(height: HvacSpacing.sm),

          // Manage button
          SizedBox(
            width: double.infinity,
            child: HvacOutlineButton(
              label: l10n.manageRules,
              onPressed: onManageRules,
              icon: Icons.settings,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(BuildContext context, AutomationRule rule) {
    return Container(
      margin: const EdgeInsets.only(bottom: HvacSpacing.sm),
      child: HvacCard(
        padding: const EdgeInsets.all(HvacSpacing.md),
        backgroundColor: HvacColors.backgroundCard,
        borderColor: rule.enabled
            ? HvacColors.success.withValues(alpha: 0.3)
            : HvacColors.backgroundCardBorder,
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
                  style: HvacTypography.labelMedium.copyWith(
                    color: HvacColors.textPrimary,
                  ),
                ),
                const SizedBox(height: HvacSpacing.xxs),
                Text(
                  '${rule.conditionDescription} → ${rule.actionDescription}',
                  style: HvacTypography.bodySmall.copyWith(
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
      ),
    );
  }
}