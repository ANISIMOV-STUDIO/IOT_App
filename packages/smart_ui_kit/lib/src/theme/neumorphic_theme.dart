import 'package:flutter/material.dart';
import 'tokens/neumorphic_colors.dart';
import 'tokens/neumorphic_shadows.dart';
import 'tokens/neumorphic_spacing.dart';
import 'tokens/neumorphic_typography.dart';

/// Neumorphic Theme - Complete Design System
/// Provides unified access to all design tokens
class NeumorphicTheme extends InheritedWidget {
  final NeumorphicThemeData data;

  const NeumorphicTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static NeumorphicThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<NeumorphicTheme>();
    return theme?.data ?? NeumorphicThemeData.light();
  }
  
  /// Check if current theme is dark
  static bool isDark(BuildContext context) => of(context).isDark;

  @override
  bool updateShouldNotify(NeumorphicTheme oldWidget) => data != oldWidget.data;
}

/// Neumorphic Theme Data - Holds all design tokens
class NeumorphicThemeData {
  final bool isDark;
  final NeumorphicColorsData colors;
  final NeumorphicShadows shadows;
  final NeumorphicTypography typography;

  const NeumorphicThemeData._({
    required this.isDark,
    required this.colors,
    required this.shadows,
    required this.typography,
  });

  /// Light theme preset
  factory NeumorphicThemeData.light() => NeumorphicThemeData._(
    isDark: false,
    colors: NeumorphicColorsData.light(),
    shadows: NeumorphicShadows.light,
    typography: NeumorphicTypography.light,
  );

  /// Dark theme preset
  factory NeumorphicThemeData.dark() => NeumorphicThemeData._(
    isDark: true,
    colors: NeumorphicColorsData.dark(),
    shadows: NeumorphicShadows.dark,
    typography: NeumorphicTypography.dark,
  );

  /// Convert to Material ThemeData
  ThemeData toMaterialTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: colors.surface,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: NeumorphicColors.accentPrimary,
        onPrimary: Colors.white,
        secondary: NeumorphicColors.accentInfo,
        onSecondary: Colors.white,
        error: NeumorphicColors.accentError,
        onError: Colors.white,
        surface: colors.cardSurface,
        onSurface: colors.textPrimary,
      ),
      textTheme: _buildTextTheme(),
      iconTheme: IconThemeData(
        color: colors.textSecondary,
        size: NeumorphicSpacing.iconMd,
      ),
      dividerTheme: DividerThemeData(
        color: colors.textTertiary.withValues(alpha: 0.2),
        thickness: 1,
      ),
    );
  }

  TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: typography.displayLarge,
      displayMedium: typography.displayMedium,
      displaySmall: typography.displaySmall,
      headlineLarge: typography.headlineLarge,
      headlineMedium: typography.headlineMedium,
      headlineSmall: typography.headlineSmall,
      titleLarge: typography.titleLarge,
      titleMedium: typography.titleMedium,
      titleSmall: typography.titleSmall,
      bodyLarge: typography.bodyLarge,
      bodyMedium: typography.bodyMedium,
      bodySmall: typography.bodySmall,
      labelLarge: typography.labelLarge,
      labelMedium: typography.labelMedium,
      labelSmall: typography.labelSmall,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeumorphicThemeData && isDark == other.isDark;

  @override
  int get hashCode => isDark.hashCode;
}

/// Resolved color values for current theme
class NeumorphicColorsData {
  final Color surface;
  final Color cardSurface;
  final Color shadowDark;
  final Color shadowLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  const NeumorphicColorsData._({
    required this.surface,
    required this.cardSurface,
    required this.shadowDark,
    required this.shadowLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
  });

  factory NeumorphicColorsData.light() => const NeumorphicColorsData._(
    surface: NeumorphicColors.lightSurface,
    cardSurface: NeumorphicColors.lightCardSurface,
    shadowDark: NeumorphicColors.lightShadowDark,
    shadowLight: NeumorphicColors.lightShadowLight,
    textPrimary: NeumorphicColors.lightTextPrimary,
    textSecondary: NeumorphicColors.lightTextSecondary,
    textTertiary: NeumorphicColors.lightTextTertiary,
  );

  factory NeumorphicColorsData.dark() => const NeumorphicColorsData._(
    surface: NeumorphicColors.darkSurface,
    cardSurface: NeumorphicColors.darkCardSurface,
    shadowDark: NeumorphicColors.darkShadowDark,
    shadowLight: NeumorphicColors.darkShadowLight,
    textPrimary: NeumorphicColors.darkTextPrimary,
    textSecondary: NeumorphicColors.darkTextSecondary,
    textTertiary: NeumorphicColors.darkTextTertiary,
  );
  
  // Static accent colors (same for both themes)
  static Color get accent => NeumorphicColors.accentPrimary;
  static Color get success => NeumorphicColors.accentSuccess;
  static Color get warning => NeumorphicColors.accentWarning;
  static Color get error => NeumorphicColors.accentError;
  static Color get info => NeumorphicColors.accentInfo;
  
  // Climate mode colors
  static Color get heating => NeumorphicColors.modeHeating;
  static Color get cooling => NeumorphicColors.modeCooling;
  static Color get dry => NeumorphicColors.modeDry;
  static Color get auto => NeumorphicColors.modeAuto;
}
