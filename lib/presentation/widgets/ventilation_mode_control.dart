/// Ventilation Mode Control Widget
///
/// Compact card for mode selection and fan speed control
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/ventilation_mode.dart';

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

class _VentilationModeControlState extends State<VentilationModeControl> {
  late int _supplyFanSpeed;
  late int _exhaustFanSpeed;
  bool _showModeSelector = false;

  @override
  void initState() {
    super.initState();
    _supplyFanSpeed = widget.unit.supplyFanSpeed ?? 0;
    _exhaustFanSpeed = widget.unit.exhaustFanSpeed ?? 0;
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Power Toggle
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Режим работы',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Управление и настройки',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Custom Mode selector
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showModeSelector = !_showModeSelector;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _showModeSelector
                        ? AppTheme.primaryOrange.withValues(alpha: 0.5)
                        : AppTheme.backgroundCardBorder,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.unit.ventMode?.displayName ?? 'Выберите режим',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      _showModeSelector ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppTheme.primaryOrange,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Mode options with animation
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            firstChild: const SizedBox(height: 0),
            secondChild: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.backgroundCardBorder,
                  width: 1,
                ),
              ),
              child: Column(
                children: VentilationMode.values.map((mode) {
                  final isSelected = widget.unit.ventMode == mode;
                  return _ModeOptionItem(
                    mode: mode,
                    isSelected: isSelected,
                    onTap: () {
                      if (widget.onModeChanged != null) {
                        widget.onModeChanged!(mode);
                      }
                      setState(() {
                        _showModeSelector = false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            crossFadeState: _showModeSelector
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),

          const SizedBox(height: 14),

          // Fan speeds
          _buildFanSpeed(
            'Приточный',
            _supplyFanSpeed,
            Icons.air,
            (speed) {
              setState(() {
                _supplyFanSpeed = speed;
              });
              if (widget.onSupplyFanChanged != null) {
                widget.onSupplyFanChanged!(speed);
              }
            },
          ),

          const SizedBox(height: 12),

          _buildFanSpeed(
            'Вытяжной',
            _exhaustFanSpeed,
            Icons.air,
            (speed) {
              setState(() {
                _exhaustFanSpeed = speed;
              });
              if (widget.onExhaustFanChanged != null) {
                widget.onExhaustFanChanged!(speed);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFanSpeed(
    String label,
    int speed,
    IconData icon,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$speed%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryOrange,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 5,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 9,
              elevation: 3,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 18,
            ),
            activeTrackColor: AppTheme.primaryOrange,
            inactiveTrackColor: AppTheme.backgroundCardBorder,
            thumbColor: Colors.white,
            overlayColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
            valueIndicatorColor: AppTheme.primaryOrange,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Slider(
            value: speed.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            label: '$speed%',
            onChanged: (value) => onChanged(value.round()),
          ),
        ),
      ],
    );
  }
}

/// Mode Option Item with Hover Effect
class _ModeOptionItem extends StatefulWidget {
  final VentilationMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeOptionItem({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ModeOptionItem> createState() => _ModeOptionItemState();
}

class _ModeOptionItemState extends State<_ModeOptionItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.primaryOrange.withValues(alpha: 0.15)
                : _isHovered
                    ? AppTheme.primaryOrange.withValues(alpha: 0.08)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: _isHovered && !widget.isSelected
                ? Border.all(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              if (widget.isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryOrange,
                  size: 18,
                ),
              if (widget.isSelected) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.mode.displayName,
                  style: TextStyle(
                    fontSize: 13,
                    color: widget.isSelected || _isHovered
                        ? AppTheme.primaryOrange
                        : AppTheme.textPrimary,
                    fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
