/// Ventilation Mode Control Widget
///
/// Compact responsive card for mode selection and fan speed control
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/app_radius.dart';
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

class _VentilationModeControlState extends State<VentilationModeControl>
    with SingleTickerProviderStateMixin {
  late int _supplyFanSpeed;
  late int _exhaustFanSpeed;
  bool _showModeSelector = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _supplyFanSpeed = widget.unit.supplyFanSpeed ?? 0;
    _exhaustFanSpeed = widget.unit.exhaustFanSpeed ?? 0;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
    return Container(
      padding: EdgeInsets.all(AppSpacing.mdR),
      decoration: AppTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: AppSpacing.mdR),
          _buildModeSelector(),
          SizedBox(height: AppSpacing.smR + 2.h),
          _buildFanSpeed(
            'Приточный',
            _supplyFanSpeed,
            Icons.air,
            (speed) {
              setState(() => _supplyFanSpeed = speed);
              widget.onSupplyFanChanged?.call(speed);
            },
          ),
          SizedBox(height: AppSpacing.smR),
          _buildFanSpeed(
            'Вытяжной',
            _exhaustFanSpeed,
            Icons.air,
            (speed) {
              setState(() => _exhaustFanSpeed = speed);
              widget.onExhaustFanChanged?.call(speed);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.xsR),
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppRadius.smR),
          ),
          child: Icon(
            Icons.tune,
            color: AppTheme.primaryOrange,
            size: 20.sp,
          ),
        ),
        SizedBox(width: AppSpacing.smR),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Режим работы',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Управление и настройки',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelector() {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showModeSelector = !_showModeSelector;
                if (_showModeSelector) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.mdR,
                vertical: AppSpacing.smR,
              ),
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark,
                borderRadius: BorderRadius.circular(AppRadius.mdR),
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
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _showModeSelector ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.primaryOrange,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _fadeAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: EdgeInsets.only(top: AppSpacing.xsR),
              padding: EdgeInsets.all(AppSpacing.xsR),
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark,
                borderRadius: BorderRadius.circular(AppRadius.mdR),
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
                      widget.onModeChanged?.call(mode);
                      setState(() {
                        _showModeSelector = false;
                        _animationController.reverse();
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
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
            Expanded(
              child: Row(
                children: [
                  Icon(icon, size: 16.sp, color: AppTheme.textSecondary),
                  SizedBox(width: AppSpacing.xsR),
                  Flexible(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.smR),
              ),
              child: Text(
                '$speed%',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryOrange,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xsR),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 5.h,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 9.r,
              elevation: 3,
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: 18.r,
            ),
            activeTrackColor: AppTheme.primaryOrange,
            inactiveTrackColor: AppTheme.backgroundCardBorder,
            thumbColor: Colors.white,
            overlayColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
            valueIndicatorColor: AppTheme.primaryOrange,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
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

/// Mode Option Item with Hover Effect and Animation
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
          margin: EdgeInsets.only(bottom: 4.h),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.smR,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.primaryOrange.withValues(alpha: 0.15)
                : _isHovered
                    ? AppTheme.primaryOrange.withValues(alpha: 0.08)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.smR),
            border: _isHovered && !widget.isSelected
                ? Border.all(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              if (widget.isSelected) ...[
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryOrange,
                  size: 18.sp,
                ),
                SizedBox(width: AppSpacing.xsR),
              ],
              Expanded(
                child: Text(
                  widget.mode.displayName,
                  style: TextStyle(
                    fontSize: 13.sp,
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
