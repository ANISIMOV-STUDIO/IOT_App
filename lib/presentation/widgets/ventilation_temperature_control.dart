/// Ventilation Temperature Control Widget
///
/// Adaptive card for temperature monitoring and setpoints
/// Uses big-tech adaptive layout approach
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/hvac_unit.dart';

class VentilationTemperatureControl extends StatelessWidget {
  final HvacUnit unit;

  const VentilationTemperatureControl({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        return Container(
          padding: AdaptiveLayout.controlPadding(context),
          decoration: BoxDecoration(
            color: HvacColors.backgroundCard,
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 16),
            ),
            border: Border.all(
              color: HvacColors.backgroundCardBorder,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Check if we have a height constraint (desktop layout)
              final hasHeightConstraint =
                  constraints.maxHeight != double.infinity;

              if (hasHeightConstraint) {
                // Desktop layout with constrained height - use scrollable content
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, deviceSize),
                    SizedBox(
                        height:
                            AdaptiveLayout.spacing(context, base: 16)),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: _buildTemperatureGrid(context, deviceSize),
                      ),
                    ),
                  ],
                );
              } else {
                // Mobile layout without height constraint
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context, deviceSize),
                    SizedBox(
                        height:
                            AdaptiveLayout.spacing(context, base: 16)),
                    _buildTemperatureGrid(context, deviceSize),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, DeviceSize deviceSize) {
    return Row(
      children: [
        Container(
          padding:
              EdgeInsets.all(AdaptiveLayout.spacing(context, base: 8)),
          decoration: BoxDecoration(
            color: HvacColors.info.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 8),
            ),
          ),
          child: Icon(
            Icons.thermostat,
            color: HvacColors.info,
            size: AdaptiveLayout.iconSize(context, base: 20),
          ),
        ),
        SizedBox(width: AdaptiveLayout.spacing(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Температуры',
                style: TextStyle(
                  fontSize: AdaptiveLayout.fontSize(context, base: 16),
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2.0),
              Text(
                'Мониторинг и уставки',
                style: TextStyle(
                  fontSize: AdaptiveLayout.fontSize(context, base: 12),
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

  Widget _buildTemperatureGrid(BuildContext context, DeviceSize deviceSize) {
    // Adaptive layout: single column on mobile, grid on tablet/desktop
    switch (deviceSize) {
      case DeviceSize.compact:
        return Column(
          children: [
            _buildTempIndicator(
              context,
              'Приток',
              unit.supplyAirTemp,
              Icons.air,
              HvacColors.info,
            ),
            const SizedBox(height: 8.0),
            _buildTempIndicator(
              context,
              'Вытяжка',
              unit.roomTemp, // Используем roomTemp как температуру вытяжки
              Icons.upload,
              HvacColors.warning,
            ),
            const SizedBox(height: 8.0),
            _buildTempIndicator(
              context,
              'Наружный',
              unit.outdoorTemp,
              Icons.landscape,
              HvacColors.textSecondary,
            ),
            const SizedBox(height: 8.0),
            _buildTempIndicator(
              context,
              'Внутренний',
              unit.roomTemp,
              Icons.home,
              HvacColors.success,
            ),
          ],
        );
      case DeviceSize.medium:
      case DeviceSize.expanded:
        // Grid for tablet/desktop - use flexible layout
        return LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - HvacSpacing.mdR) / 2;
            return Wrap(
              spacing: HvacSpacing.mdR,
              runSpacing: HvacSpacing.mdR,
              children: [
                SizedBox(
                  width: itemWidth,
                  child: _buildTempIndicator(
                    context,
                    'Приток',
                    unit.supplyAirTemp,
                    Icons.air,
                    HvacColors.info,
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _buildTempIndicator(
                    context,
                    'Вытяжка',
                    unit.roomTemp,
                    Icons.upload,
                    HvacColors.warning,
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _buildTempIndicator(
                    context,
                    'Наружный',
                    unit.outdoorTemp,
                    Icons.landscape,
                    HvacColors.textSecondary,
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _buildTempIndicator(
                    context,
                    'Внутренний',
                    unit.roomTemp,
                    Icons.home,
                    HvacColors.success,
                  ),
                ),
              ],
            );
          },
        );
    }
  }

  Widget _buildTempIndicator(
    BuildContext context,
    String label,
    double? temperature,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding:
          EdgeInsets.all(AdaptiveLayout.spacing(context, base: 10)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          AdaptiveLayout.borderRadius(context, base: 12),
        ),
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
                size: AdaptiveLayout.iconSize(context, base: 14),
                color: color,
              ),
              SizedBox(
                  width: AdaptiveLayout.spacing(context, base: 4)),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize:
                        AdaptiveLayout.fontSize(context, base: 11),
                    color: HvacColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: AdaptiveLayout.spacing(context, base: 6)),
          Text(
            temperature != null ? '${temperature.toStringAsFixed(1)}°C' : '--',
            style: TextStyle(
              fontSize: AdaptiveLayout.fontSize(context, base: 20),
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
