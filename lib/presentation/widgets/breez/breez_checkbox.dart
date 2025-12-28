/// Компонент BREEZ Checkbox
library;

import 'package:flutter/material.dart';
import '../../../core/constants/auth_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/app_icon_sizes.dart';
import '../../../core/theme/spacing.dart';

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

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AuthConstants.checkboxSize,
            height: AuthConstants.checkboxSize,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: value ? AppColors.accent : colors.card,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: value ? AppColors.accent : colors.border,
                width: value ? 0 : 1,
              ),
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: AppIconSizes.small,
                    color: Colors.white,
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
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
