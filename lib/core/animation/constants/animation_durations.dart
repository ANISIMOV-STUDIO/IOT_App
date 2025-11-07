/// Animation duration constants for 60 FPS targeting
library;

class AnimationDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Micro-interaction durations
  static const Duration microFast = Duration(milliseconds: 150);
  static const Duration microNormal = Duration(milliseconds: 250);

  // Stagger delays
  static const Duration staggerShort = Duration(milliseconds: 50);
  static const Duration staggerMedium = Duration(milliseconds: 100);
  static const Duration staggerLong = Duration(milliseconds: 150);
}