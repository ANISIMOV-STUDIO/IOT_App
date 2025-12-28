/// Login Screen - BREEZ Style
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_action_link.dart';
import '../../widgets/breez/breez_card.dart';
import '../../widgets/breez/breez_text_field.dart';
import '../../../core/constants/auth_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_utils.dart';

/// Экран входа в систему
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _handleSkip() {
    context.read<AuthBloc>().add(const AuthSkipRequested());
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated || state is AuthSkipped) {
            context.go('/');
          } else if (state is AuthError) {
            SnackBarUtils.showError(context, state.message);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AuthConstants.formMaxWidth,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Логотип и заголовок
                  const AuthHeader(title: 'Вход'),
                  const SizedBox(height: AppSpacing.xl),

                  // Карточка с формой
                  BreezCard(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email
                          BreezTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'example@mail.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                            validateOnChange: true,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Пароль
                          BreezTextField(
                            controller: _passwordController,
                            label: 'Пароль',
                            prefixIcon: Icons.lock_outlined,
                            validator: Validators.password,
                            showPasswordToggle: true,
                            validateOnChange: true,
                          ),
                          const SizedBox(height: AppSpacing.xs),

                          // Восстановить пароль
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                SnackBarUtils.showInfo(
                                  context,
                                  'Функция восстановления пароля в разработке',
                                );
                              },
                              child: const Text(
                                'Забыли пароль?',
                                style: TextStyle(
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
                                child: const Center(
                                  child: Text(
                                    'Войти',
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
                          const SizedBox(height: AppSpacing.md),

                          // Регистрация
                          AuthActionLink(
                            text: 'Нет аккаунта?',
                            actionText: 'Зарегистрироваться',
                            onTap: () => context.push('/register'),
                          ),

                          // Dev: Пропустить
                          if (const bool.fromEnvironment('dart.vm.product') ==
                              false) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Divider(color: colors.border),
                            const SizedBox(height: AppSpacing.sm),
                            BreezButton(
                              onTap: _handleSkip,
                              backgroundColor:
                                  AppColors.warning.withValues(alpha: 0.1),
                              hoverColor:
                                  AppColors.warning.withValues(alpha: 0.2),
                              border: Border.all(
                                color: AppColors.warning.withValues(alpha: 0.3),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.developer_mode,
                                    size: 16,
                                    color: AppColors.warning,
                                  ),
                                  SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'Пропустить (dev)',
                                    style: TextStyle(
                                      fontSize: AppFontSizes.bodySmall,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.warning,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
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
}
