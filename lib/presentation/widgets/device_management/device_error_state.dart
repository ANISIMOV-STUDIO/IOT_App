/// Device Error State Widget
///
/// Displayed when there's an error loading devices
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

class DeviceErrorState extends StatelessWidget {
  final String errorMessage;
  final Future<void> Function() onRefresh;

  const DeviceErrorState({
    super.key,
    required this.errorMessage,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return HvacRefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: HvacColors.error.withValues(alpha: 0.7),
                ),
                const SizedBox(height: HvacSpacing.md),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    color: HvacColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: HvacSpacing.lg),
                HvacPrimaryButton(
                  label: l10n.retry,
                  onPressed: onRefresh,
                  icon: Icons.refresh_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
