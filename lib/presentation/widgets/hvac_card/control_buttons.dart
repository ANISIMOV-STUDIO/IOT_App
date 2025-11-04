/// Control buttons widget with web-responsive design
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../utils/ripple_painter.dart';

/// Control buttons for temperature adjustment
class TemperatureControlButtons extends StatelessWidget {
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  final bool isEnabled;
  final bool isCompact;

  const TemperatureControlButtons({
    super.key,
    this.onDecrease,
    this.onIncrease,
    this.isEnabled = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ControlButton(
            icon: Icons.remove,
            onPressed: isEnabled ? onDecrease : null,
            isDecrease: true,
            isCompact: isCompact,
          ),
        ),
        SizedBox(width: HvacSpacing.md.w),
        Expanded(
          child: _ControlButton(
            icon: Icons.add,
            onPressed: isEnabled ? onIncrease : null,
            isDecrease: false,
            isCompact: isCompact,
          ),
        ),
      ],
    );
  }
}

/// Individual control button with hover and press effects
class _ControlButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDecrease;
  final bool isCompact;

  const _ControlButton({
    required this.icon,
    this.onPressed,
    required this.isDecrease,
    this.isCompact = false,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  late AnimationController _scaleController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = true);
    _scaleController.forward();
    _rippleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    _scaleController.reverse();
    widget.onPressed?.call();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _rippleController.reverse();
      }
    });
  }

  void _handleTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    _scaleController.reverse();
    _rippleController.reverse();
  }

  Color get _buttonColor {
    if (widget.onPressed == null) {
      return HvacColors.textPrimary.withValues(alpha: 0.05);
    }
    if (_isPressed) {
      return widget.isDecrease
          ? HvacColors.primaryBlue.withValues(alpha: 0.3)
          : HvacColors.primaryOrange.withValues(alpha: 0.3);
    }
    if (_isHovered) {
      return widget.isDecrease
          ? HvacColors.primaryBlue.withValues(alpha: 0.2)
          : HvacColors.primaryOrange.withValues(alpha: 0.2);
    }
    return HvacColors.textPrimary.withValues(alpha: 0.1);
  }

  Color get _iconColor {
    if (widget.onPressed == null) {
      return HvacColors.textSecondary.withValues(alpha: 0.5);
    }
    if (_isPressed || _isHovered) {
      return widget.isDecrease
          ? HvacColors.primaryBlue
          : HvacColors.primaryOrange;
    }
    return HvacColors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _rippleAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                height: widget.isCompact ? 36.h : 40.h,
                decoration: BoxDecoration(
                  color: _buttonColor,
                  borderRadius: BorderRadius.circular(HvacRadius.md.r),
                  border: Border.all(
                    color: _isHovered
                        ? (widget.isDecrease
                            ? HvacColors.primaryBlue.withValues(alpha: 0.5)
                            : HvacColors.primaryOrange.withValues(alpha: 0.5))
                        : Colors.transparent,
                    width: _isHovered ? 2 : 1,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ripple effect
                    if (_rippleAnimation.value > 0)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(HvacRadius.md.r),
                          child: CustomPaint(
                            painter: RipplePainter(
                              progress: _rippleAnimation.value,
                              color: widget.isDecrease
                                  ? HvacColors.primaryBlue
                                  : HvacColors.primaryOrange,
                            ),
                          ),
                        ),
                      ),
                    // Icon
                    Icon(
                      widget.icon,
                      color: _iconColor,
                      size: widget.isCompact ? 18.sp : 20.sp,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Power switch with web-friendly hover states
class PowerSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PowerSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<PowerSwitch> createState() => _PowerSwitchState();
}

class _PowerSwitchState extends State<PowerSwitch> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Transform.scale(
        scale: _isHovered ? 1.05 : 1.0,
        child: Switch.adaptive(
          value: widget.value,
          onChanged: widget.onChanged,
          activeThumbColor: HvacColors.primaryBlue,
          activeTrackColor: HvacColors.primaryBlue.withValues(alpha: 0.5),
          inactiveThumbColor: HvacColors.textSecondary,
          inactiveTrackColor: HvacColors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}