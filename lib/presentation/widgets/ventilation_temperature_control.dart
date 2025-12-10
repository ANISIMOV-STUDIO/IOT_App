/// Ventilation Temperature Control Widget
///
/// Adaptive card for temperature monitoring and setpoints
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../generated/l10n/app_localizations.dart';

class VentilationTemperatureControl extends StatelessWidget {
  final HvacUnit unit;

  const VentilationTemperatureControl({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return HvacCard(
      padding: EdgeInsets.all(isMobile ? HvacSpacing.md : HvacSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, l10n),
          const SizedBox(height: HvacSpacing.md),
          _buildTemperatureGrid(context, l10n, isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(HvacSpacing.sm),
          decoration: BoxDecoration(
            color: HvacColors.info.withValues(alpha: 0.2),
            borderRadius: HvacRadius.smRadius,
          ),
          child: const Icon(
            Icons.thermostat,
            color: HvacColors.info,
            size: 20.0,
          ),
        ),
        const SizedBox(width: HvacSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.temperatures,
                style: HvacTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2.0),
              Text(
                'Мониторинг и уставки',
                style: HvacTypography.labelSmall.copyWith(
                  color: HvacColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureGrid(
      BuildContext context, AppLocalizations l10n, bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        children: [
          _buildTempIndicator(
            context,
            l10n.supplyAir,
            unit.supplyAirTemp,
            Icons.air,
            HvacColors.info,
          ),
          const SizedBox(height: HvacSpacing.sm),
          _buildTempIndicator(
            context,
            l10n.exhaustAir,
            unit.roomTemp,
            Icons.upload,
            HvacColors.warning,
          ),
          const SizedBox(height: HvacSpacing.sm),
          _buildTempIndicator(
            context,
            l10n.outdoor,
            unit.outdoorTemp,
            Icons.landscape,
            HvacColors.textSecondary,
          ),
          const SizedBox(height: HvacSpacing.sm),
          _buildTempIndicator(
            context,
            l10n.indoor,
            unit.roomTemp,
            Icons.home,
            HvacColors.success,
          ),
        ],
      );
    }

    return Wrap(
      spacing: HvacSpacing.sm,
      runSpacing: HvacSpacing.sm,
      children: [
        SizedBox(
          width: (MediaQuery.of(context).size.width * 0.45) - HvacSpacing.lg * 2,
          child: _buildTempIndicator(
            context,
            l10n.supplyAir,
            unit.supplyAirTemp,
            Icons.air,
            HvacColors.info,
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width * 0.45) - HvacSpacing.lg * 2,
          child: _buildTempIndicator(
            context,
            l10n.exhaustAir,
            unit.roomTemp,
            Icons.upload,
            HvacColors.warning,
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width * 0.45) - HvacSpacing.lg * 2,
          child: _buildTempIndicator(
            context,
            l10n.outdoor,
            unit.outdoorTemp,
            Icons.landscape,
            HvacColors.textSecondary,
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width * 0.45) - HvacSpacing.lg * 2,
          child: _buildTempIndicator(
            context,
            l10n.indoor,
            unit.roomTemp,
            Icons.home,
            HvacColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildTempIndicator(
    BuildContext context,
    String label,
    double? temperature,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: HvacRadius.smRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14.0,
                color: color,
              ),
              const SizedBox(width: HvacSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  style: HvacTypography.labelSmall.copyWith(
                    color: HvacColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.xs),
          Text(
            temperature != null ? '${temperature.toStringAsFixed(1)}°C' : '--',
            style: HvacTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
