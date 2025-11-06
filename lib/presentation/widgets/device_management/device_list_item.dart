/// Device List Item Widget
///
/// A single device item in the device management list
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'device_utils.dart';

class DeviceListItem extends StatelessWidget {
  final dynamic unit;
  final bool isOnline;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DeviceListItem({
    super.key,
    required this.unit,
    required this.isOnline,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: HvacSpacing.sm),
      child: HvacSwipeableCard(
        key: ValueKey(unit.id),
        onSwipeRight: onEdit,
        onSwipeLeft: onDelete,
        rightActionLabel: l10n.edit,
        leftActionLabel: l10n.delete,
        rightActionIcon: Icons.edit,
        leftActionIcon: Icons.delete,
        rightActionColor: HvacColors.info,
        leftActionColor: HvacColors.error,
        child: HvacInteractiveScale(
          onTap: onTap,
          child: Hero(
            tag: 'device_${unit.id}',
            child: Material(
              color: Colors.transparent,
              child: HvacGradientBorder(
                gradientColors: const [
                  HvacColors.primaryOrange,
                  HvacColors.primaryBlue,
                ],
                child: Container(
                  decoration: HvacDecorations.card(),
                  child: Padding(
                    padding: const EdgeInsets.all(HvacSpacing.md),
                    child: Row(
                      children: [
                        _buildIconSection(),
                        const SizedBox(width: HvacSpacing.md),
                        _buildInfoSection(context),
                        _buildStatusBadge(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSection() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(HvacSpacing.sm),
          decoration: BoxDecoration(
            color: HvacColors.getModeColor(unit.mode),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.thermostat,
            color: HvacColors.textPrimary,
            size: 24,
          ),
        ),
        if (isOnline)
          const Positioned(
            right: 0,
            bottom: 0,
            child: HvacPulsingDot(
              color: HvacColors.success,
              size: 12,
            ),
          ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            unit.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: HvacSpacing.xxs),
          Text(
            'ID: ${unit.id}',
            style: TextStyle(
              color: HvacColors.textSecondary.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
          if (unit.macAddress != null) ...[
            const SizedBox(height: 2),
            Text(
              'MAC: ${_formatMacAddress(unit.macAddress!)}',
              style: TextStyle(
                color: HvacColors.textSecondary.withValues(alpha: 0.5),
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HvacSpacing.sm,
        vertical: HvacSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: HvacColors.success.withValues(alpha: 0.2),
        borderRadius: HvacRadius.smRadius,
      ),
      child: Text(
        l10n.online,
        style: const TextStyle(
          color: HvacColors.success,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatMacAddress(String mac) {
    return DeviceUtils.formatMacAddress(mac);
  }
}