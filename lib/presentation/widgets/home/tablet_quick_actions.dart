/// Tablet Quick Actions Panel
///
/// Quick action buttons for tablet home layout with consistent HVAC UI Kit styling
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

class TabletQuickActions extends StatelessWidget {
  final VoidCallback onPowerAllOn;
  final VoidCallback onPowerAllOff;
  final VoidCallback onSyncSettings;
  final VoidCallback onApplyScheduleToAll;

  const TabletQuickActions({
    super.key,
    required this.onPowerAllOn,
    required this.onPowerAllOff,
    required this.onSyncSettings,
    required this.onApplyScheduleToAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return HvacCard(
      padding: const EdgeInsets.all(HvacSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.quickActions,
            style: HvacTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: HvacSpacing.md),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: HvacSpacing.sm,
            crossAxisSpacing: HvacSpacing.sm,
            childAspectRatio: 2.5,
            children: [
              _buildActionButton(
                context: context,
                icon: Icons.power_settings_new,
                label: l10n.allOn,
                onTap: onPowerAllOn,
                color: HvacColors.success,
              ),
              _buildActionButton(
                context: context,
                icon: Icons.power_off,
                label: l10n.allOff,
                onTap: onPowerAllOff,
                color: HvacColors.error,
              ),
              _buildActionButton(
                context: context,
                icon: Icons.sync,
                label: l10n.sync,
                onTap: onSyncSettings,
                color: HvacColors.primary,
              ),
              _buildActionButton(
                context: context,
                icon: Icons.schedule,
                label: l10n.schedule,
                onTap: onApplyScheduleToAll,
                color: HvacColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: HvacColors.backgroundCard,
      borderRadius: HvacRadius.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: HvacRadius.mdRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.sm,
            vertical: HvacSpacing.sm,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.0,
            ),
            borderRadius: HvacRadius.mdRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.0,
                color: color,
              ),
              const SizedBox(width: HvacSpacing.xs),
              Text(
                label,
                style: HvacTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
