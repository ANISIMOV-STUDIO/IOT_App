/// Border radius constants for consistent rounded corners throughout the app
library;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppRadius {
  // Base radius values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double round = 999.0; // For fully rounded elements

  // Responsive radius values
  static double get xsR => xs.r;
  static double get smR => sm.r;
  static double get mdR => md.r;
  static double get lgR => lg.r;
  static double get xlR => xl.r;
  static double get xxlR => xxl.r;
  static double get roundR => round.r;
}
