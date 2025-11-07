/// Temperature display widget with web-responsive design
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Displays current and target temperature with animations
class TemperatureDisplay extends StatelessWidget {
  final double currentTemp;
  final double targetTemp;
  final bool isPowerOn;
  final bool isCompact;

  const TemperatureDisplay({
    super.key,
    required this.currentTemp,
    required this.targetTemp,
    required this.isPowerOn,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isPowerOn ? 1.0 : 0.5,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 250 && !isCompact) {
              return _buildHorizontalLayout();
            } else {
              return _buildVerticalLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TemperatureValue(
          label: 'Current',
          value: currentTemp,
          isPrimary: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _AnimatedArrow(isPowerOn: isPowerOn),
        ),
        _TemperatureValue(
          label: 'Target',
          value: targetTemp,
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      children: [
        _TemperatureValue(
          label: 'Current',
          value: currentTemp,
          isPrimary: true,
          isCompact: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Transform.rotate(
            angle: 1.5708, // 90 degrees in radians
            child: _AnimatedArrow(isPowerOn: isPowerOn),
          ),
        ),
        _TemperatureValue(
          label: 'Target',
          value: targetTemp,
          isPrimary: false,
          isCompact: true,
        ),
      ],
    );
  }
}

/// Individual temperature value display with hover effect
class _TemperatureValue extends StatefulWidget {
  final String label;
  final double value;
  final bool isPrimary;
  final bool isCompact;

  const _TemperatureValue({
    required this.label,
    required this.value,
    required this.isPrimary,
    this.isCompact = false,
  });

  @override
  State<_TemperatureValue> createState() => _TemperatureValueState();
}

class _TemperatureValueState extends State<_TemperatureValue>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: widget.isCompact ? 11.0 : 12.0,
                    color:
                        _isHovered ? HvacColors.primaryOrange : Colors.white54,
                  ),
                ),
                const SizedBox(height: 4.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: _isHovered
                      ? BoxDecoration(
                          color: widget.isPrimary
                              ? HvacColors.primaryBlue.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(6.0),
                        )
                      : null,
                  child: Text(
                    '${widget.value.toStringAsFixed(1)}°',
                    style: TextStyle(
                      fontSize: widget.isPrimary
                          ? (widget.isCompact ? 24.0 : 28.0)
                          : (widget.isCompact ? 20.0 : 24.0),
                      fontWeight: FontWeight.bold,
                      color: widget.isPrimary
                          ? HvacColors.primaryBlue
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Animated arrow indicator
class _AnimatedArrow extends StatefulWidget {
  final bool isPowerOn;

  const _AnimatedArrow({required this.isPowerOn});

  @override
  State<_AnimatedArrow> createState() => _AnimatedArrowState();
}

class _AnimatedArrowState extends State<_AnimatedArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isPowerOn) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_AnimatedArrow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPowerOn != oldWidget.isPowerOn) {
      if (widget.isPowerOn) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Icon(
            Icons.arrow_forward,
            color: widget.isPowerOn ? HvacColors.primaryOrange : Colors.white54,
            size: 20.0,
          ),
        );
      },
    );
  }
}
