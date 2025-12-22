import 'package:smart_ui_kit/smart_ui_kit.dart';

/// App theme definitions based on glass design system
abstract class AppTheme {
  /// Light theme
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: GlassColors.lightSurface,
    colorScheme: ColorScheme.light(
      primary: GlassColors.accentPrimary,
      secondary: GlassColors.accentInfo,
      surface: GlassColors.lightCardSurface,
      error: GlassColors.accentError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: GlassColors.lightTextPrimary,
      onError: Colors.white,
    ),
    textTheme: _buildTextTheme(GlassColors.lightTextPrimary),
    appBarTheme: AppBarTheme(
      backgroundColor: GlassColors.lightSurface,
      foregroundColor: GlassColors.lightTextPrimary,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: GlassColors.lightCardSurface,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GlassColors.lightCardSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: GlassColors.accentPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GlassColors.accentPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  /// Dark theme
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: GlassColors.darkSurface,
    colorScheme: ColorScheme.dark(
      primary: GlassColors.accentPrimary,
      secondary: GlassColors.accentInfo,
      surface: GlassColors.darkCardSurface,
      error: GlassColors.accentError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: GlassColors.darkTextPrimary,
      onError: Colors.white,
    ),
    textTheme: _buildTextTheme(GlassColors.darkTextPrimary),
    appBarTheme: AppBarTheme(
      backgroundColor: GlassColors.darkSurface,
      foregroundColor: GlassColors.darkTextPrimary,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: GlassColors.darkCardSurface,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GlassColors.darkCardSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: GlassColors.accentPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GlassColors.accentPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static TextTheme _buildTextTheme(Color textColor) => TextTheme(
    displayLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(color: textColor, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(color: textColor, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(color: textColor, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(color: textColor),
    bodyMedium: TextStyle(color: textColor),
    bodySmall: TextStyle(color: textColor.withValues(alpha: 0.7)),
    labelLarge: TextStyle(color: textColor, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(color: textColor),
    labelSmall: TextStyle(color: textColor.withValues(alpha: 0.7)),
  );
}
