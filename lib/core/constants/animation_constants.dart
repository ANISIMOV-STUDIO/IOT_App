/// Animation Constants
/// Defines standard animation durations and curves for consistent animations
library;

import 'package:flutter/animation.dart';

class AnimationConstants {
  // Animation Durations
  static const Duration veryFast = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 600);

  // Animation Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve fastCurve = Curves.easeOut;
  static const Curve slowCurve = Curves.easeIn;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;

  // Shimmer Animation
  static const Duration shimmerDuration = Duration(milliseconds: 1500);
  static const Curve shimmerCurve = Curves.linear;

  // Card Animation
  static const Duration cardFadeIn = normal;
  static const Duration cardSlideIn = medium;
  static const Curve cardCurve = smoothCurve;

  // Page Transition
  static const Duration pageTransition = normal;
  static const Curve pageTransitionCurve = defaultCurve;

  // Button Press
  static const Duration buttonPress = fast;
  static const Curve buttonCurve = fastCurve;

  // Loading State
  static const Duration loadingFade = normal;
  static const Duration loadingRotation = Duration(milliseconds: 1000);

  // Delays
  static const Duration shortDelay = Duration(milliseconds: 100);
  static const Duration mediumDelay = Duration(milliseconds: 200);
  static const Duration longDelay = Duration(milliseconds: 300);
}
