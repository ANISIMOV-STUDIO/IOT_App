/// Компонент BREEZ Checkbox
library;

import 'package:flutter/material.dart';
import '../../../core/constants/auth_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/app_icon_sizes.dart';
import '../../../core/theme/spacing.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezCheckbox
abstract class _CheckboxConstants {
  static const double borderRadius = 4.0;
  static const double topMargin = 2.0;
  static const double lineHeight = 1.4;
}

// =============================================================================
// WIDGET
// =============================================================================

/// BREEZ styled checkbox с текстом
class BreezCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;
  final double? fontSize;

  const BreezCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.fontSize,
  });

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AuthConstants.checkboxSize,
              height: AuthConstants.checkboxSize,
              margin: EdgeInsets.only(top: _CheckboxConstants.topMargin),
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
                  height: _CheckboxConstants.lineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
