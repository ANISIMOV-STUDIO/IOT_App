/// Ventilation Temperature Control Widget
///
/// Adaptive card for temperature monitoring and setpoints
/// Uses big-tech adaptive layout approach
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';
import '../../core/utils/adaptive_layout.dart';
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
            color: AppTheme.backgroundCard,
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 16),
            ),
            border: Border.all(
              color: AppTheme.backgroundCardBorder,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Check if we have a height constraint (desktop layout)
              final hasHeightConstraint = constraints.maxHeight != double.infinity;

              if (hasHeightConstraint) {
                // Desktop layout with constrained height - use scrollable content
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, deviceSize),
                    SizedBox(height: AdaptiveLayout.spacing(context, base: 20)),
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
                    SizedBox(height: AdaptiveLayout.spacing(context, base: 20)),
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
          padding: EdgeInsets.all(AdaptiveLayout.spacing(context, base: 8)),
          decoration: BoxDecoration(
            color: AppTheme.info.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 8),
            ),
          ),
          child: Icon(
            Icons.thermostat,
            color: AppTheme.info,
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
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 2.h),
              Text(
                'Мониторинг и уставки',
                style: TextStyle(
                  fontSize: AdaptiveLayout.fontSize(context, base: 12),
                  color: AppTheme.textSecondary,
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
    if (deviceSize == DeviceSize.compact) {
      return Column(
        children: [
          _buildTempIndicator(
            context,
            'Приток',
            unit.supplyAirTemp,
            Icons.air,
            AppTheme.info,
          ),
          SizedBox(height: 8.h),
          _buildTempIndicator(
            context,
            'Вытяжка',
            unit.roomTemp, // Используем roomTemp как температуру вытяжки
            Icons.upload,
            AppTheme.warning,
          ),
          SizedBox(height: 8.h),
          _buildTempIndicator(
            context,
            'Наружный',
            unit.outdoorTemp,
            Icons.landscape,
            AppTheme.textSecondary,
          ),
          SizedBox(height: 8.h),
          _buildTempIndicator(
            context,
            'Внутренний',
            unit.roomTemp,
            Icons.home,
            AppTheme.success,
          ),
        ],
      );
    } else {
      // Grid for tablet/desktop
      return Wrap(
        spacing: AppSpacing.mdR,
        runSpacing: AppSpacing.mdR,
        children: [
          SizedBox(
            width: deviceSize == DeviceSize.medium ?
              (MediaQuery.of(context).size.width - 100.w) / 2 : 180.w,
            child: _buildTempIndicator(
              context,
              'Приток',
              unit.supplyAirTemp,
              Icons.air,
              AppTheme.info,
            ),
          ),
          SizedBox(
            width: deviceSize == DeviceSize.medium ?
              (MediaQuery.of(context).size.width - 100.w) / 2 : 180.w,
            child: _buildTempIndicator(
              context,
              'Вытяжка',
              unit.roomTemp,
              Icons.upload,
              AppTheme.warning,
            ),
          ),
          SizedBox(
            width: deviceSize == DeviceSize.medium ?
              (MediaQuery.of(context).size.width - 100.w) / 2 : 180.w,
            child: _buildTempIndicator(
              context,
              'Наружный',
              unit.outdoorTemp,
              Icons.landscape,
              AppTheme.textSecondary,
            ),
          ),
          SizedBox(
            width: deviceSize == DeviceSize.medium ?
              (MediaQuery.of(context).size.width - 100.w) / 2 : 180.w,
            child: _buildTempIndicator(
              context,
              'Внутренний',
              unit.roomTemp,
              Icons.home,
              AppTheme.success,
            ),
          ),
        ],
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
      padding: EdgeInsets.all(AdaptiveLayout.spacing(context, base: 10)),
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
              SizedBox(width: AdaptiveLayout.spacing(context, base: 4)),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AdaptiveLayout.fontSize(context, base: 11),
                    color: AppTheme.textSecondary,
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
