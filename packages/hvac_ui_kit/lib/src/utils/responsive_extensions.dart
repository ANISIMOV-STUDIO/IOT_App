/// Responsive Extensions for Flutter
///
/// Provides responsive sizing extensions for consistent UI across devices
/// Based on 375px (iPhone) design width and 812px design height
library;

import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Responsive configuration and extensions
class ResponsiveConfig {
  static const double baseWidth = 375.0; // iPhone 11 Pro width
  static const double baseHeight = 812.0; // iPhone 11 Pro height
  static const double baseFontScale = 1.0;

  // Singleton instance
  static final ResponsiveConfig _instance = ResponsiveConfig._internal();
  factory ResponsiveConfig() => _instance;
  ResponsiveConfig._internal();

  // Screen dimensions
  late double screenWidth;
  late double screenHeight;
  late double statusBarHeight;
  late double bottomBarHeight;
  late double devicePixelRatio;
  late double textScaleFactor;

  // Scaling factors
  late double scaleWidth;
  late double scaleHeight;
  late double scaleText;
  late double scaleRadius;

  /// Initialize responsive configuration
  void init(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    statusBarHeight = mediaQuery.padding.top;
    bottomBarHeight = mediaQuery.padding.bottom;
    devicePixelRatio = mediaQuery.devicePixelRatio;
    textScaleFactor = mediaQuery.textScaler.scale(1.0);

    // Calculate scaling factors
    scaleWidth = screenWidth / baseWidth;
    scaleHeight = screenHeight / baseHeight;

    // Use minimum scale for text to prevent oversizing
    scaleText = math.min(scaleWidth, scaleHeight);

    // Limit text scale factor to prevent accessibility issues
    if (textScaleFactor > 1.3) {
      scaleText = scaleText * 0.9;
    }

    // Radius scales with minimum dimension
    scaleRadius = math.min(scaleWidth, scaleHeight);
  }

  /// Get responsive width
  double setWidth(num width) => width * scaleWidth;

  /// Get responsive height
  double setHeight(num height) => height * scaleHeight;

  /// Get responsive font size
  double setSp(num fontSize) => fontSize * scaleText;

  /// Get responsive radius
  double setRadius(num radius) => radius * scaleRadius;

  /// Check device type
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  /// Get adaptive value based on device type
  T adaptive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Get orientation
  bool get isPortrait => screenHeight > screenWidth;
  bool get isLandscape => screenWidth > screenHeight;
}

/// Global instance for easy access
final ResponsiveConfig responsive = ResponsiveConfig();

/// Extension on num for responsive sizing
extension ResponsiveExtension on num {
  /// Responsive width
  double get w => responsive.setWidth(this);

  /// Responsive height
  double get h => responsive.setHeight(this);

  /// Responsive font size
  double get sp => responsive.setSp(this);

  /// Responsive radius
  double get r => responsive.setRadius(this);

  /// Get actual screen width percentage
  double get sw => responsive.screenWidth * (this / 100);

  /// Get actual screen height percentage
  double get sh => responsive.screenHeight * (this / 100);
}

/// Extension on EdgeInsets for responsive padding/margin
extension EdgeInsetsExtension on EdgeInsets {
  /// Scale all EdgeInsets values
  EdgeInsets get r => copyWith(
    left: left.w,
    right: right.w,
    top: top.h,
    bottom: bottom.h,
  );

  /// Scale horizontal values only
  EdgeInsets get rh => copyWith(
    left: left.w,
    right: right.w,
  );

  /// Scale vertical values only
  EdgeInsets get rv => copyWith(
    top: top.h,
    bottom: bottom.h,
  );
}

/// Extension on BorderRadius for responsive radius
extension BorderRadiusExtension on BorderRadius {
  /// Scale all BorderRadius values
  BorderRadius get r {
    return BorderRadius.only(
      topLeft: topLeft.r,
      topRight: topRight.r,
      bottomLeft: bottomLeft.r,
      bottomRight: bottomRight.r,
    );
  }
}

/// Extension on Radius for responsive radius
extension RadiusExtension on Radius {
  /// Scale radius value
  Radius get r => Radius.elliptical(x.r, y.r);
}

/// Responsive widget wrapper
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    ResponsiveConfig responsive,
  ) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize responsive config
    responsive.init(context);

    return builder(context, responsive);
  }
}

/// Adaptive layout widget
class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    responsive.init(context);

    if (responsive.isDesktop && desktop != null) {
      return desktop!;
    }
    if (responsive.isTablet && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Responsive spacing helper
class ResponsiveSpacing {
  ResponsiveSpacing._();

  // Base spacing values (will be scaled)
  static double get xxs => 4.w;
  static double get xs => 8.w;
  static double get sm => 12.w;
  static double get md => 16.w;
  static double get lg => 24.w;
  static double get xl => 32.w;
  static double get xxl => 48.w;
  static double get xxxl => 64.w;

  // Responsive EdgeInsets
  static EdgeInsets get paddingAllXxs => EdgeInsets.all(xxs);
  static EdgeInsets get paddingAllXs => EdgeInsets.all(xs);
  static EdgeInsets get paddingAllSm => EdgeInsets.all(sm);
  static EdgeInsets get paddingAllMd => EdgeInsets.all(md);
  static EdgeInsets get paddingAllLg => EdgeInsets.all(lg);
  static EdgeInsets get paddingAllXl => EdgeInsets.all(xl);

  static EdgeInsets get paddingHorizontalMd =>
      EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get paddingVerticalMd =>
      EdgeInsets.symmetric(vertical: md);
}

/// Responsive text styles
class ResponsiveTextStyles {
  ResponsiveTextStyles._();

  static TextStyle headline1 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle headline2 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle headline3 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle headline4 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle caption = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
}

/// Initialize responsive system
class ResponsiveInit extends StatelessWidget {
  final Widget child;

  const ResponsiveInit({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize on first build
    responsive.init(context);

    // Re-initialize on orientation change
    return OrientationBuilder(
      builder: (context, orientation) {
        responsive.init(context);
        return child;
      },
    );
  }
}