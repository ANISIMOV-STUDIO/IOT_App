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
import '../../../generated/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final colors = BreezColors.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthEmailVerified) {
          SnackBarUtils.showSuccess(context, 'Email успешно подтверждён');
          // Автоматический вход после подтверждения email
          context.read<AuthBloc>().add(
                AuthLoginRequested(
                  email: widget.email,
                  password: widget.password,
                ),
              );
        } else if (state is AuthAuthenticated) {
          // Успешный вход после верификации
          WidgetsBinding.instance.addPostFrameCallback((_) {
            rootNavigatorKey.currentContext?.go(AppRoutes.home);
          });
        } else if (state is AuthCodeResent) {
          SnackBarUtils.showSuccess(context, l10n.verifyEmailCodeSent);
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
                    AuthHeader(title: l10n.verifyEmailTitle),
                    const SizedBox(height: AppSpacing.xl),

                    // Описание
                    Text(
                      l10n.verifyEmailSent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        color: colors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
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
                      buildWhen: (prev, curr) => (prev is AuthLoading) != (curr is AuthLoading),
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: BreezTextButton(
                            text: l10n.verifyEmailResend,
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
