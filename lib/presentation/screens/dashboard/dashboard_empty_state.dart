/// Dashboard Empty State - No devices widget
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/constants/auth_constants.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
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
            size: AppIconSizes.standard,
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AuthConstants.formMaxWidth),
            child: BreezButton(
              onTap: onAddUnit,
              backgroundColor: colors.accent,
              hoverColor: colors.accentLight,
              showBorder: false,
              borderRadius: AppRadius.nested,
              padding: const EdgeInsets.all(AppSpacing.xs),
              enableGlow: true,
              semanticLabel: l10n.addUnit,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, size: AppSpacing.md, color: AppColors.black),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    l10n.addUnit,
                    style: const TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
