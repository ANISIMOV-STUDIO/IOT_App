/// Register Screen - BREEZ Style
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/auth/auth_action_link.dart';
import '../../widgets/breez/breez_card.dart';
import '../../widgets/breez/breez_text_field.dart';
import '../../widgets/breez/breez_checkbox.dart';
import '../../widgets/breez/breez_logo.dart';
import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_utils.dart';

/// Экран регистрации
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _consentAccepted = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_consentAccepted) {
      SnackBarUtils.showWarning(
        context,
        'Необходимо согласие на обработку персональных данных',
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
    final colors = BreezColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistered) {
            // После регистрации требуется подтверждение email
            context.goToVerifyEmail(state.email, password: state.password);
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
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Имя
                          BreezTextField(
                            controller: _firstNameController,
                            label: 'Имя',
                            hint: 'Иван',
                            prefixIcon: Icons.person_outline,
                            validator: (v) => Validators.name(v, fieldName: 'имя'),
                            validateOnChange: true,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Фамилия
                          BreezTextField(
                            controller: _lastNameController,
                            label: 'Фамилия',
                            hint: 'Иванов',
                            prefixIcon: Icons.person_outline,
                            validator: (v) =>
                                Validators.name(v, fieldName: 'фамилию'),
                            validateOnChange: true,
                          ),
                          const SizedBox(height: AppSpacing.md),

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
                            hint: 'Минимум 8 символов, буквы и цифры',
                            prefixIcon: Icons.lock_outlined,
                            validator: Validators.password,
                            showPasswordToggle: true,
                            validateOnChange: true,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Подтверждение пароля
                          BreezTextField(
                            controller: _confirmPasswordController,
                            label: 'Подтвердите пароль',
                            prefixIcon: Icons.lock_outlined,
                            validator: (v) => Validators.confirmPassword(
                              v,
                              _passwordController.text,
                            ),
                            showPasswordToggle: true,
                            validateOnChange: true,
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Согласие на обработку ПД
                          BreezCheckbox(
                            value: _consentAccepted,
                            onChanged: (value) {
                              setState(() => _consentAccepted = value);
                            },
                            label: 'Я согласен на обработку персональных данных',
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Кнопка регистрации
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;

                              return BreezButton(
                                onTap: isLoading ? null : _handleRegister,
                                isLoading: isLoading,
                                backgroundColor: AppColors.accent,
                                hoverColor: AppColors.accentLight,
                                height: AuthConstants.buttonHeight,
                                border: Border.all(color: Colors.transparent),
                                child: const Center(
                                  child: Text(
                                    'Зарегистрироваться',
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

                          // Уже есть аккаунт
                          AuthActionLink(
                            text: 'Уже есть аккаунт?',
                            actionText: 'Войти',
                            onTap: () => context.pop(),
                          ),
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
