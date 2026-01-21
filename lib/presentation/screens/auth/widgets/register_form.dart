/// Register Form Widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/core/utils/snackbar_utils.dart';
import 'package:hvac_control/core/utils/validators.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_event.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_state.dart';
import 'package:hvac_control/presentation/widgets/auth/auth_action_link.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';

class RegisterForm extends StatefulWidget {

  const RegisterForm({
    required this.onSwitchToLogin, super.key,
  });
  final VoidCallback onSwitchToLogin;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _consentAccepted = false;

  // FocusNodes для навигации по Enter
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _handleRegister(AppLocalizations l10n) {
    if (!_consentAccepted) {
      SnackBarUtils.showWarning(
        context,
        l10n.consentRequired,
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              dataProcessingConsent: _consentAccepted,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final validators = Validators.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          SnackBarUtils.showError(context, state.message);
        }
      },
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Логотип
        const BreezLogo.compact(),
        const SizedBox(height: AppSpacing.xs),

        // Карточка с формой
        BreezCard(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Имя
                  BreezTextField(
                    controller: _firstNameController,
                    label: l10n.firstName,
                    hint: 'Ivan',
                    prefixIcon: Icons.person_outline,
                    validator: (v) => validators.name(v, fieldName: l10n.firstName),
                    validateOnChange: true,
                    autofillHints: const [AutofillHints.givenName],
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _lastNameFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Фамилия
                  BreezTextField(
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
                    label: l10n.lastName,
                    hint: 'Ivanov',
                    prefixIcon: Icons.person_outline,
                    validator: (v) => validators.name(v, fieldName: l10n.lastName),
                    validateOnChange: true,
                    autofillHints: const [AutofillHints.familyName],
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Email
                  BreezTextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    label: l10n.email,
                    hint: 'example@mail.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: validators.email,
                    validateOnChange: true,
                    autofillHints: const [AutofillHints.username, AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Пароль
                  BreezTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    label: l10n.password,
                    hint: l10n.passwordHint,
                    prefixIcon: Icons.lock_outlined,
                    obscureText: true,
                    validator: validators.password,
                    showPasswordToggle: true,
                    validateOnChange: true,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Подтверждение пароля
                  BreezTextField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    label: l10n.confirmPassword,
                    prefixIcon: Icons.lock_outlined,
                    obscureText: true,
                    validator: (v) => validators.confirmPassword(
                      v,
                      _passwordController.text,
                    ),
                    showPasswordToggle: true,
                    validateOnChange: true,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleRegister(l10n),
                  ),
                const SizedBox(height: AppSpacing.xs),

                // Согласие на обработку ПД
                BreezCheckbox(
                  value: _consentAccepted,
                  onChanged: (value) {
                    setState(() => _consentAccepted = value);
                  },
                  label: l10n.consentLabel,
                ),
                const SizedBox(height: AppSpacing.xs),

                // Кнопка регистрации
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (prev, curr) => (prev is AuthLoading) != (curr is AuthLoading),
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return BreezButton(
                      onTap: isLoading ? null : () => _handleRegister(l10n),
                      isLoading: isLoading,
                      backgroundColor: AppColors.accent,
                      hoverColor: AppColors.accentLight,
                      showBorder: false,
                      borderRadius: AppRadius.nested,
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      enableGlow: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_add,
                            size: AppSpacing.md,
                            color: AppColors.black,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            l10n.register,
                            style: const TextStyle(
                              fontSize: AppFontSizes.caption,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xs),

                // Уже есть аккаунт
                AuthActionLink(
                  text: l10n.haveAccount,
                  actionText: l10n.login,
                  onTap: widget.onSwitchToLogin,
                ),
                ],
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }
}
