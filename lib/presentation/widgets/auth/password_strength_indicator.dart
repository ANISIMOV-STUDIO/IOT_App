/// Password Strength Indicator Widget
///
/// Visual indicator for password strength with responsive design
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import '../../../core/constants/security_constants.dart';
import '../../../core/utils/validators.dart';
import 'responsive_utils.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final bool showRequirements;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.showRequirements = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = AuthResponsive(context);
    final strength = Validators.calculatePasswordStrength(password);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bar
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: HvacRadius.xsRadius,
                child: LinearProgressIndicator(
                  value: (strength.index + 1) / 4,
                  backgroundColor:
                      HvacColors.textSecondary.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getStrengthColor(strength),
                  ),
                  minHeight: 4.rh(context),
                ),
              ),
            ),
            SizedBox(width: 8.rw(context)),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _getStrengthText(strength),
                key: ValueKey(strength),
                style: TextStyle(
                  color: _getStrengthColor(strength),
                  fontSize: (12 * responsive.fontMultiplier).rsp(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        if (showRequirements) ...[
          SizedBox(height: 8.rh(context)),
          _buildRequirements(context, responsive, theme),
        ],
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildRequirements(
    BuildContext context,
    AuthResponsive responsive,
    ThemeData theme,
  ) {
    final requirements = [
      _RequirementItem(
        'At least 8 characters',
        password.length >= 8,
      ),
      _RequirementItem(
        'Uppercase letter',
        password.contains(RegExp(r'[A-Z]')),
      ),
      _RequirementItem(
        'Lowercase letter',
        password.contains(RegExp(r'[a-z]')),
      ),
      _RequirementItem(
        'Number',
        password.contains(RegExp(r'[0-9]')),
      ),
      _RequirementItem(
        'Special character',
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ),
    ];

    return Wrap(
      spacing: 8.rw(context),
      runSpacing: 4.rh(context),
      children: requirements.map((req) {
        return MouseRegion(
          cursor: SystemMouseCursors.basic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: 8.rw(context),
              vertical: 4.rh(context),
            ),
            decoration: BoxDecoration(
              color: req.isMet
                  ? HvacColors.success.withValues(alpha: 0.1)
                  : HvacColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: HvacRadius.xsRadius,
              border: Border.all(
                color: req.isMet
                    ? HvacColors.success.withValues(alpha: 0.4)
                    : HvacColors.textSecondary.withValues(alpha: 0.4),
                width: 1.rw(context),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  req.isMet ? Icons.check_circle : Icons.circle_outlined,
                  size: (14 * responsive.fontMultiplier).rsp(context),
                  color:
                      req.isMet ? HvacColors.success : HvacColors.textSecondary,
                ),
                SizedBox(width: 4.rw(context)),
                Text(
                  req.label,
                  style: TextStyle(
                    fontSize: (11 * responsive.fontMultiplier).rsp(context),
                    color: req.isMet
                        ? HvacColors.success
                        : HvacColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return HvacColors.error;
      case PasswordStrength.medium:
        return HvacColors.warning;
      case PasswordStrength.strong:
        return HvacColors.success.withValues(alpha: 0.7);
      case PasswordStrength.veryStrong:
        return HvacColors.success;
    }
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }
}

class _RequirementItem {
  final String label;
  final bool isMet;

  _RequirementItem(this.label, this.isMet);
}
