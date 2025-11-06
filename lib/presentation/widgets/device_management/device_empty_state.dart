/// Device Empty State Widget
///
/// Displayed when no devices are found
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

class DeviceEmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const DeviceEmptyState({
    super.key,
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
                  Icons.devices_other_rounded,
                  size: 64,
                  color: HvacColors.textSecondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: HvacSpacing.md),
                Text(
                  l10n.noDevicesFound,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: HvacSpacing.sm),
                Text(
                  l10n.pullToRefresh,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: HvacColors.textSecondary,
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