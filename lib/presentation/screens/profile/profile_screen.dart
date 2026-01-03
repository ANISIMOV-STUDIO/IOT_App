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
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/utils/validators.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/breez/breez.dart';

/// Profile screen with user info and settings
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final themeService = di.sl<ThemeService>();
    final languageService = di.sl<LanguageService>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileUpdated) {
          SnackBarUtils.showSuccess(context, 'Профиль обновлён');
        } else if (state is AuthPasswordChanged) {
          SnackBarUtils.showSuccess(
            context,
            'Пароль изменён. Войдите снова.',
          );
          context.go(AppRoutes.login);
        } else if (state is AuthError) {
          SnackBarUtils.showError(context, state.message);
        }
      },
      child: Scaffold(
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
                                  decoration: const BoxDecoration(
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
                                const SizedBox(height: AppSpacing.lg),

                                // Edit Profile Button
                                BreezButton(
                                  onTap: () => _showEditProfileDialog(
                                    context,
                                    state.user.firstName,
                                    state.user.lastName,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  hoverColor: colors.buttonBg,
                                  border: Border.all(color: AppColors.accent),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                        color: AppColors.accent,
                                      ),
                                      SizedBox(width: AppSpacing.xs),
                                      Text(
                                        'Редактировать профиль',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.body,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    ],
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

                    // Account Card
                    BreezCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Аккаунт',
                            style: TextStyle(
                              fontSize: AppFontSizes.h4,
                              fontWeight: FontWeight.bold,
                              color: colors.text,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Change Password
                          _SettingsTile(
                            icon: Icons.lock_outlined,
                            title: 'Сменить пароль',
                            subtitle: 'Изменить пароль аккаунта',
                            onTap: () => _showChangePasswordDialog(context),
                          ),
                        ],
                      ),
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            size: 20,
                            color: AppColors.critical,
                          ),
                          SizedBox(width: AppSpacing.xs),
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
      ),
    );
  }

  String _getInitials(String firstName, String lastName) {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
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

/// Edit Profile Dialog
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
              // Header
              Row(
                children: [
                  const Icon(Icons.edit, color: AppColors.accent),
                  const SizedBox(width: 12),
                  Text(
                    'Редактировать профиль',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // First Name
              BreezTextField(
                controller: _firstNameController,
                label: 'Имя',
                prefixIcon: Icons.person_outlined,
                validator: Validators.name,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),

              // Last Name
              BreezTextField(
                controller: _lastNameController,
                label: 'Фамилия',
                prefixIcon: Icons.person_outlined,
                validator: Validators.name,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Отмена',
                      style: TextStyle(color: colors.textMuted),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Сохранить'),
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
              // Header
              Row(
                children: [
                  const Icon(Icons.lock, color: AppColors.accent),
                  const SizedBox(width: 12),
                  Text(
                    'Сменить пароль',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Current Password
              BreezTextField(
                controller: _currentPasswordController,
                label: 'Текущий пароль',
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: Validators.loginPassword,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),

              // New Password
              BreezTextField(
                controller: _newPasswordController,
                label: 'Новый пароль',
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: Validators.password,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),

              // Confirm Password
              BreezTextField(
                controller: _confirmPasswordController,
                label: 'Подтверждение пароля',
                prefixIcon: Icons.lock_outlined,
                obscureText: true,
                showPasswordToggle: true,
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Пароли не совпадают';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Отмена',
                      style: TextStyle(color: colors.textMuted),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Сменить'),
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
