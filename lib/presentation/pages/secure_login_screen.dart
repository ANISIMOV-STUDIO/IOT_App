/// Secure Login Screen
///
/// Redesigned compact login screen with neumorphic design and animations
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import '../../generated/l10n/app_localizations.dart';
import '../bloc/auth/secure_auth_bloc.dart';

class SecureLoginScreen extends StatefulWidget {
  const SecureLoginScreen({super.key});

  @override
  State<SecureLoginScreen> createState() => _SecureLoginScreenState();
}

class _SecureLoginScreenState extends State<SecureLoginScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  bool _isLoginMode = true;
  bool _rememberMe = false;

  // Animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadSavedCredentials();
  }

  void _initAnimations() {
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
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    // Load from SecureStorageService if remember me was checked
    // TODO: Implement loading saved credentials
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _nameController.clear();
      _confirmPasswordController.clear();
    });
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();

    if (_isLoginMode) {
      context.read<SecureAuthBloc>().add(
            LoginEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              rememberMe: _rememberMe,
            ),
          );
    } else {
      // Validate confirm password
      if (_passwordController.text != _confirmPasswordController.text) {
        _showErrorSnackBar('Passwords do not match');
        return;
      }

      context.read<SecureAuthBloc>().add(
            RegisterEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _nameController.text.trim(),
            ),
          );
    }
  }

  void _handleGuestLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.lg),
        ),
        backgroundColor: HvacColors.backgroundCard,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: HvacColors.info.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.info_outline,
                color: HvacColors.info,
                size: 24,
              ),
            ),
            const SizedBox(width: HvacSpacing.md),
            const Text('Guest Access'),
          ],
        ),
        content: const Text(
          'Guest users have limited access:\n\n'
          '• View devices only\n'
          '• No device control\n'
          '• No settings modification\n'
          '• 1-hour session limit\n\n'
          'Continue as guest?',
          style: TextStyle(color: HvacColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: HvacColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SecureAuthBloc>().add(const GuestLoginEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HvacColors.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(HvacRadius.sm),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Password reset feature coming soon'),
        backgroundColor: HvacColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.sm),
        ),
        margin: const EdgeInsets.all(HvacSpacing.md),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: HvacColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.sm),
        ),
        margin: const EdgeInsets.all(HvacSpacing.md),
      ),
    );
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

    return BlocListener<SecureAuthBloc, SecureAuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showErrorSnackBar(state.message);
        } else if (state is AuthLocked) {
          final minutes = state.unlockTime.difference(DateTime.now()).inMinutes;
          _showErrorSnackBar(
            'Account locked. Try again in $minutes minutes.',
          );
        }
      },
      child: Scaffold(
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
                            'BREEZ HOME',
                            style: HvacTypography.displayLarge.copyWith(
                              color: HvacColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: HvacSpacing.xs),
                          Text(
                            _isLoginMode
                                ? 'Sign in to continue'
                                : 'Join our smart climate management',
                            style: HvacTypography.bodyMedium.copyWith(
                              color: HvacColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: HvacSpacing.xl),

                          // Glassmorphism Card with Gradient Border
                          _buildFormCard(l10n),

                          const SizedBox(height: HvacSpacing.lg),

                          // Toggle Mode Button
                          _buildToggleModeButton(),

                          const SizedBox(height: HvacSpacing.md),

                          // Divider
                          _buildDivider(),

                          const SizedBox(height: HvacSpacing.md),

                          // Guest Login Button
                          _buildGuestButton(),

                          // Forgot Password (login only)
                          if (_isLoginMode) ...[
                            const SizedBox(height: HvacSpacing.sm),
                            _buildForgotPasswordButton(),
                          ],
                        ],
                      ),
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


  Widget _buildFormCard(AppLocalizations l10n) {
    return BlocBuilder<SecureAuthBloc, SecureAuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

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
                      // Name Field (Register only)
                      if (!_isLoginMode) ...[
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'John Doe',
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.name,
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: HvacSpacing.md),
                      ],

                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        label: l10n.email,
                        hint: 'your@email.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: HvacSpacing.md),

                      // Password Field
                      _buildTextField(
                        controller: _passwordController,
                        label: l10n.password,
                        hint: '••••••••',
                        icon: Icons.lock_outlined,
                        obscureText: true,
                        enabled: !isLoading,
                      ),

                      // Confirm Password Field (Register only)
                      if (!_isLoginMode) ...[
                        const SizedBox(height: HvacSpacing.md),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          obscureText: true,
                          enabled: !isLoading,
                        ),
                      ],

                      // Remember Me Checkbox (Login only)
                      if (_isLoginMode) ...[
                        const SizedBox(height: HvacSpacing.md),
                        _buildRememberMeCheckbox(),
                      ],

                      const SizedBox(height: HvacSpacing.xl),

                      // Submit Button
                      _buildSubmitButton(l10n, isLoading),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool enabled = true,
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
        enabled: enabled,
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
            activeColor: HvacColors.primaryOrange,
            side: BorderSide(
              color: HvacColors.primaryOrange.withValues(alpha:0.5),
              width: 2,
            ),
          ),
        ),
        const SizedBox(width: HvacSpacing.sm),
        Text(
          'Remember me',
          style: HvacTypography.bodySmall.copyWith(
            color: HvacColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n, bool isLoading) {
    return HvacInteractiveScale(
      scaleDown: 0.97,
      child: HvacNeumorphicButton(
        width: double.infinity,
        height: 56,
        borderRadius: 16,
        color: HvacColors.primaryOrange,
        onPressed: isLoading ? null : _handleSubmit,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLoginMode ? l10n.login : l10n.register,
                    style: HvacTypography.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: HvacSpacing.sm),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildToggleModeButton() {
    return HvacInteractiveScale(
      scaleDown: 0.97,
      child: HvacNeumorphicButton(
        width: double.infinity,
        height: 52,
        borderRadius: 16,
        onPressed: _toggleMode,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isLoginMode ? Icons.person_add_outlined : Icons.login_outlined,
              color: HvacColors.primaryOrange,
              size: 20,
            ),
            const SizedBox(width: HvacSpacing.sm),
            Text(
              _isLoginMode
                  ? "Don't have an account? Register"
                  : 'Already have an account? Login',
              style: HvacTypography.labelLarge.copyWith(
                color: HvacColors.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  HvacColors.textSecondary.withValues(alpha:0.3),
                ],
                stops: const [0.0, 0.5],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.md),
          child: Text(
            'OR',
            style: HvacTypography.bodySmall.copyWith(
              color: HvacColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  HvacColors.textSecondary.withValues(alpha:0.3),
                  Colors.transparent,
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestButton() {
    return HvacInteractiveScale(
      scaleDown: 0.95,
      child: TextButton(
        onPressed: _handleGuestLogin,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.lg,
            vertical: HvacSpacing.sm,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_outline,
              size: 18,
              color: HvacColors.textSecondary,
            ),
            const SizedBox(width: HvacSpacing.xs),
            Text(
              'Continue as Guest',
              style: HvacTypography.bodyMedium.copyWith(
                color: HvacColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return HvacInteractiveScale(
      scaleDown: 0.95,
      child: TextButton(
        onPressed: _handleForgotPassword,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.lg,
            vertical: HvacSpacing.xs,
          ),
        ),
        child: Text(
          'Forgot Password?',
          style: HvacTypography.bodySmall.copyWith(
            color: HvacColors.primaryOrange,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}