/// Auth Screen - Unified Login/Register with animated transitions
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/constants/auth_constants.dart';
import '../../../core/navigation/app_router.dart';
import 'widgets/login_form.dart';
import 'widgets/register_form.dart';

/// Единый экран авторизации с переключением между формами
class AuthScreen extends StatefulWidget {
  final bool isRegister;

  const AuthScreen({
    super.key,
    this.isRegister = false,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isRegister;

  @override
  void initState() {
    super.initState();
    _isRegister = widget.isRegister;
  }

  void _toggleMode() {
    setState(() {
      _isRegister = !_isRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated || state is AuthSkipped) {
            if (mounted) {
              // Небольшая задержка чтобы токен успел сохраниться
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  context.go('/');
                }
              });
            }
          } else if (state is AuthRegistered) {
            if (mounted) {
              context.go(
                '${AppRoutes.verifyEmail}?email=${Uri.encodeComponent(state.email)}',
                extra: state.password,
              );
            }
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AuthConstants.formMaxWidth,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.05),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _isRegister
                    ? RegisterForm(
                        key: const ValueKey('register'),
                        onSwitchToLogin: _toggleMode,
                      )
                    : LoginForm(
                        key: const ValueKey('login'),
                        onSwitchToRegister: _toggleMode,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
