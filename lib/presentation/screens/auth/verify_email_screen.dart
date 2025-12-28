/// Экран подтверждения email
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/breez/breez_text_field.dart';
import '../../widgets/breez/breez_card.dart';

/// Экран подтверждения email с вводом 6-значного кода
class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleVerify() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthVerifyEmailRequested(
              email: widget.email,
              code: _codeController.text.trim(),
            ),
          );
    }
  }

  void _handleResendCode() {
    context.read<AuthBloc>().add(
          AuthResendCodeRequested(
            email: widget.email,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthEmailVerified) {
          SnackBarUtils.showSuccess(context, 'Email успешно подтверждён');
          context.go(AppRoutes.home);
        } else if (state is AuthCodeResent) {
          SnackBarUtils.showSuccess(context, 'Код отправлен на email');
        } else if (state is AuthError) {
          SnackBarUtils.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: colors.bg,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AuthConstants.formMaxWidth,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AuthHeader(title: 'ПОДТВЕРЖДЕНИЕ EMAIL'),
                      const SizedBox(height: AppSpacing.xl),

                      // Описание
                      Text(
                        'Мы отправили 6-значный код подтверждения на',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        widget.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.text,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Поле для кода
                      BreezTextField(
                        controller: _codeController,
                        label: 'КОД ПОДТВЕРЖДЕНИЯ',
                        hint: 'Введите 6-значный код',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите код подтверждения';
                          }
                          if (value.length != 6) {
                            return 'Код должен содержать 6 цифр';
                          }
                          if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                            return 'Код должен содержать только цифры';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Кнопка подтверждения
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;

                          return BreezButton(
                            onTap: isLoading ? null : _handleVerify,
                            height: AuthConstants.buttonHeight,
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('ПОДТВЕРДИТЬ'),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Кнопка повторной отправки
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;

                          return GestureDetector(
                            onTap: isLoading ? null : _handleResendCode,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Отправить код повторно',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isLoading
                                      ? colors.textMuted
                                      : AppColors.accent,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Кнопка "Позже"
                      GestureDetector(
                        onTap: () => context.go('/'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Подтвердить позже',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.textMuted,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
