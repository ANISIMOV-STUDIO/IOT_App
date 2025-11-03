/// Card header with unit info and power switch
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'control_buttons.dart';

/// Header section of HVAC card with title and power control
class HvacCardHeader extends StatelessWidget {
  final String name;
  final String? location;
  final bool isPowerOn;
  final ValueChanged<bool>? onPowerChanged;
  final bool isCompact;

  const HvacCardHeader({
    super.key,
    required this.name,
    this.location,
    required this.isPowerOn,
    this.onPowerChanged,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildInfo(),
        ),
        if (onPowerChanged != null)
          PowerSwitch(
            value: isPowerOn,
            onChanged: onPowerChanged!,
          ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AnimatedText(
          text: name,
          style: TextStyle(
            fontSize: isCompact ? 16.sp : 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        if (location != null && location!.isNotEmpty) ...[
          SizedBox(height: HvacSpacing.xs.h),
          _AnimatedText(
            text: location!,
            style: TextStyle(
              fontSize: isCompact ? 12.sp : 14.sp,
              color: Colors.white70,
            ),
            delay: 100,
          ),
        ],
      ],
    );
  }
}

/// Animated text with fade and slide effect
class _AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int delay;

  const _AnimatedText({
    required this.text,
    required this.style,
    this.delay = 0,
  });

  @override
  State<_AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<_AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Text(
              widget.text,
              style: widget.style,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}