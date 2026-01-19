/// Auth Screen - Unified Login/Register with animated transitions
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hvac_control/core/constants/auth_constants.dart';
import 'package:hvac_control/core/navigation/app_router.dart';
import 'package:hvac_control/core/services/native_loading_service.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_state.dart';
import 'package:hvac_control/presentation/screens/auth/widgets/login_form.dart';
import 'package:hvac_control/presentation/screens/auth/widgets/register_form.dart';

/// Единый экран авторизации с переключением между формами
class AuthScreen extends StatefulWidget {

  const AuthScreen({
    super.key,
    this.isRegister = false,
  });
  final bool isRegister;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isRegister;

  @override
  void initState() {
    super.initState();
    _isRegister = widget.isRegister;
    // Скрыть HTML loading экран
    NativeLoadingService.hide();
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
          if (state is AuthAuthenticated) {
            // Используем global navigator key для надежной навигации
            WidgetsBinding.instance.addPostFrameCallback((_) {
              rootNavigatorKey.currentContext?.go(AppRoutes.home);
            });
          } else if (state is AuthRegistered) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              rootNavigatorKey.currentContext?.go(
                '${AppRoutes.verifyEmail}?email=${Uri.encodeComponent(state.email)}',
              );
            });
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
                duration: AppDurations.medium,
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
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
