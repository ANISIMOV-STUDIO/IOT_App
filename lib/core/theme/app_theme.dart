/// BREEZ Premium Theme System
///
/// Material 3 тема с премиум Teal/Cyan акцентом.
/// Поддержка hover/press состояний через WidgetStateProperty.
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/core/theme/app_colors.dart';
import 'package:hvac_control/core/theme/app_radius.dart';

// Re-export theme components for convenience
export 'app_colors.dart';
export 'app_font_sizes.dart';
export 'app_radius.dart';

/// Theme-aware colors accessible via BreezColors.of(context)
class BreezColors extends ThemeExtension<BreezColors> {

  const BreezColors({
    required this.bg,
    required this.card,
    required this.cardLight,
    required this.border,
    required this.borderAccent,
    required this.text,
    required this.textMuted,
    required this.buttonBg,
    required this.buttonHover,
    required this.hoverOverlay,
    required this.pressedOverlay,
  });
  final Color bg;
  final Color card;
  final Color cardLight;
  final Color border;
  final Color borderAccent;
  final Color text;
  final Color textMuted;
  final Color buttonBg;
  final Color buttonHover;
  final Color hoverOverlay;
  final Color pressedOverlay;

  /// Get colors from context
  static BreezColors of(BuildContext context) => Theme.of(context).extension<BreezColors>()!;

  /// Dark theme colors - Premium Dark
  static const dark = BreezColors(
    bg: AppColors.darkBg,
    card: AppColors.darkCard,
    cardLight: AppColors.darkCardLight,
    border: AppColors.darkBorder,
    borderAccent: AppColors.darkBorderAccent,
    text: AppColors.darkText,
    textMuted: AppColors.darkTextMuted,
    buttonBg: AppColors.darkButtonBg,
    buttonHover: AppColors.darkButtonHover,
    hoverOverlay: AppColors.darkHoverOverlay,
    pressedOverlay: AppColors.darkPressedOverlay,
  );

  /// Light theme colors - Clean Premium
  static const light = BreezColors(
    bg: AppColors.lightBg,
    card: AppColors.lightCard,
    cardLight: AppColors.lightCardLight,
    border: AppColors.lightBorder,
    borderAccent: AppColors.lightBorderAccent,
    text: AppColors.lightText,
    textMuted: AppColors.lightTextMuted,
    buttonBg: AppColors.lightButtonBg,
    buttonHover: AppColors.lightButtonHover,
    hoverOverlay: AppColors.lightHoverOverlay,
    pressedOverlay: AppColors.lightPressedOverlay,
  );

  @override
  BreezColors copyWith({
    Color? bg,
    Color? card,
    Color? cardLight,
    Color? border,
    Color? borderAccent,
    Color? text,
    Color? textMuted,
    Color? buttonBg,
    Color? buttonHover,
    Color? hoverOverlay,
    Color? pressedOverlay,
  }) => BreezColors(
      bg: bg ?? this.bg,
      card: card ?? this.card,
      cardLight: cardLight ?? this.cardLight,
      border: border ?? this.border,
      borderAccent: borderAccent ?? this.borderAccent,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      buttonBg: buttonBg ?? this.buttonBg,
      buttonHover: buttonHover ?? this.buttonHover,
      hoverOverlay: hoverOverlay ?? this.hoverOverlay,
      pressedOverlay: pressedOverlay ?? this.pressedOverlay,
    );

