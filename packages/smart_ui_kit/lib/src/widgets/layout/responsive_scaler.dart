import 'dart:math';
import 'package:flutter/material.dart';

/// How to calculate scale factor
enum ScaleMode {
  /// Use minimum of width/height scale (letterbox, no overflow)
  contain,

  /// Scale based on width only (may need vertical scroll)
  widthBased,

  /// Scale based on height only (may need horizontal scroll)
  heightBased,

  /// Use maximum of width/height scale (fill, may overflow)
  cover,
}

/// Scales content from design resolution to actual screen size
/// Keeps proportions, no layout breaking
class ResponsiveScaler extends StatelessWidget {
  final Widget child;
  final double designWidth;
  final double designHeight;
  final double minScale;
  final double maxScale;
  final ScaleMode scaleMode;

  const ResponsiveScaler({
    super.key,
    required this.child,
    this.designWidth = 1920,
    this.designHeight = 1080,
    this.minScale = 0.5,
    this.maxScale = 1.5,
    this.scaleMode = ScaleMode.contain,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / designWidth;
        final scaleY = constraints.maxHeight / designHeight;

        final double scale;
        switch (scaleMode) {
          case ScaleMode.contain:
            scale = min(scaleX, scaleY);
          case ScaleMode.widthBased:
            scale = scaleX;
          case ScaleMode.heightBased:
            scale = scaleY;
          case ScaleMode.cover:
            scale = max(scaleX, scaleY);
        }

        final clampedScale = scale.clamp(minScale, maxScale);

        return Center(
          child: Transform.scale(
            scale: clampedScale,
            alignment: Alignment.center,
            child: SizedBox(
              width: designWidth,
              height: designHeight,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Even simpler - uses FittedBox for automatic scaling
class FittedScaler extends StatelessWidget {
  final Widget child;
  final double designWidth;
  final double designHeight;

  const FittedScaler({
    super.key,
    required this.child,
    this.designWidth = 1920,
    this.designHeight = 1080,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,
      child: SizedBox(
        width: designWidth,
        height: designHeight,
        child: child,
      ),
    );
  }
}
