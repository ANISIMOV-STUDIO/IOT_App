/// Login Screen
///
/// Redesigned compact login screen with neumorphic design and animations
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/utils/responsive_text.dart';
import '../bloc/auth/auth_bloc.dart';

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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // 1.5 секунды
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic, // Плавная кривая
      ),
    );

    // Запускаем анимацию один раз при открытии
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
    setState(() {
      _isLoading = true;
    });

    // Simulate login - dispatch login event to AuthBloc
    Future.delayed(const Duration(seconds: 1), () {
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

  void _handleSkip() {
    // Skip login - dispatch skip event to AuthBloc
    context.read<AuthBloc>().add(const SkipAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    // Responsive padding
    final horizontalPadding = size.width > 1200
        ? HvacSpacing.xxl * 2
        : size.width > 600
            ? HvacSpacing.xl
            : HvacSpacing.lg;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HvacColors.backgroundDark,
              HvacColors.backgroundDark.withValues(alpha:0.8),
              HvacColors.primaryOrange.withValues(alpha:0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: HvacSpacing.lg,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // BREEZ Home Title
                        Text(
                          l10n.appTitle.toUpperCase(),
                          style: ResponsiveText.adaptive(
                            context,
                            mobileSize: 32.0,
                            desktopSize: 42.0,
                            fontWeight: FontWeight.bold,
                            color: HvacColors.textPrimary,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: HvacSpacing.xs),
                        Text(
                          l10n.smartClimateManagement,
                          style: const TextStyle(
                            color: HvacColors.textSecondary,
                            fontSize: ResponsiveText.bodyMedium,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: HvacSpacing.xl),

                        // Glassmorphism Card with Gradient Border
                        _buildLoginCard(l10n),

                        const SizedBox(height: HvacSpacing.lg),

                        // Skip Button
                        _buildSkipButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLoginCard(AppLocalizations l10n) {
    return HvacGradientBorder(
      gradientColors: const [
        HvacColors.primaryOrange,
        HvacColors.primaryBlue,
        HvacColors.primaryOrange,
      ],
      borderWidth: 2,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard.withValues(alpha:0.6),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(HvacSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HvacColors.backgroundCard.withValues(alpha:0.8),
                    HvacColors.backgroundCard.withValues(alpha:0.6),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    label: l10n.email,
                    hint: 'your@email.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: HvacSpacing.md),

                  // Password Field
                  _buildTextField(
                    controller: _passwordController,
                    label: l10n.password,
                    hint: '••••••••',
                    icon: Icons.lock_outlined,
                    obscureText: true,
                  ),
                  const SizedBox(height: HvacSpacing.xl),

                  // Login Button
                  _buildLoginButton(l10n),
                  const SizedBox(height: HvacSpacing.md),

                  // Register Button
                  _buildRegisterButton(l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HvacColors.primaryOrange.withValues(alpha:0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: HvacColors.primaryOrange,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.md,
            vertical: HvacSpacing.md,
          ),
          labelStyle: HvacTypography.bodySmall.copyWith(
            color: HvacColors.textSecondary,
          ),
          hintStyle: HvacTypography.bodySmall.copyWith(
            color: HvacColors.textSecondary.withValues(alpha:0.5),
          ),
        ),
        style: HvacTypography.bodyMedium.copyWith(
          color: HvacColors.textPrimary,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: !_isLoading,
      ),
    );
  }

  Widget _buildLoginButton(AppLocalizations l10n) {
    return HvacInteractiveScale(
      scaleDown: 0.97,
      child: HvacNeumorphicButton(
        width: double.infinity,
        height: 56,
        borderRadius: 16,
        color: HvacColors.primaryOrange,
        onPressed: _isLoading ? null : _handleLogin,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    HvacColors.backgroundCard,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.login_rounded,
                    color: HvacColors.backgroundCard,
                    size: ResponsiveText.iconSmall,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.login,
                    style: const TextStyle(
                      color: HvacColors.backgroundCard,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveText.labelMedium,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildRegisterButton(AppLocalizations l10n) {
    return HvacInteractiveScale(
      scaleDown: 0.97,
      child: HvacNeumorphicButton(
        width: double.infinity,
        height: 56,
        borderRadius: 16,
        onPressed: _isLoading
            ? null
            : () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.registrationComingSoon),
                    backgroundColor: HvacColors.info,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_add_outlined,
              color: HvacColors.primaryOrange,
              size: ResponsiveText.iconSmall,
            ),
            const SizedBox(width: 6),
            Text(
              l10n.register,
              style: const TextStyle(
                color: HvacColors.primaryOrange,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveText.labelMedium,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    final l10n = AppLocalizations.of(context)!;
    return HvacInteractiveScale(
      scaleDown: 0.95,
      child: TextButton(
        onPressed: _isLoading ? null : _handleSkip,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.lg,
            vertical: HvacSpacing.sm,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.skipForNow,
              style: HvacTypography.bodyMedium.copyWith(
                color: HvacColors.textSecondary,
              ),
            ),
            const SizedBox(width: HvacSpacing.xs),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: HvacColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}