  @override
  BreezColors lerp(ThemeExtension<BreezColors>? other, double t) {
    if (other is! BreezColors) {
      return this;
    }
    return BreezColors(
      bg: Color.lerp(bg, other.bg, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardLight: Color.lerp(cardLight, other.cardLight, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderAccent: Color.lerp(borderAccent, other.borderAccent, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      buttonBg: Color.lerp(buttonBg, other.buttonBg, t)!,
      buttonHover: Color.lerp(buttonHover, other.buttonHover, t)!,
      hoverOverlay: Color.lerp(hoverOverlay, other.hoverOverlay, t)!,
      pressedOverlay: Color.lerp(pressedOverlay, other.pressedOverlay, t)!,
    );
  }
}

/// Theme configuration with Material 3 support
class AppTheme {

  AppTheme({required this.isDark});
  final bool isDark;

  // Getters for current theme colors
  BreezColors get colors => isDark ? BreezColors.dark : BreezColors.light;

  Color get bg => colors.bg;
  Color get card => colors.card;
  Color get cardLight => colors.cardLight;
  Color get border => colors.border;
  Color get text => colors.text;
  Color get textMuted => colors.textMuted;
  Color get buttonBg => colors.buttonBg;

  /// Material theme with premium styling
  ThemeData get materialTheme => ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: bg,
        extensions: [colors],

        // Color Scheme
        colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: AppColors.accent,
          onPrimary: isDark ? AppColors.darkBg : AppColors.white,
          secondary: AppColors.accentLight,
          onSecondary: isDark ? AppColors.darkBg : AppColors.white,
          tertiary: AppColors.warning,
          onTertiary: AppColors.darkBg,
          error: AppColors.critical,
          onError: AppColors.white,
          surface: card,
          onSurface: text,
          surfaceContainerHighest: cardLight,
          outline: border,
          outlineVariant: colors.borderAccent,
        ),

        // Typography
        fontFamily: 'Inter',
        textTheme: _buildTextTheme(isDark),

        // Card Theme
        cardTheme: CardThemeData(
          color: card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: BorderSide(color: border),
          ),
        ),

        // Elevated Button - Primary action
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.accent.withValues(alpha: 0.5);
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColors.accentDark;
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.accentLight;
              }
              return AppColors.accent;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.white.withValues(alpha: 0.7);
              }
              return AppColors.white;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.white.withValues(alpha: 0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.white.withValues(alpha: 0.05);
              }
              return Colors.transparent;
            }),
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return 4;
              }
              if (states.contains(WidgetState.pressed)) {
                return 2;
              }
              return 0;
            }),
            shadowColor: WidgetStateProperty.all(AppColors.accentGlow),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
            animationDuration: AppDurations.fast,
          ),
        ),

        // Outlined Button - Secondary action
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return colors.pressedOverlay;
              }
              if (states.contains(WidgetState.hovered)) {
                return colors.hoverOverlay;
              }
              return Colors.transparent;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return textMuted.withValues(alpha: 0.5);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.accent;
              }
              return text;
            }),
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return const BorderSide(color: AppColors.accent, width: 1.5);
              }
              return BorderSide(color: border);
            }),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
            animationDuration: AppDurations.fast,
          ),
        ),

        // Text Button - Tertiary action
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.accent.withValues(alpha: 0.15);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.accent.withValues(alpha: 0.08);
              }
              return Colors.transparent;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return textMuted.withValues(alpha: 0.5);
              }
              return AppColors.accent;
            }),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
            animationDuration: AppDurations.fast,
          ),
        ),

        // Icon Button
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return colors.pressedOverlay;
              }
              if (states.contains(WidgetState.hovered)) {
                return colors.hoverOverlay;
              }
              return Colors.transparent;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppColors.accent;
              }
              return textMuted;
            }),
            animationDuration: AppDurations.fast,
          ),
        ),

        // Slider
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.accent,
          inactiveTrackColor: isDark
              ? AppColors.white.withValues(alpha: 0.1)
              : AppColors.black.withValues(alpha: 0.1),
          thumbColor: AppColors.white,
          overlayColor: AppColors.accent.withValues(alpha: 0.2),
          trackHeight: 8,
          thumbShape: const RoundSliderThumbShape(
            elevation: 4,
          ),
        ),

        // Switch
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.white;
            }
            return textMuted;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.accent;
            }
            return border;
          }),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),

        // Checkbox
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.accent;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AppColors.white),
          side: BorderSide(color: border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.dialog),
          ),
          elevation: 24,
        ),

        // Bottom Sheet
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.bottomSheet),
          ),
        ),

        // Divider
        dividerTheme: DividerThemeData(
          color: border,
          thickness: 1,
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: bg,
          foregroundColor: text,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: text,
          ),
        ),

        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: buttonBg,
          hoverColor: colors.buttonHover,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: const BorderSide(color: AppColors.accent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
            borderSide: const BorderSide(color: AppColors.critical),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: isDark ? AppColors.darkCardLight : AppColors.lightText,
          contentTextStyle: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightCard,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

  /// Build text theme with proper colors
  TextTheme _buildTextTheme(bool isDark) {
    final color = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return TextTheme(
      displayLarge: TextStyle(color: color, fontWeight: FontWeight.w700),
      displayMedium: TextStyle(color: color, fontWeight: FontWeight.w700),
      displaySmall: TextStyle(color: color, fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(color: color, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: color, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: color, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: color, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: color, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: color, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: color),
      bodyMedium: TextStyle(color: color),
      bodySmall: TextStyle(color: mutedColor),
      labelLarge: TextStyle(color: color, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: mutedColor),
      labelSmall: TextStyle(color: mutedColor),
    );
  }

  // === STATIC INSTANCES ===
  static final _light = AppTheme(isDark: false);
  static final _dark = AppTheme(isDark: true);

  /// Static Material themes for main.dart
  static ThemeData get materialLight => _light.materialTheme;
  static ThemeData get materialDark => _dark.materialTheme;
}
