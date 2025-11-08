/// Ventilation Mode Control Widget
///
/// Adaptive responsive card for mode selection and fan speed control
/// Uses big-tech adaptive layout system
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:hvac_ui_kit/src/utils/adaptive_layout.dart' as adaptive;
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/ventilation_mode.dart';
import 'ventilation/mode_control_components.dart';

class VentilationModeControl extends StatefulWidget {
  final HvacUnit unit;
  final ValueChanged<VentilationMode>? onModeChanged;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;

  const VentilationModeControl({
    super.key,
    required this.unit,
    this.onModeChanged,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
  });

  @override
  State<VentilationModeControl> createState() => _VentilationModeControlState();
}

class _VentilationModeControlState extends State<VentilationModeControl>
    with SingleTickerProviderStateMixin {
  late int _supplyFanSpeed;
  late int _exhaustFanSpeed;
  bool _showModeSelector = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _supplyFanSpeed = widget.unit.supplyFanSpeed ?? 0;
    _exhaustFanSpeed = widget.unit.exhaustFanSpeed ?? 0;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(VentilationModeControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.unit.supplyFanSpeed != widget.unit.supplyFanSpeed) {
      _supplyFanSpeed = widget.unit.supplyFanSpeed ?? 0;
    }
    if (oldWidget.unit.exhaustFanSpeed != widget.unit.exhaustFanSpeed) {
      _exhaustFanSpeed = widget.unit.exhaustFanSpeed ?? 0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PerformanceUtils.isolateRepaint(
      child: AdaptiveControl(
        builder: (context, deviceSize) {
          final isDesktop = deviceSize == DeviceSize.expanded;
          return Container(
            padding: isDesktop
                ? const EdgeInsets.all(12.0)
                : adaptive.AdaptiveLayout.controlPadding(context),
            decoration: BoxDecoration(
              color: HvacColors.backgroundCard,
              borderRadius: BorderRadius.circular(
                adaptive.AdaptiveLayout.borderRadius(context, base: 16),
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
                      ModeControlHeader(unit: widget.unit, onModeToggle: _toggleModeSelector, showModeSelector: _showModeSelector),
                      SizedBox(
                          height: isDesktop
                              ? 8.0
                              : (deviceSize == DeviceSize.compact
                                  ? 12.0
                                  : adaptive.AdaptiveLayout.spacing(context,
                                      base: 12))),
                      ModeSelector(currentMode: widget.unit.mode, onModeChanged: widget.onModeChanged),
                      SizedBox(
                          height: isDesktop
                              ? 8.0
                              : (deviceSize == DeviceSize.compact
                                  ? 12.0
                                  : adaptive.AdaptiveLayout.spacing(context,
                                      base: 12))),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: PerformanceUtils.getOptimalScrollPhysics(
                            context,
                            bouncing: true,
                            alwaysScrollable: false,
                          ),
                          child: FanSpeedControls(supplyFanSpeed: _supplyFanSpeed, exhaustFanSpeed: _exhaustFanSpeed, onSupplyFanChanged: widget.onSupplyFanChanged, onExhaustFanChanged: widget.onExhaustFanChanged),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Mobile layout without height constraint - smooth scrolling
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ModeControlHeader(unit: widget.unit, onModeToggle: _toggleModeSelector, showModeSelector: _showModeSelector),
                      SizedBox(
                          height: deviceSize == DeviceSize.compact
                              ? 12.0
                              : adaptive.AdaptiveLayout.spacing(context,
                                  base: 12)),
                      ModeSelector(currentMode: widget.unit.mode, onModeChanged: widget.onModeChanged),
                      SizedBox(
                          height: deviceSize == DeviceSize.compact
                              ? 12.0
                              : adaptive.AdaptiveLayout.spacing(context,
                                  base: 12)),
                      FanSpeedControls(supplyFanSpeed: _supplyFanSpeed, exhaustFanSpeed: _exhaustFanSpeed, onSupplyFanChanged: widget.onSupplyFanChanged, onExhaustFanChanged: widget.onExhaustFanChanged),
                    ],
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }



}
