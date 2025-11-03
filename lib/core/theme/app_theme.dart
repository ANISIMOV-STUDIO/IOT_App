/// Smart Home App Theme
/// Based on Figma design with dark background and orange accents
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_radius.dart';
import 'spacing.dart';

class AppTheme {
  // ============================================================================
  // PREMIUM LUXURY COLOR PALETTE 2025
  // Based on research: Midnight & Gold, High-End Brands (Apple, Tesla)
  // Philosophy: Monochromatic + Single Noble Accent
  // ============================================================================

  // PRIMARY ACCENT - Neutral Gray (replacing gold with sophisticated gray)
  // Elegant gray that maintains luxury feel without brightness
  static const Color accent = Color(0xFF9CA3AF); // Sophisticated Gray
  static const Color accentDark = Color(0xFF6B7280); // Dark Gray
  static const Color accentLight = Color(0xFFD1D5DB); // Light Gray
  static const Color accentSubtle = Color(0x339CA3AF); // Gray with 20% opacity

  // BACKGROUNDS - Deep Charcoal & Midnight Blue
  // Creates depth and sophistication, not pure black
  static const Color backgroundDark = Color(0xFF0A0E27); // Midnight Blue-Black
  static const Color backgroundCard = Color(0xFF131829); // Charcoal Blue
  static const Color backgroundCardBorder = Color(0xFF1F2539); // Subtle Border
  static const Color backgroundElevated = Color(0xFF1A2035); // Elevated Surface

  // TEXT - High contrast with subtle variations
  static const Color textPrimary = Color(0xFFFAFAFA); // Pure White (slight warm)
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% White
  static const Color textTertiary = Color(0x66FFFFFF); // 40% White
  static const Color textDisabled = Color(0x33FFFFFF); // 20% White

  // MONOCHROMATIC SHADES - For data visualization and states
  // Using shades of blue-gray for sophisticated, non-colorful look
  static const Color neutral100 = Color(0xFF8B95A8); // Light Blue-Gray
  static const Color neutral200 = Color(0xFF6B7589); // Medium Blue-Gray
  static const Color neutral300 = Color(0xFF4E5668); // Dark Blue-Gray
  static const Color neutral400 = Color(0xFF353C4F); // Very Dark Blue-Gray

  // SEMANTIC COLORS - Muted, not bright
  // Success: Deep emerald green (not bright green)
  static const Color success = Color(0xFF2E8B57); // Sea Green
  static const Color successSubtle = Color(0x332E8B57);

  // Error: Deep crimson (not bright red)
  static const Color error = Color(0xFFC53030); // Deep Crimson
  static const Color errorSubtle = Color(0x33C53030);

  // Warning: Amber (muted, not bright yellow/orange)
  static const Color warning = Color(0xFFD97706); // Amber
  static const Color warningSubtle = Color(0x33D97706);

  // Info: Steel Blue (muted, not bright blue)
  static const Color info = Color(0xFF4682B4); // Steel Blue
  static const Color infoSubtle = Color(0x334682B4);

  // TEMPERATURE GRADIENT - Monochromatic with subtle warmth/cool
  // Using blue-grays with slight temperature tint
  static const Color tempCold = Color(0xFF5B7C99); // Cool Blue-Gray
  static const Color tempNeutral = Color(0xFF7788A0); // Neutral Gray
  static const Color tempWarm = Color(0xFF8B7E77); // Warm Gray

  // GLASSMORPHISM - Frosted Glass & Shimmer Effects (2025)
  // White/light elements with blur and transparency
  static const Color glassWhite = Color(0xFFFFFFFF); // Pure white for glass
  static const Color glassLight = Color(0xFFF8FAFC); // Very light gray
  static const Color glassBorder = Color(0x40FFFFFF); // 25% white for borders
  static const Color glassShimmerBase = Color(0x1AFFFFFF); // 10% white base
  static const Color glassShimmerHighlight = Color(0x40FFFFFF); // 25% white highlight

  // Blur sigma values for BackdropFilter
  static const double blurLight = 8.0; // Light frosted glass
  static const double blurMedium = 12.0; // Medium frosted glass
  static const double blurHeavy = 20.0; // Heavy frosted glass

  // LEGACY COMPATIBILITY - Map old colors to new palette
  static const Color primaryOrange = accent; // Gold instead of orange
  static const Color primaryOrangeDark = accentDark;
  static const Color primaryOrangeLight = accentLight;
  static const Color primaryOrangeBorder = accentSubtle;

  // Device Mode Colors - ALL MONOCHROMATIC now (no rainbow)
  // Using neutral shades with subtle accent tint
  static const Color modeCool = neutral100; // Light shade
  static const Color modeHeat = neutral200; // Medium shade
  static const Color modeFan = neutral300; // Dark shade
  static const Color modeDry = neutral200; // Medium shade
  static const Color modeAuto = accent; // Only mode with gold accent

  // Control Card Heights
  static const double controlCardHeight = 280.0; // Fixed height for all control widgets

  // Compatibility aliases for new widgets
  static const Color cardDark = backgroundCard;
  static const Color borderColor = backgroundCardBorder;
  static const Color primaryBlue = neutral100; // Monochromatic

