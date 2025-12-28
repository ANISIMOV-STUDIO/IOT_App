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
import '../../widgets/breez/breez_pin_code_field.dart';
import '../../widgets/breez/breez_text_button.dart';

/// Экран подтверждения email с вводом 6-значного кода
class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String password;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String? _errorText;

  void _handleVerify(String code) {
    setState(() => _errorText = null);
    context.read<AuthBloc>().add(
          AuthVerifyEmailRequested(
            email: widget.email,
            code: code,
          ),
        );
  }

  void _handleResendCode() {
    setState(() => _errorText = null);
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
          if (mounted) {
            SnackBarUtils.showSuccess(context, 'Email успешно подтверждён');
            // Автоматический вход после подтверждения email
            context.read<AuthBloc>().add(
                  AuthLoginRequested(
                    email: widget.email,
                    password: widget.password,
                  ),
                );
          }
        } else if (state is AuthAuthenticated) {
          // Успешный вход после верификации
          if (mounted) {
            context.go(AppRoutes.home);
          }
        } else if (state is AuthCodeResent) {
          if (mounted) {
            SnackBarUtils.showSuccess(context, 'Код отправлен на email');
          }
        } else if (state is AuthError) {
          if (mounted) {
            setState(() => _errorText = state.message);
          }
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
                    const SizedBox(height: AppSpacing.xxl),

                    // Поле для кода с отдельными ячейками
                    BreezPinCodeField(
                      onCompleted: _handleVerify,
                      errorText: _errorText,
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Кнопка повторной отправки
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: BreezTextButton(
                            text: 'Отправить код повторно',
                            onPressed: isLoading ? null : _handleResendCode,
                          ),
                        );
                      },
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
}
