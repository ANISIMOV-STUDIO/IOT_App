/// Ventilation Mode Control Widget
///
/// Adaptive responsive card for mode selection and fan speed control
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
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
  State<VentilationModeControl> createState() =>
      _VentilationModeControlState();
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

  void _toggleModeSelector() {
    setState(() {
      _showModeSelector = !_showModeSelector;
      if (_showModeSelector) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return HvacCard(
      padding: EdgeInsets.all(isMobile ? HvacSpacing.md : HvacSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ModeControlHeader(
            mode: widget.unit.mode,
            onModeToggle: _toggleModeSelector,
            showModeSelector: _showModeSelector,
          ),
          const SizedBox(height: HvacSpacing.md),
          FanSpeedControls(
            supplyFanSpeed: _supplyFanSpeed,
            exhaustFanSpeed: _exhaustFanSpeed,
            onSupplyFanChanged: widget.onSupplyFanChanged,
            onExhaustFanChanged: widget.onExhaustFanChanged,
          ),
        ],
      ),
    );
  }
}
