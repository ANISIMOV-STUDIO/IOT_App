/// Typography Scale - Consistent font sizes across the app
/// Based on common patterns: 10, 12, 14, 16, 18, 20, 24, 32, 48
library;

/// Font size scale for consistent typography
abstract class AppTypography {
  // Scale (each step is ~1.2x previous, rounded)
  static const double xs = 10.0; // Chart labels, badge counts
  static const double sm = 12.0; // Secondary text, labels
  static const double base = 14.0; // Body text
  static const double md = 16.0; // Card titles
  static const double lg = 18.0; // Section headers
  static const double xl = 20.0; // Large numbers
  static const double xxl = 24.0; // Hero numbers
  static const double display = 32.0; // Display text
  static const double displayLg = 48.0; // Temperature display

  // Semantic aliases
  static const double caption = xs; // 10
  static const double label = sm; // 12
  static const double body = base; // 14
  static const double title = md; // 16
  static const double sectionTitle = lg; // 18
  static const double statValue = xl; // 20
  static const double heroValue = xxl; // 24
}
