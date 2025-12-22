import 'package:flutter/material.dart';
import 'glass_colors.dart';
import 'tokens/neumorphic_typography.dart';

/// Glass Design System Theme Provider
class GlassTheme extends StatelessWidget {
  final Widget child;
  final GlassThemeData data;

  const GlassTheme({
    super.key,
    required this.child,
    required this.data,
  });

  static GlassThemeData of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_InheritedGlassTheme>();
    return inherited?.data ?? GlassThemeData.light();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedGlassTheme(
      data: data,
      child: child,
    );
  }
}

class _InheritedGlassTheme extends InheritedWidget {
  final GlassThemeData data;

  const _InheritedGlassTheme({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedGlassTheme oldWidget) =>
      data != oldWidget.data;
}

/// Theme data for Glass design system
class GlassThemeData {
  final bool isDark;
  final GlassColorsData colors;
  final NeumorphicTypography typography;
  final double blurAmount;
  final double borderRadius;

  const GlassThemeData._({
    required this.isDark,
    required this.colors,
    required this.typography,
    this.blurAmount = 20.0,
    this.borderRadius = 20.0,
  });

  /// Shadows for glass elements (neumorphic compatibility)
  GlassShadows get shadows => isDark ? GlassShadows.dark() : GlassShadows.light();

  factory GlassThemeData.light() => GlassThemeData._(
        isDark: false,
        colors: GlassColorsData.light(),
        typography: NeumorphicTypography.light,
      );

  factory GlassThemeData.dark() => GlassThemeData._(
        isDark: true,
        colors: GlassColorsData.dark(),
        typography: NeumorphicTypography.dark,
      );

  GlassThemeData copyWith({
    bool? isDark,
    GlassColorsData? colors,
    NeumorphicTypography? typography,
    double? blurAmount,
    double? borderRadius,
  }) =>
      GlassThemeData._(
        isDark: isDark ?? this.isDark,
        colors: colors ?? this.colors,
        typography: typography ?? this.typography,
        blurAmount: blurAmount ?? this.blurAmount,
        borderRadius: borderRadius ?? this.borderRadius,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlassThemeData && isDark == other.isDark;

  @override
  int get hashCode => isDark.hashCode;
}

/// Resolved color values for current theme
class GlassColorsData {
  final Color surface;
  final Color cardSurface;
  final Color glassSurface;
  final Color glassBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final LinearGradient backgroundGradient;

  const GlassColorsData._({
    required this.surface,
    required this.cardSurface,
    required this.glassSurface,
    required this.glassBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.backgroundGradient,
  });

  factory GlassColorsData.light() => const GlassColorsData._(
        surface: GlassColors.lightSurface,
        cardSurface: GlassColors.lightCardSurface,
        glassSurface: GlassColors.lightGlass,
        glassBorder: GlassColors.lightGlassBorder,
        textPrimary: GlassColors.lightTextPrimary,
        textSecondary: GlassColors.lightTextSecondary,
        textTertiary: GlassColors.lightTextTertiary,
        backgroundGradient: GlassColors.lightBackgroundGradient,
      );

  factory GlassColorsData.dark() => const GlassColorsData._(
        surface: GlassColors.darkSurface,
        cardSurface: GlassColors.darkCardSurface,
        glassSurface: GlassColors.darkGlass,
        glassBorder: GlassColors.darkGlassBorder,
        textPrimary: GlassColors.darkTextPrimary,
        textSecondary: GlassColors.darkTextSecondary,
        textTertiary: GlassColors.darkTextTertiary,
        backgroundGradient: GlassColors.darkBackgroundGradient,
      );
}

// Backwards compatibility aliases
typedef NeumorphicTheme = GlassTheme;
typedef NeumorphicThemeData = GlassThemeData;
typedef NeumorphicColorsData = GlassColorsData;

/// Glass shadow definitions (neumorphic compatibility)
class GlassShadows {
  final List<BoxShadow> convexSmall;
  final List<BoxShadow> convexMedium;
  final List<BoxShadow> convexLarge;
  final List<BoxShadow> concaveSmall;

  const GlassShadows._({
    required this.convexSmall,
    required this.convexMedium,
    required this.convexLarge,
    required this.concaveSmall,
  });

  factory GlassShadows.light() => GlassShadows._(
        convexSmall: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        convexMedium: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        convexLarge: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        concaveSmall: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );

  factory GlassShadows.dark() => GlassShadows._(
        convexSmall: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        convexMedium: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        convexLarge: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        concaveSmall: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );
}
