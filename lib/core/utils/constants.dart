/// Application Constants
library;

class AppConstants {
  // Temperature range
  static const double minTemperature = 16.0;
  static const double maxTemperature = 30.0;
  static const double defaultTemperature = 22.0;

  // UI Constants - Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 600; // Tablet starts at 600px
  static const double desktopBreakpoint = 1200;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
}

/// HVAC Mode enumeration
enum HvacMode {
  cooling,
  heating,
  fan,
  auto;

  String get displayName {
    switch (this) {
      case HvacMode.cooling:
        return 'Cooling';
      case HvacMode.heating:
        return 'Heating';
      case HvacMode.fan:
        return 'Fan';
      case HvacMode.auto:
        return 'Auto';
    }
  }
}

/// Fan Speed enumeration
enum FanSpeed {
  low,
  medium,
  high,
  auto;

  String get displayName {
    switch (this) {
      case FanSpeed.low:
        return 'Low';
      case FanSpeed.medium:
        return 'Medium';
      case FanSpeed.high:
        return 'High';
      case FanSpeed.auto:
        return 'Auto';
    }
  }
}
