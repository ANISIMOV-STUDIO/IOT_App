import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart' as np;
import '../../theme/tokens/neumorphic_colors.dart' as colors;
import '../../theme/tokens/neumorphic_typography.dart';
import '../../theme/tokens/neumorphic_shadows.dart';

/// Wrapper that provides both flutter_neumorphic_plus theme and our custom tokens
class NeumorphicTheme extends StatelessWidget {
  final Widget child;
  final NeumorphicThemeData data;

  const NeumorphicTheme({
    super.key,
    required this.child,
    required this.data,
  });

  static NeumorphicThemeData of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_InheritedNeumorphicTheme>();
    return inherited?.data ?? NeumorphicThemeData.light();
  }

  @override
  Widget build(BuildContext context) {
    return np.NeumorphicTheme(
      themeMode: data.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: np.NeumorphicThemeData(
        baseColor: data.colors.cardSurface, // Cards should be lighter than surface
        accentColor: colors.NeumorphicColors.accentPrimary,
        depth: 4,
        intensity: 0.5,
        lightSource: np.LightSource.topLeft,
      ),
      darkTheme: np.NeumorphicThemeData(
        baseColor: data.colors.cardSurface, // Cards should be lighter than surface
        accentColor: colors.NeumorphicColors.accentPrimary,
        depth: 4,
        intensity: 0.3,
        lightSource: np.LightSource.topLeft,
      ),
      child: _InheritedNeumorphicTheme(
        data: data,
        child: child,
      ),
    );
  }
}

class _InheritedNeumorphicTheme extends InheritedWidget {
  final NeumorphicThemeData data;

  const _InheritedNeumorphicTheme({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedNeumorphicTheme oldWidget) => 
      data != oldWidget.data;
}

/// Our custom theme data with additional tokens
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

  factory NeumorphicThemeData.light() => NeumorphicThemeData._(
    isDark: false,
    colors: NeumorphicColorsData.light(),
    shadows: NeumorphicShadows.light,
    typography: NeumorphicTypography.light,
  );

  factory NeumorphicThemeData.dark() => NeumorphicThemeData._(
    isDark: true,
    colors: NeumorphicColorsData.dark(),
    shadows: NeumorphicShadows.dark,
    typography: NeumorphicTypography.dark,
  );

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
    surface: colors.NeumorphicColors.lightSurface,
    cardSurface: colors.NeumorphicColors.lightCardSurface,
    shadowDark: colors.NeumorphicColors.lightShadowDark,
    shadowLight: colors.NeumorphicColors.lightShadowLight,
    textPrimary: colors.NeumorphicColors.lightTextPrimary,
    textSecondary: colors.NeumorphicColors.lightTextSecondary,
    textTertiary: colors.NeumorphicColors.lightTextTertiary,
  );

  factory NeumorphicColorsData.dark() => const NeumorphicColorsData._(
    surface: colors.NeumorphicColors.darkSurface,
    cardSurface: colors.NeumorphicColors.darkCardSurface,
    shadowDark: colors.NeumorphicColors.darkShadowDark,
    shadowLight: colors.NeumorphicColors.darkShadowLight,
    textPrimary: colors.NeumorphicColors.darkTextPrimary,
    textSecondary: colors.NeumorphicColors.darkTextSecondary,
    textTertiary: colors.NeumorphicColors.darkTextTertiary,
  );
  
  // Static accent colors
  static Color get accent => colors.NeumorphicColors.accentPrimary;
  static Color get success => colors.NeumorphicColors.accentSuccess;
  static Color get warning => colors.NeumorphicColors.accentWarning;
  static Color get error => colors.NeumorphicColors.accentError;
  static Color get info => colors.NeumorphicColors.accentInfo;
}
