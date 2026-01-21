/// Компонент BREEZ Checkbox
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/constants/auth_constants.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezCheckbox
abstract class _CheckboxConstants {
  static const double borderRadius = 4;
}

// =============================================================================
// WIDGET
// =============================================================================

/// BREEZ styled checkbox с текстом
class BreezCheckbox extends StatelessWidget {

  const BreezCheckbox({
    required this.value, required this.onChanged, required this.label, super.key,
    this.fontSize,
  });
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Semantics(
      checked: value,
      enabled: onChanged != null,
      label: label,
      child: GestureDetector(
        onTap: onChanged != null ? () => onChanged!(!value) : null,
        behavior: HitTestBehavior.opaque,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AuthConstants.checkboxSize,
              height: AuthConstants.checkboxSize,
              decoration: BoxDecoration(
                color: value ? AppColors.accent : colors.card,
                borderRadius: BorderRadius.circular(_CheckboxConstants.borderRadius),
                border: Border.all(
                  color: value ? AppColors.accent : colors.border,
                  width: value ? 0 : 1,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      size: AppIconSizes.small,
                      color: AppColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: fontSize ?? AppFontSizes.bodySmall,
                  color: colors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
