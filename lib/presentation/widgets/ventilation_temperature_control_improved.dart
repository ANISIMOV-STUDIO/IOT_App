/// Ventilation Temperature Control Improved Widget
///
/// Fixed alignment and layout issues
/// Compact, modern design with proper responsive behavior
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/hvac_unit.dart';
import 'temperature_display_compact.dart';

class VentilationTemperatureControlImproved extends StatelessWidget {
  final HvacUnit unit;

  const VentilationTemperatureControlImproved({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    // Use the new compact temperature display widget
    if (isMobile) {
      return TemperatureDisplayCompact(
        supplyTemp: unit.supplyAirTemp,
        extractTemp: unit.roomTemp,
        outdoorTemp: unit.outdoorTemp,
        indoorTemp: unit.roomTemp,
        isCompact: true,
      );
    }

    // For tablet and desktop, use the full layout
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: isTablet ? 250.h : 300.h,
      ),
      child: TemperatureDisplayCompact(
        supplyTemp: unit.supplyAirTemp,
        extractTemp: unit.roomTemp,
        outdoorTemp: unit.outdoorTemp,
        indoorTemp: unit.roomTemp,
        isCompact: false,
      ),
    );
  }
}

/// Alternative compact grid layout
class TemperatureGridCompact extends StatelessWidget {
  final HvacUnit unit;

  const TemperatureGridCompact({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.lgRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),

          SizedBox(height: 16.h),

          // Temperature Grid
          _buildTemperatureGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                HvacColors.info.withValues(alpha: 0.2),
                HvacColors.info.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: HvacRadius.smRadius,
          ),
          child: Icon(
            Icons.thermostat_outlined,
            color: HvacColors.info,
            size: 20.w,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Температуры',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Мониторинг и уставки',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: HvacColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureGrid(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    if (isMobile) {
      // Vertical layout for mobile
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _TempCard(
                  icon: Icons.download,
                  label: 'Приток',
                  value: unit.supplyAirTemp,
                  color: HvacColors.info,
                  isPrimary: true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _TempCard(
                  icon: Icons.upload,
                  label: 'Вытяжка',
                  value: unit.roomTemp,
                  color: HvacColors.warning,
                  isPrimary: true,
                ),
              ),
            ],
          ),
          if (unit.outdoorTemp != null || unit.roomTemp != null) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                if (unit.outdoorTemp != null)
                  Expanded(
                    child: _TempCard(
                      icon: Icons.landscape,
                      label: 'Наружный',
                      value: unit.outdoorTemp,
                      color: HvacColors.textSecondary,
                      isPrimary: false,
                    ),
                  ),
                if (unit.outdoorTemp != null && unit.roomTemp != null)
                  SizedBox(width: 12.w),
                if (unit.roomTemp != null)
                  Expanded(
                    child: _TempCard(
                      icon: Icons.home,
                      label: 'Комнатный',
                      value: unit.roomTemp,
                      color: HvacColors.success,
                      isPrimary: false,
                    ),
                  ),
              ],
            ),
          ],
        ],
      );
    }

    // Grid layout for tablet/desktop
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: [
        SizedBox(
          width: _calculateCardWidth(context),
          child: _TempCard(
            icon: Icons.download,
            label: 'Приток',
            value: unit.supplyAirTemp,
            color: HvacColors.info,
            isPrimary: true,
          ),
        ),
        SizedBox(
          width: _calculateCardWidth(context),
          child: _TempCard(
            icon: Icons.upload,
            label: 'Вытяжка',
            value: unit.roomTemp,
            color: HvacColors.warning,
            isPrimary: true,
          ),
        ),
        if (unit.outdoorTemp != null)
          SizedBox(
            width: _calculateCardWidth(context),
            child: _TempCard(
              icon: Icons.landscape,
              label: 'Наружный',
              value: unit.outdoorTemp,
              color: HvacColors.textSecondary,
              isPrimary: false,
            ),
          ),
        if (unit.roomTemp != null)
          SizedBox(
            width: _calculateCardWidth(context),
            child: _TempCard(
              icon: Icons.home,
              label: 'Комнатный',
              value: unit.roomTemp,
              color: HvacColors.success,
              isPrimary: false,
            ),
          ),
      ],
    );
  }

  double _calculateCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = ResponsiveUtils.isTablet(context);

    if (isTablet) {
      // Two columns on tablet
      return (width - 100.w) / 2;
    } else {
      // Four columns on desktop
      return 150.w;
    }
  }
}

/// Individual temperature card
class _TempCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double? value;
  final Color color;
  final bool isPrimary;

  const _TempCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isPrimary ? 0.08 : 0.05),
            color.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: color.withValues(alpha: isPrimary ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: isPrimary ? 18.w : 16.w,
                color: color,
              ),
              SizedBox(width: 6.w),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value != null ? '${value!.toStringAsFixed(1)}°C' : '--',
            style: TextStyle(
              fontSize: isPrimary ? 20.sp : 18.sp,
              fontWeight: FontWeight.w700,
              color: isPrimary ? color : HvacColors.textPrimary,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 300.ms, delay: Duration(milliseconds: isPrimary ? 0 : 100))
      .scale(
        begin: const Offset(0.95, 0.95),
        end: const Offset(1, 1),
        duration: 300.ms,
      );
  }
}