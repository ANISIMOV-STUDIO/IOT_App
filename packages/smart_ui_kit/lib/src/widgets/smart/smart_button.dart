import 'package:flutter/material.dart';
import '../../theme/tokens/app_spacing.dart';
import '../../theme/tokens/app_typography.dart';

enum SmartButtonType { primary, secondary, outline }

class SmartButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final SmartButtonType type;
  final Widget? icon;
  final bool isLoading;

  const SmartButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = SmartButtonType.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.v12,
            horizontal: AppSpacing.v24,
          ),
          decoration: _getDecoration(theme),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, 
                    color: _getTextColor(theme),
                  ),
                ),
                const SizedBox(width: AppSpacing.v8),
              ] else if (icon != null) ...[
                icon!,
                const SizedBox(width: AppSpacing.v8),
              ],
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: _getTextColor(theme),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    
    switch (type) {
      case SmartButtonType.primary:
        return BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case SmartButtonType.secondary:
        return BoxDecoration(
          color: colorScheme.surfaceContainerHighest, // Replaces surfaceHighlight
          borderRadius: BorderRadius.circular(12),
        );
      case SmartButtonType.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.primary, width: 1.5),
        );
    }
  }

  Color _getTextColor(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    
    switch (type) {
      case SmartButtonType.primary:
        return colorScheme.onPrimary;
      case SmartButtonType.secondary:
        return colorScheme.onSurface;
      case SmartButtonType.outline:
        return colorScheme.primary;
    }
  }
}
