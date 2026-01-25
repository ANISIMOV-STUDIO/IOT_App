/// Forgot Password Screen
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
import 'package:hvac_control/presentation/widgets/auth/auth_header.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';

/// Экран восстановления пароля (2 шага)
class ForgotPasswordScreen extends StatefulWidget {

  const ForgotPasswordScreen({super.key, this.initialEmail});
  /// Email (если передан из login формы)
  final String? initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Шаг: 0 = ввод email, 1 = ввод кода и пароля
  int _step = 0;
  String _email = '';
  String? _errorText;

  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _code = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null && widget.initialEmail!.isNotEmpty) {
      _emailController.text = widget.initialEmail!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRequestCode() {
    if (_emailFormKey.currentState?.validate() ?? false) {
      _email = _emailController.text.trim();
      setState(() => _errorText = null);
      context.read<AuthBloc>().add(AuthForgotPasswordRequested(email: _email));
    }
  }

  void _handleResetPassword(AppLocalizations l10n) {
    if (_code.length != 6) {
      setState(() => _errorText = l10n.enterSixDigitCode);
      return;
    }
    if (_passwordFormKey.currentState?.validate() ?? false) {
      setState(() => _errorText = null);
      context.read<AuthBloc>().add(
        AuthResetPasswordRequested(
          email: _email,
          code: _code,
          newPassword: _passwordController.text,
        ),
      );
    }
  }

  void _handleResendCode() {
    setState(() => _errorText = null);
    context.read<AuthBloc>().add(AuthForgotPasswordRequested(email: _email));
  }

  void _onCodeChanged(String code) {
    _code = code;
    if (_errorText != null) {
      setState(() => _errorText = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetCodeSent) {
          // Переходим на шаг 2
          setState(() {
            _step = 1;
            _errorText = null;
          });
          SnackBarUtils.showSuccess(context, l10n.codeSentTo(_email));
        } else if (state is AuthPasswordReset) {
          SnackBarUtils.showSuccess(context, l10n.passwordChangedSuccess);
          // Возвращаемся на логин
          context.go(AppRoutes.login);
        } else if (state is AuthError) {
          setState(() => _errorText = state.message);
        }
      },
      child: Scaffold(
        backgroundColor: colors.bg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BreezIconButton(
            icon: Icons.arrow_back,
            iconColor: colors.text,
            backgroundColor: Colors.transparent,
            showBorder: false,
            compact: true,
            onTap: () {
              if (_step == 1) {
                setState(() => _step = 0);
              } else {
                context.go(AppRoutes.login);
              }
            },
            semanticLabel: 'Back',
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AuthConstants.formMaxWidth,
                ),
                child: _step == 0
                    ? _buildEmailStep(colors, l10n)
                    : _buildResetStep(colors, l10n),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Шаг 1: Ввод email
  Widget _buildEmailStep(BreezColors colors, AppLocalizations l10n) {
    final validators = Validators.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: BreezLogo.compact()),
        const SizedBox(height: AppSpacing.xs),

        // Описание
        Text(
          l10n.enterEmailForReset,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Форма email
        BreezCard(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Form(
            key: _emailFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BreezTextField(
                  controller: _emailController,
                  label: l10n.email,
                  hint: 'example@mail.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: validators.loginEmail,
                  validateOnChange: true,
                  autofillHints: const [AutofillHints.email],
                  onFieldSubmitted: (_) => _handleRequestCode(),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _errorText!,
                    style: const TextStyle(
                      color: AppColors.accentRed,
                      fontSize: AppFontSizes.caption,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),

                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (prev, curr) =>
                      (prev is AuthLoading) != (curr is AuthLoading),
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return BreezButton(
                      onTap: isLoading ? null : _handleRequestCode,
                      isLoading: isLoading,
                      backgroundColor: colors.accent,
                      hoverColor: colors.accentLight,
                      showBorder: false,
                      borderRadius: AppRadius.nested,
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      enableGlow: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.send,
                            size: AppSpacing.md,
                            color: AppColors.black,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            l10n.sendCode,
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Шаг 2: Ввод кода и нового пароля
  Widget _buildResetStep(BreezColors colors, AppLocalizations l10n) {
    final validators = Validators.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthHeader(title: l10n.newPassword),
        const SizedBox(height: AppSpacing.xs),

        // Описание
        Text(
          l10n.enterCodeSentTo,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          _email,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            fontWeight: FontWeight.w600,
            color: colors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Поле для кода
        BreezPinCodeField(
          onCompleted: (code) {
            _code = code;
          },
          onChanged: _onCodeChanged,
          errorText: _errorText,
        ),
        const SizedBox(height: AppSpacing.xs),

        // Форма нового пароля
        BreezCard(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Form(
            key: _passwordFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BreezTextField(
                  controller: _passwordController,
                  label: l10n.newPassword,
                  prefixIcon: Icons.lock_outlined,
                  obscureText: true,
                  showPasswordToggle: true,
                  validator: validators.password,
                  validateOnChange: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.xs),

                BreezTextField(
                  controller: _confirmPasswordController,
                  label: l10n.passwordConfirmation,
                  prefixIcon: Icons.lock_outlined,
                  obscureText: true,
                  showPasswordToggle: true,
                  validator: (value) => validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  validateOnChange: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleResetPassword(l10n),
                ),
                const SizedBox(height: AppSpacing.xs),

                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (prev, curr) =>
                      (prev is AuthLoading) != (curr is AuthLoading),
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return BreezButton(
                      onTap: isLoading
                          ? null
                          : () => _handleResetPassword(l10n),
                      isLoading: isLoading,
                      backgroundColor: colors.accent,
                      hoverColor: colors.accentLight,
                      showBorder: false,
                      borderRadius: AppRadius.nested,
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      enableGlow: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lock_reset,
                            size: AppSpacing.md,
                            color: AppColors.black,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            l10n.changePassword,
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
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // Кнопка повторной отправки
        Center(
          child: BreezLink(
            text: l10n.resendCode,
            onTap: () {
              final bloc = context.read<AuthBloc>();
              if (bloc.state is! AuthLoading) {
                _handleResendCode();
              }
            },
          ),
        ),
      ],
    );
  }
}
