/// Authentication Logo Component
///
/// Animated logo with responsive sizing for web
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import 'responsive_utils.dart';

class AuthLogo extends StatefulWidget {
  const AuthLogo({super.key});

  @override
  State<AuthLogo> createState() => _AuthLogoState();
}

class _AuthLogoState extends State<AuthLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = AuthResponsive(context);

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            width: responsive.logoSize,
            height: responsive.logoSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _isHovered
                    ? [
                        HvacColors.primaryOrange,
                        HvacColors.primaryOrangeLight,
                      ]
                    : [
                        HvacColors.primaryOrangeLight,
                        HvacColors.primaryOrange,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: HvacColors.primaryOrange.withAlpha(
                    (76 + (_pulseController.value * 25)).toInt(),
                  ),
                  blurRadius: 20 + (_pulseController.value * 10),
                  spreadRadius: 5 + (_pulseController.value * 3),
                ),
                if (_isHovered)
                  BoxShadow(
                    color: HvacColors.primaryOrangeLight.withAlpha(51),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
              ],
            ),
            child: Icon(
              Icons.thermostat,
              size: responsive.logoSize * 0.5,
              color: Colors.white,
            ),
          );
        },
      ),
    )
        .animate()
        .scale(
          duration: 600.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          duration: 2000.ms,
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.05, 1.05),
        );
  }
}

class AuthHeader extends StatelessWidget {
  final bool isLoginMode;

  const AuthHeader({
    super.key,
    required this.isLoginMode,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = AuthResponsive(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        const AuthLogo(),
        SizedBox(height: 32),
        Text(
          isLoginMode ? 'Welcome Back' : 'Create Account',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: (28 * responsive.fontMultiplier).rsp(context),
            fontWeight: FontWeight.bold,
            color: HvacColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
        SizedBox(height: 8),
        Text(
          isLoginMode ? 'Sign in to your account' : 'Sign up for a new account',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: (15 * responsive.fontMultiplier).rsp(context),
            color: HvacColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
