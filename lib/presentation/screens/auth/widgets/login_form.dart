/// Login Form Widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hvac_control/core/constants/auth_constants.dart';
import 'package:hvac_control/core/navigation/app_router.dart';
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

class LoginForm extends StatefulWidget {

  const LoginForm({
    required this.onSwitchToRegister,
    super.key,
  });
  final VoidCallback onSwitchToRegister;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
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
        const BreezLogo(
          iconSize: 56,
          titleSize: 28,
          subtitleSize: 10,
          spacing: 12,
        ),
        const SizedBox(height: AppSpacing.xl),

        // Карточка с формой
        BreezCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Email
                  BreezTextField(
                    controller: _emailController,
                    label: l10n.email,
                    hint: 'example@mail.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: validators.loginEmail,
                    validateOnChange: true,
                    autofillHints: const [AutofillHints.username, AutofillHints.email],
                    onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Пароль
                  BreezTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    label: l10n.password,
                    prefixIcon: Icons.lock_outlined,
                    obscureText: true,
                    validator: validators.loginPassword,
                    showPasswordToggle: true,
                    validateOnChange: true,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                  ),
                const SizedBox(height: AppSpacing.xs),

                // Восстановить пароль
                Align(
                  alignment: Alignment.centerRight,
                  child: BreezButton(
                    onTap: () {
                      final email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        context.go('${AppRoutes.forgotPassword}?email=$email');
                      } else {
                        context.go(AppRoutes.forgotPassword);
                      }
                    },
                    backgroundColor: Colors.transparent,
                    showBorder: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs,
                    ),
                    child: Text(
                      l10n.forgotPassword,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: AppFontSizes.caption,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Кнопка входа
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return BreezButton(
                      onTap: isLoading ? null : _handleLogin,
                      isLoading: isLoading,
                      backgroundColor: AppColors.accent,
                      hoverColor: AppColors.accentLight,
                      height: AuthConstants.buttonHeight,
                      border: Border.all(color: Colors.transparent),
                      child: Center(
                        child: Text(
                          l10n.login,
                          style: const TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Регистрация
                AuthActionLink(
                  text: l10n.noAccount,
                  actionText: l10n.register,
                  onTap: widget.onSwitchToRegister,
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
