/// Add Unit Button - Button to add new HVAC unit
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';

/// Compact add button for unit tabs
class AddUnitButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AddUnitButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.nested),
        hoverColor: AppColors.accent.withValues(alpha: 0.15),
        splashColor: AppColors.accent.withValues(alpha: 0.2),
        highlightColor: AppColors.accent.withValues(alpha: 0.1),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.nested),
          ),
          child: Icon(
            Icons.add_rounded,
            size: 20,
            color: colors.textMuted,
          ),
        ),
      ),
    );
  }
}
