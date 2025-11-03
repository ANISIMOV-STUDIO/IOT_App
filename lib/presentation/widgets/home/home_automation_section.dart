/// Home Automation Section Widget
///
/// Displays automation rules with toggle controls
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/automation_rule.dart';
import '../automation_panel.dart';

class HomeAutomationSection extends StatelessWidget {
  final HvacUnit? currentUnit;
  final ValueChanged<AutomationRule> onRuleToggled;
  final VoidCallback onManageRules;

  const HomeAutomationSection({
    super.key,
    this.currentUnit,
    required this.onRuleToggled,
    required this.onManageRules,
  });

  @override
  Widget build(BuildContext context) {
    if (currentUnit == null) {
      return Center(
        child: Text(
          'Устройство не выбрано',
          style: TextStyle(
            fontSize: 14.sp,
            color: HvacColors.textSecondary,
          ),
        ),
      );
    }

    return AutomationPanel(
      rules: AutomationRule.defaults,
      onRuleToggled: onRuleToggled,
      onManageRules: onManageRules,
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(
          begin: 0.1,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOut,
        );
  }
}
