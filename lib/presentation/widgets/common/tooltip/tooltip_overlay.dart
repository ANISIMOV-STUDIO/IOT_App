/// Tooltip Overlay Component
///
/// Handles the overlay rendering and positioning logic for tooltips
library;

import 'package:flutter/material.dart';
import 'tooltip_types.dart';

/// Overlay widget that displays the tooltip content
class WebTooltipOverlay extends StatelessWidget {
  final Offset targetOffset;
  final Size targetSize;
  final String? message;
  final Widget? richContent;
  final TooltipPosition position;
  final Color backgroundColor;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Animation<double> animation;

  const WebTooltipOverlay({
    super.key,
    required this.targetOffset,
    required this.targetSize,
    this.message,
    this.richContent,
    required this.position,
    required this.backgroundColor,
    required this.textStyle,
    required this.padding,
    required this.borderRadius,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Stack(
            children: [
              Positioned(
                left: _calculateLeft(context),
                top: _calculateTop(context),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: padding,
                    child: richContent ??
                        Text(
                          message ?? '',
                          style: textStyle,
                        ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _calculateLeft(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const tooltipWidth = 200.0; // Approximate width

    switch (position) {
      case TooltipPosition.top:
      case TooltipPosition.bottom:
        final centerX =
            targetOffset.dx + targetSize.width / 2 - tooltipWidth / 2;
        return centerX.clamp(8, screenWidth - tooltipWidth - 8);

      case TooltipPosition.left:
        return (targetOffset.dx - tooltipWidth - 8)
            .clamp(8, screenWidth - tooltipWidth - 8);

      case TooltipPosition.right:
        return (targetOffset.dx + targetSize.width + 8)
            .clamp(8, screenWidth - tooltipWidth - 8);

      case TooltipPosition.topStart:
      case TooltipPosition.bottomStart:
        return targetOffset.dx.clamp(8, screenWidth - tooltipWidth - 8);

      case TooltipPosition.topEnd:
      case TooltipPosition.bottomEnd:
        return (targetOffset.dx + targetSize.width - tooltipWidth)
            .clamp(8, screenWidth - tooltipWidth - 8);
    }
  }

  double _calculateTop(BuildContext context) {
    const tooltipHeight = 40.0; // Approximate height
    final screenHeight = MediaQuery.of(context).size.height;

    switch (position) {
      case TooltipPosition.top:
      case TooltipPosition.topStart:
      case TooltipPosition.topEnd:
        return (targetOffset.dy - tooltipHeight - 8)
            .clamp(8, screenHeight - tooltipHeight - 8);

      case TooltipPosition.bottom:
      case TooltipPosition.bottomStart:
      case TooltipPosition.bottomEnd:
        return (targetOffset.dy + targetSize.height + 8)
            .clamp(8, screenHeight - tooltipHeight - 8);

      case TooltipPosition.left:
      case TooltipPosition.right:
        final centerY =
            targetOffset.dy + targetSize.height / 2 - tooltipHeight / 2;
        return centerY.clamp(8, screenHeight - tooltipHeight - 8);
    }
  }
}
