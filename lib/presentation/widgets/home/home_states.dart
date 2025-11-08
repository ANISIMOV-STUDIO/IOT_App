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
          const CircularProgressIndicator(
            color: HvacColors.primaryOrange,
            strokeWidth: 3.0,
          ),
          const SizedBox(height: HvacSpacing.mdV),
          Text(
            l10n.loadingDevices,
            style: const TextStyle(
              fontSize: 14.0,
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
  final VoidCallback? onRetry;

  const HomeErrorState({
    super.key,
    required this.message,
    this.onRetry,
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
            const Icon(
              Icons.error_outline,
              size: 64.0,
              color: HvacColors.error,
            ),
            const SizedBox(height: HvacSpacing.lgV),
            Text(
              l10n.connectionError,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: HvacColors.textPrimary,
              ),
            ),
            const SizedBox(height: HvacSpacing.smV),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14.0,
                color: HvacColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HvacSpacing.lgV),
            HvacPrimaryButton(
              label: l10n.retry,
              onPressed: onRetry ??
                  () => context.read<HvacListBloc>().add(
                        const LoadHvacUnitsEvent(),
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
  final VoidCallback? onAddDevice;

  const HomeEmptyState({
    super.key,
    this.onAddDevice,
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
              Icons.devices_other,
              size: 64.0,
              color: HvacColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: HvacSpacing.lgV),
            Text(
              l10n.noDevices,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: HvacColors.textPrimary,
              ),
            ),
            const SizedBox(height: HvacSpacing.smV),
            Text(
              l10n.addFirstDevice,
              style: const TextStyle(
                fontSize: 14.0,
                color: HvacColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAddDevice != null) ...[
              const SizedBox(height: HvacSpacing.lgV),
              HvacPrimaryButton(
                label: l10n.addDevice,
                onPressed: onAddDevice,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
