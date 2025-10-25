/// Responsive Helper Utilities
library;

import 'package:flutter/material.dart';
import 'constants.dart';

class ResponsiveHelper {
  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppConstants.mobileBreakpoint &&
        width < AppConstants.desktopBreakpoint;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.desktopBreakpoint;
  }

  /// Get number of grid columns based on screen width
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppConstants.mobileBreakpoint) {
      return 1; // Mobile: 1 column
    } else if (width < AppConstants.tabletBreakpoint) {
      return 2; // Small tablet: 2 columns
    } else if (width < AppConstants.desktopBreakpoint) {
      return 3; // Large tablet: 3 columns
    } else {
      return 4; // Desktop: 4 columns
    }
  }

  /// Check if should use bottom navigation (mobile) vs navigation rail (desktop)
  static bool shouldUseBottomNav(BuildContext context) {
    return isMobile(context);
  }
}
