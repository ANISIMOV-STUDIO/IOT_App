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
          language: 'English',
          isSelected: selectedLanguage == 'English',
          onTap: () => onLanguageChanged('English'),
        ),
        const SizedBox(height: 8),
        _LanguageTile(
          language: 'Русский',
          isSelected: selectedLanguage == 'Русский',
          onTap: () => onLanguageChanged('Русский'),
        ),
        const SizedBox(height: 8),
        _LanguageTile(
          language: '中文',
          isSelected: selectedLanguage == '中文',
          onTap: () => onLanguageChanged('中文'),
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
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? HvacColors.primaryOrange.withValues(alpha: 0.1)
                : HvacColors.backgroundDark,
            borderRadius: BorderRadius.circular(8),
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
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                language,
                style: HvacTypography.bodyMedium.copyWith(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? HvacColors.primaryOrange
                      : HvacColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(
                  Icons.check,
                  color: HvacColors.primaryOrange,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
        );
  }
}
