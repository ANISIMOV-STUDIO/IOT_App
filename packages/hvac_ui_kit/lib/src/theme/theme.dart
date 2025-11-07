/// HVAC UI Kit - Theme System
///
/// Complete Material 3 theme with HVAC-specific styling
library;

import 'package:flutter/material.dart';

import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';
import 'radius.dart';

/// Main theme class for HVAC UI Kit
///
/// Provides complete Material 3 theme with:
/// - Dark mode optimized color scheme
/// - Responsive typography
/// - Custom component themes
/// - Helper methods for common decorations
class HvacTheme {
  HvacTheme._(); // Private constructor

  // ============================================================================
  // DARK THEME
  // ============================================================================

  /// Create dark theme with HVAC styling
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme - Premium Luxury
      colorScheme: const ColorScheme.dark(
        primary: HvacColors.accent,
        secondary: HvacColors.neutral100,
        surface: HvacColors.backgroundCard,
        error: HvacColors.error,
        onPrimary: HvacColors.backgroundDark,
        onSecondary: HvacColors.textPrimary,
        onSurface: HvacColors.textPrimary,
        onError: HvacColors.textPrimary,
      ),

      scaffoldBackgroundColor: HvacColors.backgroundDark,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: HvacColors.textPrimary),
        titleTextStyle: TextStyle(
          color: HvacColors.textPrimary,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: HvacColors.backgroundCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.lg),
          side: const BorderSide(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: HvacColors.backgroundDark,
        selectedItemColor: HvacColors.accent,
        unselectedItemColor: HvacColors.neutral200,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),

      // Text Theme - Using HvacTypography
      textTheme: HvacTypography.createTextTheme(),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: HvacColors.textPrimary,
        size: 24,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HvacColors.backgroundCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HvacRadius.md),
          borderSide: const BorderSide(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HvacRadius.md),
          borderSide: const BorderSide(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HvacRadius.md),
          borderSide: const BorderSide(
            color: HvacColors.accent,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HvacRadius.md),
          borderSide: const BorderSide(
            color: HvacColors.error,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.md,
          vertical: HvacSpacing.md,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HvacColors.accent,
          foregroundColor: HvacColors.backgroundDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.lg,
            vertical: HvacSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HvacRadius.md),
          ),
          textStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: HvacColors.accent,
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.md,
            vertical: HvacSpacing.sm,
          ),
          textStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: HvacColors.accent,
          side: const BorderSide(
            color: HvacColors.accent,
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.lg,
            vertical: HvacSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HvacRadius.md),
          ),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HvacColors.textPrimary;
          }
          return HvacColors.neutral200;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HvacColors.accent;
          }
          return HvacColors.neutral300;
        }),
      ),

      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: HvacColors.accent,
        inactiveTrackColor: HvacColors.neutral300,
        thumbColor: HvacColors.textPrimary,
        overlayColor: HvacColors.accentSubtle,
        trackHeight: 4,
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HvacColors.accent;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(HvacColors.backgroundDark),
        side: const BorderSide(
          color: HvacColors.backgroundCardBorder,
          width: 2,
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HvacColors.accent;
          }
          return HvacColors.neutral300;
        }),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: HvacColors.backgroundCard,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.lg),
          side: const BorderSide(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        titleTextStyle: TextStyle(
          color: HvacColors.textPrimary,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: HvacColors.textSecondary,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: HvacColors.backgroundCard,
        modalBackgroundColor: HvacColors.backgroundCard,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(HvacRadius.xl),
          ),
          side: const BorderSide(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: HvacColors.backgroundCard,
        contentTextStyle: TextStyle(
          color: HvacColors.textPrimary,
          fontSize: 14.0,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.md),
          side: const BorderSide(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
      ),

      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: HvacColors.backgroundElevated,
          borderRadius: BorderRadius.circular(HvacRadius.sm),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        textStyle: TextStyle(
          color: HvacColors.textPrimary,
          fontSize: 12.0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.sm,
          vertical: HvacSpacing.xs,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: HvacColors.backgroundCard,
        selectedColor: HvacColors.accent,
        disabledColor: HvacColors.neutral400,
        padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.sm,
          vertical: HvacSpacing.xs,
        ),
        labelStyle: TextStyle(
          color: HvacColors.textPrimary,
          fontSize: 14.0,
        ),
        secondaryLabelStyle: TextStyle(
          color: HvacColors.backgroundDark,
          fontSize: 14.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.md),
          side: const BorderSide(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: HvacColors.backgroundCardBorder,
        thickness: 1,
        space: 1,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: HvacColors.accent,
        linearTrackColor: HvacColors.neutral300,
        circularTrackColor: HvacColors.neutral300,
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS - Decorations
  // ============================================================================

  /// Device Card Decoration - Luxury style with selection state
  static BoxDecoration deviceCard({bool isSelected = false}) {
    return BoxDecoration(
      color: HvacColors.backgroundCard,
      borderRadius: BorderRadius.circular(HvacRadius.lg),
      border: Border.all(
        color: isSelected ? HvacColors.accent : HvacColors.backgroundCardBorder,
        width: isSelected ? 2 : 1,
      ),
      // Subtle glow when selected
      boxShadow: isSelected
          ? [
              const BoxShadow(
                color: HvacColors.accentSubtle,
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
          : null,
    );
  }

  /// Rounded Card Decoration - Sophisticated
  static BoxDecoration roundedCard({
    Color? color,
    bool hasBorder = true,
  }) {
    return BoxDecoration(
      color: color ?? HvacColors.backgroundCard,
      borderRadius: BorderRadius.circular(HvacRadius.lg),
      border: hasBorder
          ? Border.all(
              color: HvacColors.backgroundCardBorder,
              width: 1,
            )
          : null,
      // Subtle shadow for depth
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Card Shadow - Standard elevation
  static List<BoxShadow> cardShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  /// Accent Button Decoration - Luxury Gold with gradient
  static BoxDecoration accentButton() {
    return BoxDecoration(
      gradient: HvacColors.primaryGradient,
      borderRadius: BorderRadius.circular(HvacRadius.md),
      boxShadow: const [
        BoxShadow(
          color: HvacColors.accentSubtle,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  /// Glassmorphism Card - Frosted glass effect
  static BoxDecoration glassCard() {
    return BoxDecoration(
      gradient: HvacColors.glassGradient,
      borderRadius: BorderRadius.circular(HvacRadius.lg),
      border: Border.all(
        color: HvacColors.glassBorder,
        width: 1,
      ),
    );
  }

  /// Device Image Placeholder
  static BoxDecoration deviceImagePlaceholder() {
    return BoxDecoration(
      color: HvacColors.backgroundCard,
      borderRadius: BorderRadius.circular(HvacRadius.md),
      border: Border.all(
        color: HvacColors.backgroundCardBorder,
        width: 1,
      ),
    );
  }

  /// Subtle Background Gradient
  static BoxDecoration subtleGradient() {
    return BoxDecoration(
      gradient: HvacColors.subtleGradient,
      borderRadius: BorderRadius.circular(HvacRadius.lg),
    );
  }

  /// Orange Button Decoration - For legacy compatibility
  /// Creates an orange gradient button decoration
  static BoxDecoration orangeButton() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          HvacColors.primaryOrange,
          HvacColors.primaryOrangeDark,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(HvacRadius.md),
      boxShadow: [
        BoxShadow(
          color: HvacColors.primaryOrange.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
