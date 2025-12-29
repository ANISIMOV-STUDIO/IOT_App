/// Profile Screen - User profile and settings
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection_container.dart' as di;
import '../../../core/navigation/app_router.dart';
import '../../../core/services/language_service.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/breez/breez_card.dart';

/// Profile screen with user info and settings
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final themeService = di.sl<ThemeService>();
    final languageService = di.sl<LanguageService>();

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Text(
                    'Профиль',
                    style: TextStyle(
                      fontSize: AppFontSizes.h2,
                      fontWeight: FontWeight.bold,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // User Info Card
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthAuthenticated) {
                        return BreezCard(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            children: [
                              // Avatar
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.accent,
                                      AppColors.accentLight,
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _getInitials(state.user.firstName, state.user.lastName),
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              // Name
                              Text(
                                '${state.user.firstName} ${state.user.lastName}',
                                style: TextStyle(
                                  fontSize: AppFontSizes.h3,
                                  fontWeight: FontWeight.bold,
                                  color: colors.text,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),

                              // Email
                              Text(
                                state.user.email,
                                style: TextStyle(
                                  fontSize: AppFontSizes.body,
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Theme Settings Card
                  BreezCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Настройки',
                          style: TextStyle(
                            fontSize: AppFontSizes.h4,
                            fontWeight: FontWeight.bold,
                            color: colors.text,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Theme Toggle
                        ListenableBuilder(
                          listenable: themeService,
                          builder: (context, _) {
                            final isDark = themeService.isDark;
                            return _SettingsTile(
                              icon: isDark ? Icons.dark_mode : Icons.light_mode,
                              title: 'Тема',
                              subtitle: isDark ? 'Темная' : 'Светлая',
                              onTap: themeService.toggleTheme,
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Language Toggle
                        ListenableBuilder(
                          listenable: languageService,
                          builder: (context, _) {
                            final isRussian = languageService.currentLocale?.languageCode == 'ru';
                            return _SettingsTile(
                              icon: Icons.language,
                              title: 'Язык',
                              subtitle: isRussian ? 'Русский' : 'English',
                              onTap: () {
                                languageService.setLocale(
                                  isRussian ? 'en' : 'ru',
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Logout Button
                  BreezButton(
                    onTap: () {
                      context.read<AuthBloc>().add(const AuthLogoutRequested());
                      rootNavigatorKey.currentContext?.go(AppRoutes.login);
                    },
                    backgroundColor: AppColors.critical.withValues(alpha: 0.1),
                    hoverColor: AppColors.critical.withValues(alpha: 0.2),
                    border: Border.all(
                      color: AppColors.critical.withValues(alpha: 0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.logout,
                          size: 20,
                          color: AppColors.critical,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Выйти',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w600,
                            color: AppColors.critical,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String firstName, String lastName) {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }
}

/// Settings tile widget
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: onTap,
      backgroundColor: Colors.transparent,
      hoverColor: colors.buttonBg,
      border: Border.all(color: colors.border),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Icon(
              icon,
              color: AppColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: FontWeight.w600,
                    color: colors.text,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: colors.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}
