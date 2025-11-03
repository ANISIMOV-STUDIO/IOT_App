/// Temperature Display - Refactored (2025)
///
/// Main orchestrator for temperature monitoring widget
/// Delegates to specific layout implementations based on device size
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'temperature/temperature_mobile_layout.dart';
import 'temperature/temperature_tablet_layout.dart';

// Re-export the temperature badge for backward compatibility
export 'temperature/temperature_badge.dart';

/// Main temperature display widget that adapts to different screen sizes
///
/// This widget serves as the orchestrator, delegating the actual rendering
/// to device-specific layout implementations following the Single
/// Responsibility Principle.
///
/// Features:
/// - Adaptive layout for mobile and tablet
/// - Real-time temperature monitoring for supply, extract, outdoor, and indoor
/// - Efficiency calculations and system status indicators
/// - Smooth animations and performance optimizations
class TemperatureDisplayCompact extends StatelessWidget {
  /// Temperature of supply air in Celsius
  final double? supplyTemp;

  /// Temperature of extract air in Celsius
  final double? extractTemp;

  /// Outdoor temperature in Celsius
  final double? outdoorTemp;

  /// Indoor temperature in Celsius
  final double? indoorTemp;

  /// Whether to use compact mode (deprecated, kept for compatibility)
  final bool isCompact;

  const TemperatureDisplayCompact({
    super.key,
    this.supplyTemp,
    this.extractTemp,
    this.outdoorTemp,
    this.indoorTemp,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        switch (deviceSize) {
          case DeviceSize.compact:
            return TemperatureMobileLayout(
              supplyTemp: supplyTemp,
              extractTemp: extractTemp,
              outdoorTemp: outdoorTemp,
              indoorTemp: indoorTemp,
            );
          case DeviceSize.medium:
          case DeviceSize.expanded:
            // Both tablet and desktop use the same layout for now
            // Desktop shows more cards in grid due to more columns
            return TemperatureTabletLayout(
              supplyTemp: supplyTemp,
              extractTemp: extractTemp,
              outdoorTemp: outdoorTemp,
              indoorTemp: indoorTemp,
            );
        }
      },
    );
  }
}
