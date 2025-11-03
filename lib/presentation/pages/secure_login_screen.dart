/// Secure Login Screen - Fully responsive for web
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import '../../generated/l10n/app_localizations.dart';
import '../bloc/auth/secure_auth_bloc.dart';
import '../widgets/auth/auth_form.dart';
import '../widgets/auth/auth_layout_container.dart';
import '../widgets/auth/auth_logo.dart';
import '../widgets/auth/auth_secondary_buttons.dart';
import '../widgets/auth/auth_submit_button.dart';
import '../widgets/auth/responsive_utils.dart';

class SecureLoginScreen extends StatefulWidget {
  const SecureLoginScreen({super.key});

  @override
  State<SecureLoginScreen> createState() => _SecureLoginScreenState();
}

class _SecureLoginScreenState extends State<SecureLoginScreen> {
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  bool _isLoginMode = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    // Load from SecureStorageService if remember me was checked
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
              rememberMe: false, // Handled in form
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

  void _handleGuestLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.rw(context)),
        ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: HvacColors.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.rw(context)),
              ),
            ),
            child: const Text('Continue'),
          ),
        ],
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
          borderRadius: BorderRadius.circular(8.rw(context)),
        ),
        margin: EdgeInsets.all(16.rw(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final responsive = AuthResponsive(context);

    return BlocListener<SecureAuthBloc, SecureAuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _showErrorSnackBar(state.message);
        } else if (state is AuthLocked) {
          final minutes =
              state.unlockTime.difference(DateTime.now()).inMinutes;
          _showErrorSnackBar(
            'Account locked. Try again in $minutes minutes.',
          );
        }
      },
      child: AuthLayoutContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and header
            AuthHeader(isLoginMode: _isLoginMode),
            SizedBox(height: 40.rh(context)),

            // Form section
            BlocBuilder<SecureAuthBloc, SecureAuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return AuthForm(
                  isLoginMode: _isLoginMode,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  nameController: _nameController,
                  confirmPasswordController: _confirmPasswordController,
                  onSubmit: _handleSubmit,
                  onToggleMode: _toggleMode,
                  isLoading: isLoading,
                );
              },
            ),

            SizedBox(height: responsive.verticalSpacing),

            // Submit button
            BlocBuilder<SecureAuthBloc, SecureAuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return AuthSubmitButton(
                  text: _isLoginMode ? l10n.login : l10n.register,
                  onPressed: isLoading ? null : _handleSubmit,
                  isLoading: isLoading,
                );
              },
            ),

            SizedBox(height: responsive.verticalSpacing),

            // Toggle mode button
            AuthOutlineButton(
              text: _isLoginMode
                  ? "Don't have an account? Register"
                  : 'Already have an account? Login',
              onPressed: _toggleMode,
            ),

            SizedBox(height: responsive.verticalSpacing),

            // Divider
            const AuthDivider(),

            SizedBox(height: responsive.verticalSpacing),

            // Guest login
            AuthTextButton(
              text: 'Continue as Guest',
              icon: Icons.person_outline,
              onPressed: _handleGuestLogin,
            ),

            // Forgot password (login only)
            if (_isLoginMode) ...[
              SizedBox(height: 12.rh(context)),
              AuthTextButton(
                text: 'Forgot Password?',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Password reset feature coming soon'),
                      backgroundColor: HvacColors.info,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.rw(context)),
                      ),
                      margin: EdgeInsets.all(16.rw(context)),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}