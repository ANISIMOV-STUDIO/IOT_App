/// Smooth animation curves optimized for perceived smoothness
library;

import 'package:flutter/material.dart';

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