/// Refactored optimized HVAC card with extracted components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../hvac_card/card_container.dart';
import '../hvac_card/card_header.dart';
import '../hvac_card/temperature_display.dart';
import '../hvac_card/status_indicators.dart';
import '../hvac_card/control_buttons.dart';

/// Optimized HVAC Unit Card - Refactored version under 200 lines
///
/// Key features:
/// - Responsive design for mobile, tablet, and desktop
/// - Web-friendly hover states and interactions
/// - Modular component architecture
/// - Performance optimized with RepaintBoundary
class OptimizedHvacCard extends StatefulWidget {
  final HvacUnit unit;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onPowerChanged;
  final ValueChanged<double>? onTemperatureChanged;
  final bool isSelected;

  const OptimizedHvacCard({
    super.key,
    required this.unit,
    this.onTap,
    this.onPowerChanged,
    this.onTemperatureChanged,
    this.isSelected = false,
  });

  @override
  State<OptimizedHvacCard> createState() => _OptimizedHvacCardState();
}

class _OptimizedHvacCardState extends State<OptimizedHvacCard>
    with AutomaticKeepAliveClientMixin {
  late bool _isPowerOn;
  late double _targetTemperature;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _isPowerOn = widget.unit.power;
    _targetTemperature = widget.unit.targetTemp;
  }

  @override
  void didUpdateWidget(OptimizedHvacCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.unit.id != widget.unit.id) {
      setState(() {
        _isPowerOn = widget.unit.power;
        _targetTemperature = widget.unit.targetTemp;
      });
    }
  }

  void _handlePowerToggle(bool value) {
    setState(() => _isPowerOn = value);
    widget.onPowerChanged?.call(value);
  }

  void _handleTemperatureDecrease() {
    if (_targetTemperature > 16) {
      setState(() => _targetTemperature -= 0.5);
      widget.onTemperatureChanged?.call(_targetTemperature);
    }
  }

  void _handleTemperatureIncrease() {
    if (_targetTemperature < 30) {
      setState(() => _targetTemperature += 0.5);
      widget.onTemperatureChanged?.call(_targetTemperature);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 350;
          final isTablet = constraints.maxWidth >= 600;

          return HvacCardContainer(
            isSelected: widget.isSelected,
            onTap: widget.onTap,
            child: Padding(
              padding: EdgeInsets.all(
                isCompact ? HvacSpacing.md.w : HvacSpacing.lg.w,
              ),
              child: _buildCardContent(isCompact, isTablet),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardContent(bool isCompact, bool isTablet) {
    if (isTablet) {
      return _buildTabletLayout(isCompact);
    } else {
      return _buildMobileLayout(isCompact);
    }
  }

  Widget _buildMobileLayout(bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HvacCardHeader(
          name: widget.unit.name,
          location: widget.unit.location,
          isPowerOn: _isPowerOn,
          onPowerChanged: _handlePowerToggle,
          isCompact: isCompact,
        ),
        SizedBox(height: HvacSpacing.md.h),
        TemperatureDisplay(
          currentTemp: widget.unit.currentTemp,
          targetTemp: _targetTemperature,
          isPowerOn: _isPowerOn,
          isCompact: isCompact,
        ),
        SizedBox(height: HvacSpacing.md.h),
        StatusIndicators(
          humidity: widget.unit.humidity,
          fanSpeed: widget.unit.fanSpeed,
          mode: widget.unit.mode,
          isCompact: isCompact,
        ),
        SizedBox(height: HvacSpacing.lg.h),
        TemperatureControlButtons(
          onDecrease: _handleTemperatureDecrease,
          onIncrease: _handleTemperatureIncrease,
          isEnabled: _isPowerOn,
          isCompact: isCompact,
        ),
      ],
    );
  }

  Widget _buildTabletLayout(bool isCompact) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              HvacCardHeader(
                name: widget.unit.name,
                location: widget.unit.location,
                isPowerOn: _isPowerOn,
                onPowerChanged: _handlePowerToggle,
                isCompact: isCompact,
              ),
              SizedBox(height: HvacSpacing.md.h),
              TemperatureDisplay(
                currentTemp: widget.unit.currentTemp,
                targetTemp: _targetTemperature,
                isPowerOn: _isPowerOn,
                isCompact: false,
              ),
            ],
          ),
        ),
        SizedBox(width: HvacSpacing.lg.w),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusIndicators(
                humidity: widget.unit.humidity,
                fanSpeed: widget.unit.fanSpeed,
                mode: widget.unit.mode,
                isCompact: true,
              ),
              SizedBox(height: HvacSpacing.md.h),
              TemperatureControlButtons(
                onDecrease: _handleTemperatureDecrease,
                onIncrease: _handleTemperatureIncrease,
                isEnabled: _isPowerOn,
                isCompact: isCompact,
              ),
            ],
          ),
        ),
      ],
    );
  }
}