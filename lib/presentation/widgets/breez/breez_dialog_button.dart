/// BREEZ Dialog Buttons - Buttons for dialogs and actions
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import 'breez_button.dart';

/// Dialog action button (primary/secondary with optional loading)
class BreezDialogButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool isLoading;
  final bool isDanger;

  const BreezDialogButton({
    super.key,
    required this.label,
    this.onTap,
    this.isPrimary = false,
    this.isLoading = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    final Color bgColor;
    final Color textColor;
    final Color hoverColor;
    final Color splashColor;

    if (isDanger) {
      bgColor = AppColors.accentRed;
      textColor = Colors.white;
      hoverColor = AppColors.accentRed.withValues(alpha: 0.8);
      splashColor = Colors.white.withValues(alpha: 0.2);
    } else if (isPrimary) {
      bgColor = AppColors.accent;
      textColor = Colors.white;
      hoverColor = AppColors.accentLight;
      splashColor = AppColors.accent.withValues(alpha: 0.3);
    } else {
      bgColor = Colors.transparent;
      textColor = colors.textMuted;
      hoverColor = colors.text.withValues(alpha: 0.05);
      splashColor = AppColors.accent.withValues(alpha: 0.1);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        hoverColor: hoverColor,
        splashColor: splashColor,
        highlightColor: splashColor.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: (isPrimary || isDanger) ? null : Border.all(color: colors.border),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: (isPrimary || isDanger) ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Action button with icon and accent border
///
/// Use for secondary actions like "Edit Profile", "Change Password"
class BreezActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const BreezActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BreezButton(
      onTap: onTap,
      backgroundColor: Colors.transparent,
      hoverColor: AppColors.accent.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(vertical: 12),
      border: Border.all(color: AppColors.accent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
