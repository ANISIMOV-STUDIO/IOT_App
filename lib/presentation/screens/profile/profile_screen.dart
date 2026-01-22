/// Profile Screen - User profile and settings
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hvac_control/core/di/injection_container.dart' as di;
import 'package:hvac_control/core/navigation/app_router.dart';
import 'package:hvac_control/core/services/language_service.dart';
import 'package:hvac_control/core/services/theme_service.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/core/utils/snackbar_utils.dart';
import 'package:hvac_control/domain/entities/user_preferences.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_event.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_state.dart';
import 'package:hvac_control/presentation/screens/profile/profile_dialogs.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _ProfileScreenConstants {
  static const double avatarSize = 56;
  static const double initialsFontSize = 20;
  static const double buttonPaddingVertical = 14;
}

/// Profile screen with user info and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final themeService = di.sl<ThemeService>();
    final languageService = di.sl<LanguageService>();
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileUpdated) {
          SnackBarUtils.showSuccess(context, l10n.profileUpdated);
        } else if (state is AuthPasswordChanged) {
          SnackBarUtils.showSuccess(context, l10n.passwordChanged);
          context.go(AppRoutes.login);
        } else if (state is AuthError) {
          SnackBarUtils.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: colors.bg,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  BreezSectionHeader.pageTitle(
                    title: l10n.profile,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // User Info + Account Card
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (prev, curr) =>
                        prev.runtimeType != curr.runtimeType ||
                        (prev is AuthAuthenticated &&
                            curr is AuthAuthenticated &&
                            (prev.user.firstName != curr.user.firstName ||
                                prev.user.lastName != curr.user.lastName ||
                                prev.user.email != curr.user.email)),
                    builder: (context, state) {
                      if (state is AuthAuthenticated) {
                        return _UserCard(
                          firstName: state.user.firstName,
                          lastName: state.user.lastName,
                          email: state.user.email,
                          onEditProfile: () => _showEditProfileDialog(
                            context,
                            state.user.firstName,
                            state.user.lastName,
                          ),
                          onChangePassword: () => _showChangePasswordDialog(context),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Notifications Card
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (prev, curr) =>
                        prev is AuthAuthenticated &&
                        curr is AuthAuthenticated &&
                        prev.preferences != curr.preferences,
                    builder: (context, state) {
                      final prefs = state is AuthAuthenticated
                          ? state.preferences
                          : null;
                      return _NotificationsCard(
                        pushNotifications: prefs?.pushNotificationsEnabled ?? true,
                        emailNotifications: prefs?.emailNotificationsEnabled ?? true,
                        onPushChanged: (v) => context.read<AuthBloc>().add(
                              AuthUpdatePreferencesRequested(
                                pushNotificationsEnabled: v,
                              ),
                            ),
                        onEmailChanged: (v) => context.read<AuthBloc>().add(
                              AuthUpdatePreferencesRequested(
                                emailNotificationsEnabled: v,
                              ),
                            ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Settings Card
                  _SettingsCard(
                    themeService: themeService,
                    languageService: languageService,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Service Card (for engineers)
                  const _ServiceCard(),
                  const SizedBox(height: AppSpacing.sm),

                  // Logout Button
                  _LogoutButton(),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    String currentFirstName,
    String currentLastName,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => EditProfileDialog(
        firstName: currentFirstName,
        lastName: currentLastName,
        onSave: (firstName, lastName) {
          context.read<AuthBloc>().add(AuthUpdateProfileRequested(
                firstName: firstName,
                lastName: lastName,
              ));
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ChangePasswordDialog(
        onSave: (currentPassword, newPassword) {
          context.read<AuthBloc>().add(AuthChangePasswordRequested(
                currentPassword: currentPassword,
                newPassword: newPassword,
              ));
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }
}

/// User info card - горизонтальный layout с аватаром и действиями
class _UserCard extends StatelessWidget {

  const _UserCard({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.onEditProfile,
    required this.onChangePassword,
  });
  final String firstName;
  final String lastName;
  final String email;
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        children: [
          // User info row
          Row(
            children: [
              // Avatar
              Container(
                width: _ProfileScreenConstants.avatarSize,
                height: _ProfileScreenConstants.avatarSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.accent, AppColors.accentLight],
                  ),
                ),
                child: Center(
                  child: Text(
                    _getInitials(firstName, lastName),
                    style: const TextStyle(
                      fontSize: _ProfileScreenConstants.initialsFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Name & Email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName $lastName',
                      style: TextStyle(
                        fontSize: AppFontSizes.h4,
                        fontWeight: FontWeight.w600,
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // Actions as list tiles
          BreezSettingsTile(
            icon: Icons.edit_outlined,
            title: l10n.editProfile,
            onTap: onEditProfile,
          ),
          const SizedBox(height: AppSpacing.xs),
          BreezSettingsTile(
            icon: Icons.lock_outlined,
            title: l10n.changePassword,
            onTap: onChangePassword,
          ),
        ],
      ),
    );
  }

  String _getInitials(String firstName, String lastName) {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }
}

/// Service section card (for engineers)
class _ServiceCard extends StatelessWidget {
  const _ServiceCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreezSectionTitle(title: l10n.serviceEngineer),
          BreezSettingsTile(
            icon: Icons.history,
            title: l10n.eventLogs,
            onTap: () => context.goToEventLogs(),
          ),
        ],
      ),
    );
  }
}

/// Notifications settings card
class _NotificationsCard extends StatelessWidget {

  const _NotificationsCard({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.onPushChanged,
    required this.onEmailChanged,
  });
  final bool pushNotifications;
  final bool emailNotifications;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEmailChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreezSectionTitle(title: l10n.notifications),
          BreezSwitchTile(
            icon: Icons.notifications_outlined,
            title: l10n.pushNotifications,
            value: pushNotifications,
            onChanged: onPushChanged,
          ),
          const SizedBox(height: AppSpacing.xs),
          BreezSwitchTile(
            icon: Icons.email_outlined,
            title: l10n.emailNotifications,
            value: emailNotifications,
            onChanged: onEmailChanged,
          ),
        ],
      ),
    );
  }
}

/// App settings card (theme, language)
class _SettingsCard extends StatelessWidget {

  const _SettingsCard({
    required this.themeService,
    required this.languageService,
  });
  final ThemeService themeService;
  final LanguageService languageService;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreezSectionTitle(title: l10n.settings),
          // Theme Toggle
          ListenableBuilder(
            listenable: themeService,
            builder: (context, _) {
              final isDark = themeService.isDark;
              return BreezSwitchTile(
                icon: isDark ? Icons.dark_mode : Icons.light_mode,
                title: l10n.theme,
                subtitle: isDark ? l10n.darkThemeLabel : l10n.lightThemeLabel,
                value: isDark,
                onChanged: (_) {
                  themeService.toggleTheme();
                  // Синхронизация с бэкендом
                  final newTheme = themeService.isDark
                      ? PreferenceTheme.dark
                      : PreferenceTheme.light;
                  context.read<AuthBloc>().add(
                        AuthUpdatePreferencesRequested(
                          theme: newTheme.toApiString(),
                        ),
                      );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          // Language selector
          ListenableBuilder(
            listenable: languageService,
            builder: (context, _) {
              final currentLang = languageService.currentLanguage;
              return BreezSettingsTile(
                icon: Icons.language,
                title: l10n.language,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentLang.flag,
                      style: const TextStyle(fontSize: AppFontSizes.h4),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      currentLang.nativeName,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
                onTap: () => _showLanguagePickerAndSync(context, languageService),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Показать диалог выбора языка и синхронизировать с бэкендом
  Future<void> _showLanguagePickerAndSync(
    BuildContext context,
    LanguageService service,
  ) async {
    final previousLang = service.currentLanguage;
    await showLanguagePickerDialog(context, service);

    // Если язык изменился - синхронизируем с бэкендом
    if (service.currentLanguage != previousLang && context.mounted) {
      final newLang = service.currentLanguage.code == 'ru'
          ? PreferenceLanguage.russian
          : PreferenceLanguage.english;
      context.read<AuthBloc>().add(
            AuthUpdatePreferencesRequested(
              language: newLang.toApiString(),
            ),
          );
    }
  }
}

/// Logout button
class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BreezButton(
      onTap: () {
        context.read<AuthBloc>().add(const AuthLogoutRequested());
        rootNavigatorKey.currentContext?.go(AppRoutes.login);
      },
      backgroundColor: AppColors.critical.withValues(alpha: 0.1),
      hoverColor: AppColors.critical.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(
        vertical: _ProfileScreenConstants.buttonPaddingVertical,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.logout,
            size: AppIconSizes.standard,
            color: AppColors.critical,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            l10n.logout,
            style: const TextStyle(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: FontWeight.w600,
              color: AppColors.critical,
            ),
          ),
        ],
      ),
    );
  }
}
