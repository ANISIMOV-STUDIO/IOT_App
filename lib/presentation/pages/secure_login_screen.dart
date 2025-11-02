/// Secure Login Screen
///
/// Enhanced login screen with comprehensive validation and security features
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/security_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/auth/secure_auth_bloc.dart';
import '../widgets/orange_button.dart';
import '../widgets/outline_button.dart' as custom;

class SecureLoginScreen extends StatefulWidget {
  const SecureLoginScreen({super.key});

  @override
  State<SecureLoginScreen> createState() => _SecureLoginScreenState();
}

class _SecureLoginScreenState extends State<SecureLoginScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Animation controller
  late AnimationController _animationController;

  // State
  bool _isLoginMode = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;
  bool _acceptTerms = false;

  // Password strength
  PasswordStrength _passwordStrength = PasswordStrength.weak;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Add password strength listener
    _passwordController.addListener(_updatePasswordStrength);

    // Load saved credentials if available
    _loadSavedCredentials();
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

  /// Load saved credentials (for remember me)
  Future<void> _loadSavedCredentials() async {
    // This would load from SecureStorageService
    // Implementation depends on dependency injection setup
  }

  /// Update password strength indicator
  void _updatePasswordStrength() {
    if (!_isLoginMode && _passwordController.text.isNotEmpty) {
      setState(() {
        _passwordStrength = Validators.calculatePasswordStrength(
          _passwordController.text,
        );
      });
    }
  }

  /// Switch between login and register modes
  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _formKey.currentState?.reset();
      _nameController.clear();
      _confirmPasswordController.clear();
      _acceptTerms = false;
    });

    if (_isLoginMode) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  /// Handle form submission
  void _handleSubmit() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Validate form
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      return;
    }

    // Additional validation for registration
    if (!_isLoginMode && !_acceptTerms) {
      _showErrorSnackBar('Please accept the terms and conditions');
      return;
    }

    // Trigger appropriate auth event
    if (_isLoginMode) {
      context.read<SecureAuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        ),
      );
    } else {
      context.read<SecureAuthBloc>().add(
        RegisterEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        ),
      );
    }
  }

  /// Handle guest login
  void _handleGuestLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Guest Access'),
        content: const Text(
          'Guest users have limited access:\n\n'
          '• View devices only\n'
          '• No device control\n'
          '• No settings modification\n'
          '• 1-hour session limit\n\n'
          'Continue as guest?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SecureAuthBloc>().add(const GuestLoginEvent());
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  /// Show error snack bar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Get password strength color
  Color _getPasswordStrengthColor() {
    switch (_passwordStrength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.lightGreen;
      case PasswordStrength.veryStrong:
        return Colors.green;
    }
  }

  /// Get password strength text
  String _getPasswordStrengthText() {
    switch (_passwordStrength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocListener<SecureAuthBloc, SecureAuthState>(
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with animation
                    _buildLogo(),
                    const SizedBox(height: 32),

                    // Title
                    _buildTitle(l10n),
                    const SizedBox(height: 40),

                    // Name field (register only)
                    if (!_isLoginMode) ...[
                      _buildNameField(l10n),
                      const SizedBox(height: 16),
                    ],

                    // Email field
                    _buildEmailField(l10n),
                    const SizedBox(height: 16),

                    // Password field
                    _buildPasswordField(l10n),

                    // Password strength indicator (register only)
                    if (!_isLoginMode && _passwordController.text.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildPasswordStrengthIndicator(),
                    ],
                    const SizedBox(height: 16),

                    // Confirm password field (register only)
                    if (!_isLoginMode) ...[
                      _buildConfirmPasswordField(l10n),
                      const SizedBox(height: 16),
                    ],

                    // Remember me / Accept terms
                    _buildCheckboxes(l10n),
                    const SizedBox(height: 24),

                    // Submit button
                    _buildSubmitButton(l10n),
                    const SizedBox(height: 16),

                    // Toggle mode button
                    _buildToggleModeButton(l10n),
                    const SizedBox(height: 16),

                    // Divider
                    _buildDivider(),
                    const SizedBox(height: 16),

                    // Guest login button
                    _buildGuestLoginButton(),

                    // Forgot password (login only)
                    if (_isLoginMode) ...[
                      const SizedBox(height: 16),
                      _buildForgotPasswordButton(l10n),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryOrange,
            AppTheme.primaryOrangeLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryOrange.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.thermostat,
        size: 50,
        color: Colors.white,
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.elasticOut);
  }

  Widget _buildTitle(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          _isLoginMode ? 'Welcome Back' : 'Create Account',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _isLoginMode
              ? 'Sign in to your account'
              : 'Sign up for a new account',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNameField(AppLocalizations l10n) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'John Doe',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) => Validators.validateName(value, fieldName: 'Name'),
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildEmailField(AppLocalizations l10n) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: l10n.email,
        hintText: 'your@email.com',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: Validators.validateEmail,
      inputFormatters: [
        LengthLimitingTextInputFormatter(254),
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // No spaces
      ],
    );
  }

  Widget _buildPasswordField(AppLocalizations l10n) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: l10n.password,
        hintText: _isLoginMode ? '••••••••' : 'Min ${SecurityConstants.minPasswordLength} characters',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      obscureText: _obscurePassword,
      validator: _isLoginMode ? null : Validators.validatePassword,
      inputFormatters: [
        LengthLimitingTextInputFormatter(SecurityConstants.maxPasswordLength),
      ],
    );
  }

  Widget _buildConfirmPasswordField(AppLocalizations l10n) {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: '••••••••',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(_obscureConfirmPassword
              ? Icons.visibility
              : Icons.visibility_off),
          onPressed: () =>
              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      obscureText: _obscureConfirmPassword,
      validator: (value) => Validators.validatePasswordConfirmation(
        value,
        _passwordController.text,
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: (_passwordStrength.index + 1) / 4,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getPasswordStrengthColor(),
                ),
                minHeight: 4,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _getPasswordStrengthText(),
              style: TextStyle(
                color: _getPasswordStrengthColor(),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Use uppercase, lowercase, numbers, and special characters',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildCheckboxes(AppLocalizations l10n) {
    if (_isLoginMode) {
      return Row(
        children: [
          Checkbox(
            value: _rememberMe,
            onChanged: (value) => setState(() => _rememberMe = value ?? false),
            activeColor: AppTheme.primaryOrange,
          ),
          const Text('Remember me'),
        ],
      );
    } else {
      return Row(
        children: [
          Checkbox(
            value: _acceptTerms,
            onChanged: (value) => setState(() => _acceptTerms = value ?? false),
            activeColor: AppTheme.primaryOrange,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _acceptTerms = !_acceptTerms),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: const [
                    TextSpan(text: 'I accept the '),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: TextStyle(
                        color: AppTheme.primaryOrange,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(duration: 300.ms);
    }
  }

  Widget _buildSubmitButton(AppLocalizations l10n) {
    return BlocBuilder<SecureAuthBloc, SecureAuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return OrangeButton(
          text: _isLoginMode ? l10n.login : l10n.register,
          width: double.infinity,
          onPressed: isLoading ? null : _handleSubmit,
          isLoading: isLoading,
        );
      },
    );
  }

  Widget _buildToggleModeButton(AppLocalizations l10n) {
    return custom.OutlineButton(
      text: _isLoginMode
          ? "Don't have an account? Register"
          : 'Already have an account? Login',
      width: double.infinity,
      onPressed: _toggleMode,
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGuestLoginButton() {
    return TextButton.icon(
      onPressed: _handleGuestLogin,
      icon: const Icon(Icons.person_outline),
      label: const Text('Continue as Guest'),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.textSecondary,
      ),
    );
  }

  Widget _buildForgotPasswordButton(AppLocalizations l10n) {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset feature coming soon'),
            backgroundColor: AppTheme.info,
          ),
        );
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(color: AppTheme.primaryOrange),
      ),
    );
  }
}