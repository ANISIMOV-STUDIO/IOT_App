/// Settings Screen - iOS 26 Liquid Glass Design
///
/// Modern settings with glass effect
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../../core/theme/liquid_glass_theme.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/language_service.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widgets/liquid_glass_container.dart';

class LiquidGlassSettingsScreen extends StatelessWidget {
  const LiquidGlassSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final themeService = sl<ThemeService>();
    final languageService = sl<LanguageService>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? LiquidGlassTheme.darkGradient
                : LiquidGlassTheme.lightGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.settings,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Settings list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Appearance Section
                    _SectionHeader(title: l10n.appearance),
                    const SizedBox(height: 12),

                    // Theme selector
                    LiquidGlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.palette_outlined,
                                size: 20,
                                color: LiquidGlassTheme.glassBlue,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.theme,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListenableBuilder(
                            listenable: themeService,
                            builder: (context, _) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: _ThemeOption(
                                      label: l10n.light,
                                      icon: Icons.light_mode,
                                      isSelected: themeService.themeMode == ThemeMode.light,
                                      onTap: () => themeService.setThemeMode(ThemeMode.light),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _ThemeOption(
                                      label: l10n.dark,
                                      icon: Icons.dark_mode,
                                      isSelected: themeService.themeMode == ThemeMode.dark,
                                      onTap: () => themeService.setThemeMode(ThemeMode.dark),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _ThemeOption(
                                      label: l10n.system,
                                      icon: Icons.auto_awesome,
                                      isSelected: themeService.themeMode == ThemeMode.system,
                                      onTap: () => themeService.setThemeMode(ThemeMode.system),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Language selector
                    LiquidGlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.language,
                                size: 20,
                                color: LiquidGlassTheme.glassTeal,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.language,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListenableBuilder(
                            listenable: languageService,
                            builder: (context, _) {
                              return Column(
                                children: [
                                  _LanguageOption(
                                    label: l10n.english,
                                    locale: const Locale('en'),
                                    isSelected: languageService.currentLocale?.languageCode == 'en',
                                    onTap: () => languageService.setLocale('en'),
                                  ),
                                  const SizedBox(height: 8),
                                  _LanguageOption(
                                    label: l10n.russian,
                                    locale: const Locale('ru'),
                                    isSelected: languageService.currentLocale?.languageCode == 'ru',
                                    onTap: () => languageService.setLocale('ru'),
                                  ),
                                  const SizedBox(height: 8),
                                  _LanguageOption(
                                    label: l10n.chinese,
                                    locale: const Locale('zh'),
                                    isSelected: languageService.currentLocale?.languageCode == 'zh',
                                    onTap: () => languageService.setLocale('zh'),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // About Section
                    _SectionHeader(title: l10n.about),
                    const SizedBox(height: 12),

                    LiquidGlassContainer(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  LiquidGlassTheme.glassBlue,
                                  LiquidGlassTheme.glassTeal,
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.air,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.appTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.version} 1.0.0',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.appDescription,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Account Section
                    const _SectionHeader(title: 'ACCOUNT'),
                    const SizedBox(height: 12),

                    // Logout button
                    LiquidGlassButton(
                      text: l10n.logout,
                      icon: Icons.logout,
                      width: double.infinity,
                      color: LiquidGlassTheme.glassRed,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => _LogoutDialog(),
                        );
                      },
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 12,
              letterSpacing: 1.5,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.symmetric(vertical: 12),
      gradient: isSelected
          ? [
              LiquidGlassTheme.glassBlue,
              LiquidGlassTheme.glassTeal,
            ]
          : null,
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected
                ? Colors.white
                : Theme.of(context).iconTheme.color,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(16),
      gradient: isSelected
          ? [
              LiquidGlassTheme.glassTeal,
              LiquidGlassTheme.glassGreen,
            ]
          : null,
      onTap: onTap,
      child: Row(
        children: [
          if (isSelected)
            const Icon(
              Icons.check_circle,
              size: 20,
              color: Colors.white,
            )
          else
            Icon(
              Icons.circle_outlined,
              size: 20,
              color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.3),
            ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: LiquidGlassContainer(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    LiquidGlassTheme.glassRed,
                    LiquidGlassTheme.glassOrange,
                  ],
                ),
              ),
              child: const Icon(
                Icons.logout,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.logout,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to logout?',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: LiquidGlassButton(
                    text: l10n.cancel,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LiquidGlassButton(
                    text: l10n.logout,
                    color: LiquidGlassTheme.glassRed,
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AuthBloc>().add(const LogoutEvent());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
