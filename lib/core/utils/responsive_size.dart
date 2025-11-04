/// Custom responsive size extensions that prevent scaling beyond 1920px
///
/// This replaces flutter_screenutil's .sp, .w, .h on large monitors
library;

import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ResponsiveSizeExtension on num {
  /// Font size with max 1920px screen width limit
  double get spFixed {
    final screenWidth = ScreenUtil().screenWidth;
    final effectiveWidth = screenWidth > 1920 ? 1920.0 : screenWidth;

    // Use 1920 as design width for desktop
    final designWidth = screenWidth >= 1024 ? 1920.0 : 375.0;

    // Calculate scale based on clamped width
    final scale = effectiveWidth / designWidth;
    return this * scale;
  }

  /// Width with max 1920px screen width limit
  double get wFixed {
    final screenWidth = ScreenUtil().screenWidth;
    final effectiveWidth = screenWidth > 1920 ? 1920.0 : screenWidth;

    final designWidth = screenWidth >= 1024 ? 1920.0 : 375.0;

    final scale = effectiveWidth / designWidth;
    return this * scale;
  }

  /// Height with max 1080px screen height limit
  double get hFixed {
    final screenHeight = ScreenUtil().screenHeight;
    final effectiveHeight = screenHeight > 1080 ? 1080.0 : screenHeight;

    final designHeight = screenHeight >= 600 ? 1080.0 : 812.0;

    final scale = effectiveHeight / designHeight;
    return this * scale;
  }

  /// Radius with max 1920px screen width limit
  double get rFixed {
    return wFixed;
  }
}
