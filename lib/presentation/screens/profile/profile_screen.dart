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
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/utils/validators.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/breez/breez.dart';

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
                    builder: (context, state) {
                      if (state is AuthAuthenticated) {
                        return _buildUserCard(context, state, l10n);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Account Card
                  _buildAccountCard(context, l10n),
                  const SizedBox(height: AppSpacing.sm),

                  // Notifications Card
                  _buildNotificationsCard(context, l10n),
                  const SizedBox(height: AppSpacing.sm),

                  // Settings Card
                  _buildSettingsCard(context, themeService, languageService, l10n),
                  const SizedBox(height: AppSpacing.sm),

                  // Logout Button
                  _buildLogoutButton(context, l10n),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, AuthAuthenticated state, AppLocalizations l10n) {
    final colors = BreezColors.of(context);

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
                _getInitials(state.user.firstName, state.user.lastName),
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
            '${state.user.firstName} ${state.user.lastName}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            state.user.email,
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
            onTap: () => _showEditProfileDialog(
              context,
              state.user.firstName,
              state.user.lastName,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AppLocalizations l10n) {
    final colors = BreezColors.of(context);

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
            child: Text(
              l10n.account,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
          ),
          BreezSettingsTile(
            icon: Icons.lock_outlined,
            title: l10n.changePassword,
            onTap: () => _showChangePasswordDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard(BuildContext context, AppLocalizations l10n) {
    final colors = BreezColors.of(context);

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
            child: Text(
              l10n.notifications,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
          ),
          BreezSwitchTile(
            icon: Icons.notifications_outlined,
            title: l10n.pushNotifications,
            value: _pushNotifications,
            onChanged: (v) => setState(() => _pushNotifications = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          BreezSwitchTile(
            icon: Icons.email_outlined,
            title: l10n.emailNotifications,
            value: _emailNotifications,
            onChanged: (v) => setState(() => _emailNotifications = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          BreezSwitchTile(
            icon: Icons.warning_amber_outlined,
            title: l10n.alarmNotifications,
            value: _alarmNotifications,
            onChanged: (v) => setState(() => _alarmNotifications = v),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    ThemeService themeService,
    LanguageService languageService,
    AppLocalizations l10n,
  ) {
    final colors = BreezColors.of(context);

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.sm),
            child: Text(
              l10n.settings,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
          ),
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
          // Выбор языка
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
                onTap: () => _showLanguagePickerDialog(context, languageService),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l10n) {
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

  String _getInitials(String firstName, String lastName) {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  /// Диалог выбора языка приложения
  void _showLanguagePickerDialog(
    BuildContext context,
    LanguageService languageService,
  ) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        titlePadding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.sm,
          0,
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.sm),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          0,
          AppSpacing.sm,
          AppSpacing.sm,
        ),
        title: Text(
          l10n.language,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textMuted,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.sm,
          children: [
            for (final language in languageService.availableLanguages)
              _LanguageOption(
                language: language,
                isSelected: languageService.currentLanguage == language,
                onTap: () {
                  languageService.setLanguage(language);
                  Navigator.of(dialogContext).pop();
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: colors.textMuted),
            ),
          ),
        ],
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
      builder: (dialogContext) => _EditProfileDialog(
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
      builder: (dialogContext) => _ChangePasswordDialog(
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

/// Опция выбора языка в диалоге
class _LanguageOption extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accent.withValues(alpha: 0.1)
                : colors.cardLight,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: isSelected
                ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              Text(
                language.flag,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  language.nativeName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? AppColors.accent : colors.text,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.accent,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Диалог редактирования профиля
class _EditProfileDialog extends StatefulWidget {
  final String firstName;
  final String lastName;
  final void Function(String firstName, String lastName) onSave;

  const _EditProfileDialog({
    required this.firstName,
    required this.lastName,
    required this.onSave,
  });

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit, color: AppColors.accent),
                  const SizedBox(width: 12),
                  Text(
                    l10n.editProfile,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              BreezTextField(
                controller: _firstNameController,
                label: l10n.firstName,
                prefixIcon: Icons.person_outlined,
                validator: (v) => Validators.of(context).name(v, fieldName: l10n.firstName),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              BreezTextField(
                controller: _lastNameController,
                label: l10n.lastName,
                prefixIcon: Icons.person_outlined,
                validator: (v) => Validators.of(context).name(v, fieldName: l10n.lastName),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel, style: TextStyle(color: colors.textMuted)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(l10n.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Change Password Dialog
class _ChangePasswordDialog extends StatefulWidget {
  final void Function(String currentPassword, String newPassword) onSave;

  const _ChangePasswordDialog({required this.onSave});

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        _currentPasswordController.text,
        _newPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.lock, color: AppColors.accent),
                  const SizedBox(width: 12),
                  Text(
                    l10n.changePassword,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              BreezTextField(
                controller: _currentPasswordController,
                label: l10n.currentPassword,
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: Validators.of(context).loginPassword,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              BreezTextField(
                controller: _newPasswordController,
                label: l10n.newPassword,
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: Validators.of(context).password,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              BreezTextField(
                controller: _confirmPasswordController,
                label: l10n.passwordConfirmation,
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: (value) => Validators.of(context).confirmPassword(
                  value,
                  _newPasswordController.text,
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel, style: TextStyle(color: colors.textMuted)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(l10n.change),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
