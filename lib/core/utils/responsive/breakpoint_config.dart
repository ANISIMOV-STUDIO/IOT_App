/// Breakpoint Configuration
///
/// Defines screen size breakpoints for responsive layouts
library;

/// Device type enumeration
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Breakpoint configuration for responsive layouts
class BreakpointConfig {
  final double mobile;
  final double tablet;
  final double desktop;

  const BreakpointConfig({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  /// Default breakpoints (600, 1024, 1440)
  static const BreakpointConfig defaultConfig = BreakpointConfig(
    mobile: 600,
    tablet: 1024,
    desktop: 1440,
  );

  /// Material 3 breakpoints
  static const BreakpointConfig material3 = BreakpointConfig(
    mobile: 600,
    tablet: 840,
    desktop: 1240,
  );

  /// Bootstrap breakpoints
  static const BreakpointConfig bootstrap = BreakpointConfig(
    mobile: 576,
    tablet: 768,
    desktop: 1200,
  );

  /// Get device type based on screen width
  DeviceType getDeviceType(double width) {
    if (width < mobile) {
      return DeviceType.mobile;
    } else if (width < tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }
}
