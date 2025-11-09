/// Scanner Animation Line Widget
///
/// Animated scanning line for QR scanner overlay using HVAC UI Kit
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class ScannerAnimationLine extends StatefulWidget {
  final double frameSize;
  final Color color;

  const ScannerAnimationLine({
    super.key,
    required this.frameSize,
    required this.color,
  });

  @override
  State<ScannerAnimationLine> createState() => _ScannerAnimationLineState();
}

class _ScannerAnimationLineState extends State<ScannerAnimationLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Use HVAC UI Kit's animation controller creation
    _controller = SmoothAnimations.createController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.frameSize - 4.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: SmoothCurves.emphasized,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.color.withValues(alpha: 0),
                  widget.color,
                  widget.color.withValues(alpha: 0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.5),
                  blurRadius: 8.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
