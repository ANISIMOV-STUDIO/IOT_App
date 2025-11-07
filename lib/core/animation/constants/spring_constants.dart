/// Spring physics constants for natural motion
library;

import 'package:flutter/physics.dart';

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
