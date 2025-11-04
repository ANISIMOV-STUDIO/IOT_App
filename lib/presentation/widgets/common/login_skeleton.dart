/// Login Screen Skeleton Loader
///
/// Displays a skeleton placeholder while authentication state is being checked
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Skeleton loader that mimics the login screen layout
class LoginSkeleton extends StatelessWidget {
  const LoginSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive padding (same as login screen)
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
              HvacColors.backgroundDark.withValues(alpha: 0.8),
              HvacColors.primaryOrange.withValues(alpha: 0.05),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App Title Skeleton
                    HvacSkeletonLoader(
                      isLoading: true,
                      child: Container(
                        width: 250,
                        height: 60,
                        decoration: BoxDecoration(
                          color: HvacColors.backgroundCard,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: HvacSpacing.xs),

                    // Subtitle Skeleton
                    HvacSkeletonLoader(
                      isLoading: true,
                      child: Container(
                        width: 200,
                        height: 20,
                        decoration: BoxDecoration(
                          color: HvacColors.backgroundCard,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: HvacSpacing.xl),

                    // Login Card Skeleton
                    _buildLoginCardSkeleton(),

                    const SizedBox(height: HvacSpacing.lg),

                    // Skip Button Skeleton
                    HvacSkeletonLoader(
                      isLoading: true,
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: HvacColors.backgroundCard,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCardSkeleton() {
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
          color: HvacColors.backgroundCard.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
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
                    HvacColors.backgroundCard.withValues(alpha: 0.8),
                    HvacColors.backgroundCard.withValues(alpha: 0.6),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Email Field Skeleton
                  _buildTextFieldSkeleton(),
                  const SizedBox(height: HvacSpacing.md),

                  // Password Field Skeleton
                  _buildTextFieldSkeleton(),
                  const SizedBox(height: HvacSpacing.xl),

                  // Login Button Skeleton (orange background)
                  HvacSkeletonLoader(
                    isLoading: true,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: HvacColors.primaryOrange.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: HvacSpacing.md),

                  // Register Button Skeleton
                  HvacSkeletonLoader(
                    isLoading: true,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: HvacColors.backgroundCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: HvacColors.primaryOrange.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldSkeleton() {
    return HvacSkeletonLoader(
      isLoading: true,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: HvacColors.backgroundDark.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: HvacColors.primaryOrange.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
    );
  }
}
