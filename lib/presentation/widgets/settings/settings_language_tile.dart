/// Settings Language Tile
///
/// Radio button tile for language selection
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Language selection tile widget
class SettingsLanguageTile extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const SettingsLanguageTile({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HvacInteractiveScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? HvacColors.primaryOrange.withValues(alpha: 0.1)
              : HvacColors.backgroundDark,
          borderRadius: HvacRadius.mdRadius,
          border: Border.all(
            color: isSelected
                ? HvacColors.primaryOrange
                : HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? HvacColors.primaryOrange
                  : HvacColors.textSecondary,
              size: 20.0,
            ),
            const SizedBox(width: 12.0),
            Text(
              language,
              style: HvacTypography.bodyMedium.copyWith(
                fontSize: 14.0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? HvacColors.primaryOrange
                    : HvacColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0));
  }
}
