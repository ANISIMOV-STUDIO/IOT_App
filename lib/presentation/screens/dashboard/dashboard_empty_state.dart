/// Dashboard Empty State - No devices widget
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Empty state when no devices are registered
class DashboardEmptyState extends StatelessWidget {
  final VoidCallback onAddUnit;

  const DashboardEmptyState({
    super.key,
    required this.onAddUnit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ac_unit_outlined,
            size: 80,
            color: colors.textMuted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noDevices,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addFirstDeviceByMac,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onAddUnit,
            icon: const Icon(Icons.add),
            label: Text(l10n.addUnit),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
