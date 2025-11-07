/// Language Settings Section
///
/// Language selection and localization settings
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'settings_section.dart';

class LanguageSection extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSection({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SettingsSection(
      title: l10n.language,
      icon: Icons.language_outlined,
      children: [
        _LanguageTile(
          language: l10n.russian,
          isSelected: selectedLanguage == l10n.russian,
          onTap: () => onLanguageChanged(l10n.russian),
        ),
        SizedBox(height: 8.h),
        _LanguageTile(
          language: l10n.english,
          isSelected: selectedLanguage == l10n.english,
          onTap: () => onLanguageChanged(l10n.english),
        ),
        SizedBox(height: 8.h),
        _LanguageTile(
          language: l10n.german,
          isSelected: selectedLanguage == l10n.german,
          onTap: () => onLanguageChanged(l10n.german),
        ),
      ],
    );
  }
}

/// Language Selection Tile
class _LanguageTile extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: language,
      selected: isSelected,
      hint: 'Tap to select this language',
      child: HvacInteractiveScale(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? HvacColors.primaryOrange.withValues(alpha: 0.1)
                : HvacColors.backgroundDark,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected
                  ? HvacColors.primaryOrange
                  : HvacColors.backgroundCardBorder,
              width: 1.w,
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
                size: 20.w,
              ),
              SizedBox(width: 12.w),
              Text(
                language,
                style: HvacTypography.bodyMedium.copyWith(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? HvacColors.primaryOrange
                      : HvacColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check,
                  color: HvacColors.primaryOrange,
                  size: 18.w,
                ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
        );
  }
}