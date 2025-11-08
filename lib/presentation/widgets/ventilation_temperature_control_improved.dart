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
import 'temperature/temperature_grid_header.dart';
import 'temperature/temperature_grid_layout.dart';

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
        maxHeight: isTablet ? 250.0 : 300.0,
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
      padding: const EdgeInsets.all(16.0),
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
          const TemperatureGridHeader(),

          const SizedBox(height: 16.0),

          // Temperature Grid
          TemperatureGridLayout(unit: unit),
        ],
      ),
    );
  }



}

/// Individual temperature card
