/// Temperature Grid Layout
///
/// Responsive grid layout for temperature cards
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';

class TemperatureGridLayout extends StatelessWidget {
  final HvacUnit unit;

  const TemperatureGridLayout({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    if (isMobile) {
      return _buildMobileLayout();
    }

    return _buildDesktopLayout(context);
  }

  Widget _buildMobileLayout() {
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
            const SizedBox(width: 12.0),
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
          const SizedBox(height: 12.0),
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
                const SizedBox(width: 12.0),
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

  Widget _buildDesktopLayout(BuildContext context) {
    final width = _calculateCardWidth(context);

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: [
        SizedBox(
          width: width,
          child: _TempCard(
            icon: Icons.download,
            label: 'Приток',
            value: unit.supplyAirTemp,
            color: HvacColors.info,
            isPrimary: true,
          ),
        ),
        SizedBox(
          width: width,
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
            width: width,
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
            width: width,
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
      return (width - 100.0) / 2;
    } else {
      return 150.0;
    }
  }
}

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
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isPrimary ? 16.0 : 12.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: isPrimary
              ? color.withValues(alpha: 0.3)
              : HvacColors.backgroundCardBorder,
          width: isPrimary ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: HvacRadius.smRadius,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isPrimary ? 20.0 : 16.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isPrimary ? 13.0 : 11.0,
                    color: HvacColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            value != null ? '${value!.toStringAsFixed(1)}°C' : '--°C',
            style: TextStyle(
              fontSize: isPrimary ? 24.0 : 20.0,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
