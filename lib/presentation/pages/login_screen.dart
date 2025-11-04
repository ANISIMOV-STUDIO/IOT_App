/// Login Screen
///
/// Simple login/register screen
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../generated/l10n/app_localizations.dart';
import '../widgets/orange_button.dart';
import '../bloc/auth/auth_bloc.dart';

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(HvacSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        HvacColors.primaryOrange,
                        HvacColors.primaryOrangeLight,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: HvacColors.primaryOrange.withValues(alpha: 0.3),
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
                ),
                const SizedBox(height: HvacSpacing.xl),

                // Welcome Text
                Text(
                  l10n.hvacControl,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: HvacSpacing.xs),
                Text(
                  'Smart Climate Management',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: HvacSpacing.xxl),

                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    hintText: 'your@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: HvacSpacing.md),

                // Password Field
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outlined),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: HvacSpacing.xl),

                // Login Button
                OrangeButton(
                  text: l10n.login,
                  width: double.infinity,
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: HvacSpacing.md),

                // Register Button
                OutlineButton(
                  text: l10n.register,
                  width: double.infinity,
                  onPressed: _isLoading ? null : () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registration feature coming soon'),
                        backgroundColor: HvacColors.info,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: HvacSpacing.lg),

                // Skip Button
                TextButton(
                  onPressed: _isLoading ? null : _handleSkip,
                  child: Text(
                    'Skip for now',
                    style: HvacTypography.bodyMedium.copyWith(
                      color: HvacColors.textSecondary,
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
}
