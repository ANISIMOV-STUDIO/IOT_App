/// Forgot Password Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/utils/validators.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/breez/breez.dart';
import '../../widgets/breez/breez_pin_code_field.dart';

/// Экран восстановления пароля (2 шага)
class ForgotPasswordScreen extends StatefulWidget {
  /// Email (если передан из login формы)
  final String? initialEmail;

  const ForgotPasswordScreen({
    super.key,
    this.initialEmail,
  });

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
      context.read<AuthBloc>().add(
            AuthForgotPasswordRequested(email: _email),
          );
    }
  }

  void _handleResetPassword() {
    if (_code.length != 6) {
      setState(() => _errorText = 'Введите 6-значный код');
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
    context.read<AuthBloc>().add(
          AuthForgotPasswordRequested(email: _email),
        );
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

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetCodeSent) {
          // Переходим на шаг 2
          setState(() {
            _step = 1;
            _errorText = null;
          });
          SnackBarUtils.showSuccess(
            context,
            'Код отправлен на $_email',
          );
        } else if (state is AuthPasswordReset) {
          SnackBarUtils.showSuccess(
            context,
            'Пароль успешно изменён',
          );
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.text),
            onPressed: () {
              if (_step == 1) {
                setState(() => _step = 0);
              } else {
                context.go(AppRoutes.login);
              }
            },
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
                    ? _buildEmailStep(colors)
                    : _buildResetStep(colors),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Шаг 1: Ввод email
  Widget _buildEmailStep(BreezColors colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthHeader(title: 'ВОССТАНОВЛЕНИЕ ПАРОЛЯ'),
        const SizedBox(height: AppSpacing.xl),

        // Описание
        Text(
          'Введите email, указанный при регистрации.\nМы отправим код для сброса пароля.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Форма email
        BreezCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _emailFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BreezTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'example@mail.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: Validators.loginEmail,
                  validateOnChange: true,
                  autofillHints: const [AutofillHints.email],
                  onFieldSubmitted: (_) => _handleRequestCode(),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _errorText!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: AppFontSizes.caption,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return BreezButton(
                      onTap: isLoading ? null : _handleRequestCode,
                      isLoading: isLoading,
                      backgroundColor: AppColors.accent,
                      hoverColor: AppColors.accentLight,
                      height: AuthConstants.buttonHeight,
                      border: Border.all(color: Colors.transparent),
                      child: const Center(
                        child: Text(
                          'Отправить код',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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
  Widget _buildResetStep(BreezColors colors) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthHeader(title: 'НОВЫЙ ПАРОЛЬ'),
        const SizedBox(height: AppSpacing.xl),

        // Описание
        Text(
          'Введите код, отправленный на',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          _email,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.body,
            fontWeight: FontWeight.w600,
            color: colors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Поле для кода
        BreezPinCodeField(
          onCompleted: (code) {
            _code = code;
          },
          onChanged: _onCodeChanged,
          errorText: _errorText,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Форма нового пароля
        BreezCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _passwordFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BreezTextField(
                  controller: _passwordController,
                  label: 'Новый пароль',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: true,
                  showPasswordToggle: true,
                  validator: Validators.password,
                  validateOnChange: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),

                BreezTextField(
                  controller: _confirmPasswordController,
                  label: 'Подтверждение пароля',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: true,
                  showPasswordToggle: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Пароли не совпадают';
                    }
                    return null;
                  },
                  validateOnChange: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleResetPassword(),
                ),
                const SizedBox(height: AppSpacing.lg),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return BreezButton(
                      onTap: isLoading ? null : _handleResetPassword,
                      isLoading: isLoading,
                      backgroundColor: AppColors.accent,
                      hoverColor: AppColors.accentLight,
                      height: AuthConstants.buttonHeight,
                      border: Border.all(color: Colors.transparent),
                      child: const Center(
                        child: Text(
                          'Сменить пароль',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Кнопка повторной отправки
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return BreezTextButton(
              text: 'Отправить код повторно',
              onPressed: isLoading ? null : _handleResendCode,
            );
          },
        ),
      ],
    );
  }
}
