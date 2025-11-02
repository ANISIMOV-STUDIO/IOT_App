/// Ventilation Mode Control Widget
///
/// Adaptive responsive card for mode selection and fan speed control
/// Uses big-tech adaptive layout system
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/adaptive_layout.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/ventilation_mode.dart';
import 'common/adaptive_slider.dart';

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
    return AdaptiveControl(
      builder: (context, deviceSize) {
        final children = [
          _buildHeader(context, deviceSize),
          SizedBox(height: AdaptiveLayout.spacing(context, base: 16)),
          _buildModeSelector(context, deviceSize),
          SizedBox(height: AdaptiveLayout.spacing(context, base: 16)),
          _buildFanSpeedControls(context, deviceSize),
        ];

        // Add spacer only on desktop for equal heights
        if (deviceSize != DeviceSize.compact) {
          children.add(const Spacer());
        }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
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
            color: AppTheme.primaryOrange.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 8),
            ),
          ),
          child: Icon(
            Icons.tune,
            color: AppTheme.primaryOrange,
            size: AdaptiveLayout.iconSize(context, base: 20),
          ),
        ),
        SizedBox(width: AdaptiveLayout.spacing(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Режим работы',
                style: TextStyle(
                  fontSize: AdaptiveLayout.fontSize(context, base: 16),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                widget.unit.ventMode?.displayName ?? 'Базовый',
                style: TextStyle(
                  fontSize: AdaptiveLayout.fontSize(context, base: 12),
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelector(BuildContext context, DeviceSize deviceSize) {
    return GestureDetector(
      onTap: () {
        setState(() => _showModeSelector = !_showModeSelector);
        if (_showModeSelector) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AdaptiveLayout.spacing(context, base: 12),
          vertical: AdaptiveLayout.spacing(context, base: 10),
        ),
        decoration: BoxDecoration(
          color: AppTheme.primaryOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(
            AdaptiveLayout.borderRadius(context, base: 12),
          ),
          border: Border.all(
            color: AppTheme.primaryOrange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.unit.ventMode?.displayName ?? 'Базовый',
                style: TextStyle(
                  fontSize: AdaptiveLayout.fontSize(context, base: 14),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryOrange,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              _showModeSelector
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: AppTheme.primaryOrange,
              size: AdaptiveLayout.iconSize(context, base: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFanSpeedControls(BuildContext context, DeviceSize deviceSize) {
    // Adaptive layout: stack on mobile, side-by-side on tablet/desktop
    if (deviceSize == DeviceSize.compact) {
      return Column(
        children: [
          AdaptiveSlider(
            label: 'Приточный вентилятор',
            icon: Icons.air,
            value: _supplyFanSpeed,
            max: 100,
            onChanged: (speed) {
              setState(() => _supplyFanSpeed = speed);
              widget.onSupplyFanChanged?.call(speed);
            },
            color: AppTheme.info,
          ),
          SizedBox(height: AdaptiveLayout.spacing(context, base: 16)),
          AdaptiveSlider(
            label: 'Вытяжной вентилятор',
            icon: Icons.upload,
            value: _exhaustFanSpeed,
            max: 100,
            onChanged: (speed) {
              setState(() => _exhaustFanSpeed = speed);
              widget.onExhaustFanChanged?.call(speed);
            },
            color: AppTheme.warning,
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AdaptiveSlider(
              label: 'Приточный',
              icon: Icons.air,
              value: _supplyFanSpeed,
              max: 100,
              onChanged: (speed) {
                setState(() => _supplyFanSpeed = speed);
                widget.onSupplyFanChanged?.call(speed);
              },
              color: AppTheme.info,
            ),
          ),
          SizedBox(width: AdaptiveLayout.spacing(context, base: 24)),
          Expanded(
            child: AdaptiveSlider(
              label: 'Вытяжной',
              icon: Icons.upload,
              value: _exhaustFanSpeed,
              max: 100,
              onChanged: (speed) {
                setState(() => _exhaustFanSpeed = speed);
                widget.onExhaustFanChanged?.call(speed);
              },
              color: AppTheme.warning,
            ),
          ),
        ],
      );
    }
  }
}