  // GRADIENTS - Subtle, sophisticated
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient subtleGradient = LinearGradient(
    colors: [backgroundCard, backgroundElevated],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x1AFFFFFF), // 10% white
      Color(0x0DFFFFFF), // 5% white
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme - Premium Luxury
      colorScheme: const ColorScheme.dark(
        primary: accent, // Royal Gold
        secondary: neutral100, // Monochromatic accent
        surface: backgroundCard, // Charcoal Blue
        error: error, // Deep Crimson
        onPrimary: backgroundDark, // Dark text on gold
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onError: textPrimary,
      ),

      scaffoldBackgroundColor: backgroundDark,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: backgroundCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: backgroundCardBorder,
            width: 1,
          ),
        ),
      ),

      // Bottom Navigation Bar Theme - Luxury Minimal
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundDark,
        selectedItemColor: accent, // Gold for selected
        unselectedItemColor: neutral200, // Muted gray for unselected
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),

      // Text Theme - All sizes responsive with .sp
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 57.sp,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontSize: 45.sp,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 36.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: textTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: backgroundCardBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: backgroundCardBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryOrange,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: error,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Elevated Button Theme - Luxury Gold
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent, // Royal Gold
          foregroundColor: backgroundDark, // Dark text on gold
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.mdR),
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5, // Luxury spacing
          ),
        ),
      ),

      // Switch Theme - Monochromatic with Gold accent
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textPrimary; // White thumb
          }
          return neutral200; // Gray thumb when off
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accent; // Gold when on
          }
          return neutral300; // Dark gray when off
        }),
      ),

      // Slider Theme - Monochromatic with Gold accent
      sliderTheme: const SliderThemeData(
        activeTrackColor: accent, // Gold for active
        inactiveTrackColor: neutral300, // Gray for inactive
        thumbColor: textPrimary, // White thumb
        overlayColor: accentSubtle, // Subtle gold overlay
        trackHeight: 4,
      ),
    );
  }

  /// Get color for device mode - MONOCHROMATIC (no rainbow)
  /// All modes use neutral shades except Auto which gets gold accent
  static Color getModeColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'cool':
      case 'cooling':
        return neutral100; // Light gray (was blue)
      case 'heat':
      case 'heating':
        return neutral200; // Medium gray (was red)
      case 'fan':
      case 'fan_only':
        return neutral300; // Dark gray (was green)
      case 'dry':
        return neutral200; // Medium gray (was yellow)
      case 'auto':
        return accent; // ONLY mode with gold
      default:
        return accent; // Default to gold
    }
  }

  // Responsive Padding Helpers
  static EdgeInsets get paddingXs => const EdgeInsets.all(AppSpacing.xs);
  static EdgeInsets get paddingSm => const EdgeInsets.all(AppSpacing.sm);
  static EdgeInsets get paddingMd => const EdgeInsets.all(AppSpacing.md);
  static EdgeInsets get paddingLg => const EdgeInsets.all(AppSpacing.lg);
  static EdgeInsets get paddingXl => const EdgeInsets.all(AppSpacing.xl);

  static EdgeInsets get screenPadding => const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      );

  static EdgeInsets get cardPadding => const EdgeInsets.all(AppSpacing.lg);

  /// Device Card Decoration - Luxury style
  static BoxDecoration deviceCard({bool isSelected = false}) {
    return BoxDecoration(
      color: backgroundCard,
      borderRadius: BorderRadius.circular(AppRadius.lgR),
      border: Border.all(
        color: isSelected ? accent : backgroundCardBorder, // Gold when selected
        width: isSelected ? 2 : 1,
      ),
      // Subtle glow when selected
      boxShadow: isSelected
          ? [
              const BoxShadow(
                color: accentSubtle,
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
          : null,
    );
  }

  /// Rounded Card Decoration - Sophisticated
  static BoxDecoration roundedCard({Color? color, bool hasBorder = true}) {
    return BoxDecoration(
      color: color ?? backgroundCard,
      borderRadius: BorderRadius.circular(AppRadius.lgR),
      border: hasBorder
          ? Border.all(
              color: backgroundCardBorder,
              width: 1,
            )
          : null,
      // Subtle inner shadow for depth
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Card Shadow
  static List<BoxShadow> cardShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  /// Accent Button Decoration - Luxury Gold
  static BoxDecoration accentButton() {
    return BoxDecoration(
      gradient: primaryGradient, // Gold gradient
      borderRadius: BorderRadius.circular(AppRadius.mdR),
      boxShadow: const [
        BoxShadow(
          color: accentSubtle,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  /// Legacy: Orange button (now gold)
  static BoxDecoration orangeButton() => accentButton();

  /// Device Image Placeholder
  static BoxDecoration deviceImagePlaceholder() {
    return BoxDecoration(
      color: backgroundCard,
      borderRadius: BorderRadius.circular(AppRadius.mdR),
      border: Border.all(
        color: backgroundCardBorder,
        width: 1,
      ),
    );
  }
}
