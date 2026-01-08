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
import '../../../core/theme/spacing.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/breez/breez.dart';
import 'profile_dialogs.dart';

/// Profile screen with user info and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _alarmNotifications = true;

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
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Text(
                    l10n.profile,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // User Info Card
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
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Account Card
                  _AccountCard(
                    onChangePassword: () => _showChangePasswordDialog(context),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Notifications Card
                  _NotificationsCard(
                    pushNotifications: _pushNotifications,
                    emailNotifications: _emailNotifications,
                    alarmNotifications: _alarmNotifications,
                    onPushChanged: (v) => setState(() => _pushNotifications = v),
                    onEmailChanged: (v) => setState(() => _emailNotifications = v),
                    onAlarmChanged: (v) => setState(() => _alarmNotifications = v),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Settings Card
                  _SettingsCard(
                    themeService: themeService,
                    languageService: languageService,
                  ),
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
    showDialog(
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
    showDialog(
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

/// User info card with avatar and edit button
class _UserCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final VoidCallback onEditProfile;

  const _UserCard({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Name
          Text(
            '$firstName $lastName',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            email,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Edit Profile Button
          BreezActionButton(
            icon: Icons.edit_outlined,
            label: l10n.editProfile,
            onTap: onEditProfile,
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

/// Account settings card
class _AccountCard extends StatelessWidget {
  final VoidCallback onChangePassword;

  const _AccountCard({required this.onChangePassword});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: l10n.account, colors: colors),
          BreezSettingsTile(
            icon: Icons.lock_outlined,
            title: l10n.changePassword,
            onTap: onChangePassword,
          ),
        ],
      ),
    );
  }
}

/// Notifications settings card
class _NotificationsCard extends StatelessWidget {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool alarmNotifications;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onAlarmChanged;

  const _NotificationsCard({
    required this.pushNotifications,
    required this.emailNotifications,
    required this.alarmNotifications,
    required this.onPushChanged,
    required this.onEmailChanged,
    required this.onAlarmChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: l10n.notifications, colors: colors),
          BreezSwitchTile(
            icon: Icons.notifications_outlined,
            title: l10n.pushNotifications,
            value: pushNotifications,
            onChanged: onPushChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          BreezSwitchTile(
            icon: Icons.email_outlined,
            title: l10n.emailNotifications,
            value: emailNotifications,
            onChanged: onEmailChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          BreezSwitchTile(
            icon: Icons.warning_amber_outlined,
            title: l10n.alarmNotifications,
            value: alarmNotifications,
            onChanged: onAlarmChanged,
          ),
        ],
      ),
    );
  }
}

/// App settings card (theme, language)
class _SettingsCard extends StatelessWidget {
  final ThemeService themeService;
  final LanguageService languageService;

  const _SettingsCard({
    required this.themeService,
    required this.languageService,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: l10n.settings, colors: colors),
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
                onChanged: (_) => themeService.toggleTheme(),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
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
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      currentLang.nativeName,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
                onTap: () => showLanguagePickerDialog(context, languageService),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Section title widget
class _SectionTitle extends StatelessWidget {
  final String title;
  final BreezColors colors;

  const _SectionTitle({
    required this.title,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.textMuted,
        ),
      ),
    );
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
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.logout, size: 20, color: AppColors.critical),
          const SizedBox(width: 8),
          Text(
            l10n.logout,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.critical,
            ),
          ),
        ],
      ),
    );
  }
}
