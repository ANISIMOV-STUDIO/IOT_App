/// Add Unit Button - Button to add new HVAC unit
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/common/hover_builder.dart';

/// Compact add button for unit tabs
class AddUnitButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AddUnitButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      onTap: onTap,
      builder: (context, isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isHovered
                ? AppColors.accent.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isHovered ? AppColors.accent : Colors.transparent,
            ),
          ),
          child: Icon(
            Icons.add_rounded,
            size: 20,
            color: isHovered ? AppColors.accent : AppColors.darkTextMuted,
          ),
        );
      },
    );
  }
}
