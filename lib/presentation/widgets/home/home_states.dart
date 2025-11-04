/// Home Screen State Widgets
///
/// Extracted state widgets for loading, error, and empty states
/// Part of home_screen.dart refactoring to respect 300-line limit
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../bloc/hvac_list/hvac_list_bloc.dart';
import '../../bloc/hvac_list/hvac_list_event.dart';

/// Loading state widget for home screen
class HomeLoadingState extends StatelessWidget {
  const HomeLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: HvacColors.primaryOrange,
            strokeWidth: 3.w,
          ),
          const SizedBox(height: HvacSpacing.mdV),
          Text(
            l10n.loadingDevices,
            style: TextStyle(
              fontSize: 14.sp,
              color: HvacColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

/// Error state widget for home screen
class HomeErrorState extends StatelessWidget {
  final String message;

  const HomeErrorState({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: HvacColors.error,
            ),
            const SizedBox(height: HvacSpacing.lgV),
            Text(
              l10n.connectionError,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: HvacColors.textPrimary,
              ),
            ),
            const SizedBox(height: HvacSpacing.smV),
            Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: HvacColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HvacSpacing.lgV),
            ElevatedButton(
              onPressed: () => context.read<HvacListBloc>().add(
                const LoadHvacUnitsEvent(),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: HvacColors.primaryOrange,
                padding: const EdgeInsets.symmetric(
                  horizontal: HvacSpacing.lgR,
                  vertical: HvacSpacing.smV,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: HvacRadius.smRadius,
                ),
              ),
              child: Text(
                l10n.retry,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

/// Empty state widget for home screen
class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices_other,
              size: 64.sp,
              color: HvacColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: HvacSpacing.lgV),
            Text(
              l10n.noDevices,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: HvacColors.textPrimary,
              ),
            ),
            const SizedBox(height: HvacSpacing.smV),
            Text(
              l10n.addFirstDevice,
              style: TextStyle(
                fontSize: 14.sp,
                color: HvacColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}