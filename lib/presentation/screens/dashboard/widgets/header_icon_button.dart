/// Header Icon Button - Reusable icon button for header
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/common/hover_builder.dart';

/// Icon button with badge for header
class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String? badge;
  final VoidCallback? onTap;

  const HeaderIconButton({
    super.key,
    required this.icon,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      onTap: onTap,
      builder: (context, isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isHovered
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: isHovered ? Colors.white : AppColors.darkTextMuted,
                ),
              ),
              if (badge != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.accentRed,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
