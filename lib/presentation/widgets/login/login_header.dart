/// Login Header Widget
///
/// Displays logo and welcome text for login screen
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Login header with logo and welcome text
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Logo container
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                HvacColors.primaryOrange,
                HvacColors.accentOrangeLight,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(HvacRadius.xl),
            boxShadow: [
              BoxShadow(
                color: HvacColors.primaryOrange.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.air,
            size: 50.w,
            color: Colors.white,
          ),
        ),

        SizedBox(height: HvacSpacing.xl.h),

        // Welcome text
        Text(
          l10n.welcomeBack,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: HvacColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(height: HvacSpacing.xs.h),

        // Subtitle
        Text(
          l10n.loginSubtitle,
          style: TextStyle(
            fontSize: 16.sp,
            color: HvacColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
