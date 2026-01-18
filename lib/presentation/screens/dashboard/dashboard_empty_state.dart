/// Dashboard Empty State - No devices widget
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

/// Empty state when no devices are registered
class DashboardEmptyState extends StatelessWidget {

  const DashboardEmptyState({required this.onAddUnit, super.key});
  final VoidCallback onAddUnit;

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
          const SizedBox(height: AppSpacing.lgx),
          Text(
            l10n.noDevices,
            style: TextStyle(
              fontSize: AppFontSizes.h2,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.addFirstDeviceByMac,
            style: TextStyle(fontSize: AppFontSizes.body, color: colors.textMuted),
          ),
          const SizedBox(height: AppSpacing.xl),
          BreezButton(
            onTap: onAddUnit,
            backgroundColor: AppColors.accent,
            hoverColor: AppColors.accentLight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lgx, vertical: AppSpacing.md),
            enableGlow: true,
            semanticLabel: l10n.addUnit,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: AppColors.white),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.addUnit,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
