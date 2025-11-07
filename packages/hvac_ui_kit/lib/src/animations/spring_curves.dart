/// Spring physics and smooth animation curves
library;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Spring physics constants for natural motion
class SpringConstants {
  // iOS-like smooth spring (no bounce)
  static const SpringDescription smooth = SpringDescription(
    mass: 1.0,
    stiffness: 180.0,
    damping: 22.0,
  );

  // Bouncy spring for playful interactions
  static const SpringDescription bouncy = SpringDescription(
    mass: 1.0,
    stiffness: 200.0,
    damping: 12.0,
  );

  // Snappy spring for quick feedback
  static const SpringDescription snappy = SpringDescription(
    mass: 1.0,
    stiffness: 280.0,
    damping: 24.0,
  );

  // Interactive spring for draggable elements
  static const SpringDescription interactive = SpringDescription(
    mass: 1.0,
    stiffness: 220.0,
    damping: 20.0,
  );

  // Gentle spring for subtle animations
  static const SpringDescription gentle = SpringDescription(
    mass: 1.0,
    stiffness: 120.0,
    damping: 18.0,
  );
}

/// Smooth animation curves optimized for perceived smoothness
class SmoothCurves {
  // Ease curves (Material Design 3)
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;

  // Emphasized curves (Material Design 3)
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;
  static const Curve emphasizedDecelerate = Curves.easeOutCubic;
  static const Curve emphasizedAccelerate = Curves.easeInCubic;

  // Custom smooth curves
  static const Curve smoothEntry = Cubic(0.0, 0.0, 0.2, 1.0);
  static const Curve smoothExit = Cubic(0.4, 0.0, 1.0, 1.0);
  static const Curve silky = Cubic(0.25, 0.1, 0.25, 1.0);
}
