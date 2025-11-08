/// Login Screen - Refactored Version
///
/// Redesigned compact login screen with neumorphic design and animations
/// Reduced from 430 lines to <200 lines through component extraction
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/login/login_header.dart';
import '../../widgets/login/login_form.dart';
import '../../widgets/login/login_buttons.dart';

/// Refactored login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.read<AuthBloc>().add(
                  LoginEvent(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
          }
        });
      }
    });
  }

  void _handleRegister() {
    // Navigate to register screen
    context.push('/register');
  }

  void _handleSkip() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthBloc>().add(const SkipAuthEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    responsive.init(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: _handleAuthStateChange,
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            HvacColors.backgroundDark,
            HvacColors.backgroundElevated,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(HvacSpacing.xl.w),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildLoginCard(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      padding: EdgeInsets.all(HvacSpacing.xl.w),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(HvacRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LoginHeader(),
          SizedBox(height: HvacSpacing.xxl.h),
          LoginForm(
            emailController: _emailController,
            passwordController: _passwordController,
            isLoading: _isLoading,
            onSubmit: _handleLogin,
          ),
          SizedBox(height: HvacSpacing.xl.h),
          LoginButtons(
            isLoading: _isLoading,
            onLogin: _handleLogin,
            onRegister: _handleRegister,
            onSkip: _handleSkip,
          ),
        ],
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      setState(() => _isLoading = false);
      context.go('/home');
    } else if (state is AuthError) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }
}
