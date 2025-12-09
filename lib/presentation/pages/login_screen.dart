import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';
import 'package:hvac_control/core/navigation/app_router.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_bloc.dart' as auth;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<auth.AuthBloc, auth.AuthState>(
      listener: (context, state) {
        if (state is auth.AuthAuthenticated) {
           // Use the router's go method with the named route constant
           context.go(AppRoutes.home);
        } else if (state is auth.AuthError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pageMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Area
                Icon(
                  Icons.wind_power, 
                  size: 64, 
                  color: theme.colorScheme.primary
                ),
                const SizedBox(height: 24),
                Text(
                  'ZILON', 
                  style: AppTypography.displayLarge.copyWith(
                    color: theme.colorScheme.onSurface,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Climate Control System',
                  style: AppTypography.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 48),

                // Login Card
                Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SmartCard(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Welcome Back',
                          style: AppTypography.displayMedium.copyWith(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        // Email Field
                        _buildTextField(
                          context,
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 20),
                        
                        // Password Field
                        _buildTextField(
                          context,
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 32),

                        // Login Button
                        SizedBox(
                          height: 50,
                          child: FilledButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading 
                              ? const SizedBox(
                                  height: 24, width: 24, 
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                )
                              : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Divider
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('OR', style: AppTypography.labelSmall),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Debug/Skip Button
                        SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _handleSkip,
                            icon: const Icon(Icons.bug_report, size: 20),
                            label: const Text('Debug Access (Skip Auth)'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                              side: BorderSide(color: theme.colorScheme.outline),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Register Link
                TextButton(
                  onPressed: () {}, 
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: AppTypography.bodyMedium.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: AppTypography.bodyMedium.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.4)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  void _handleLogin() {
    setState(() => _isLoading = true);
    context.read<auth.AuthBloc>().add(
      auth.LoginEvent(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _handleSkip() {
    setState(() => _isLoading = true);
    // Simulate slight delay for effect
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<auth.AuthBloc>().add(const auth.SkipAuthEvent());
        // Force navigation if listener doesn't catch it immediately (belt & suspenders)
        // context.go(AppRoutes.home); 
      }
    });
  }
}
