import 'package:flutter/material.dart';
import 'app_radius.dart';

/// Theme-aware colors accessible via BreezColors.of(context)
class BreezColors extends ThemeExtension<BreezColors> {
  final Color bg;
  final Color card;
  final Color cardLight;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color buttonBg;

  const BreezColors({
    required this.bg,
    required this.card,
    required this.cardLight,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.buttonBg,
  });

  /// Get colors from context
  static BreezColors of(BuildContext context) {
    return Theme.of(context).extension<BreezColors>()!;
  }

  /// Dark theme colors
  static const dark = BreezColors(
    bg: AppColors.darkBg,
    card: AppColors.darkCard,
    cardLight: AppColors.darkCardLight,
    border: AppColors.darkBorder,
    text: AppColors.darkText,
    textMuted: AppColors.darkTextMuted,
    buttonBg: Color(0x0DFFFFFF), // white 5%
  );

  /// Light theme colors
  static const light = BreezColors(
    bg: AppColors.lightBg,
    card: AppColors.lightCard,
    cardLight: AppColors.lightCardLight,
    border: AppColors.lightBorder,
    text: AppColors.lightText,
    textMuted: AppColors.lightTextMuted,
    buttonBg: Color(0xFFE8EEF4), // Голубовато-серый для кнопок
  );

  @override
  BreezColors copyWith({
    Color? bg,
    Color? card,
    Color? cardLight,
    Color? border,
    Color? text,
    Color? textMuted,
    Color? buttonBg,
  }) {
    return BreezColors(
      bg: bg ?? this.bg,
      card: card ?? this.card,
      cardLight: cardLight ?? this.cardLight,
      border: border ?? this.border,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      buttonBg: buttonBg ?? this.buttonBg,
    );
  }

  @override
  BreezColors lerp(ThemeExtension<BreezColors>? other, double t) {
    if (other is! BreezColors) return this;
    return BreezColors(
      bg: Color.lerp(bg, other.bg, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardLight: Color.lerp(cardLight, other.cardLight, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      buttonBg: Color.lerp(buttonBg, other.buttonBg, t)!,
    );
  }
}

/// BREEZ Design System Colors
/// Dark industrial theme for HVAC control
abstract class AppColors {
  // === DARK THEME (Primary) ===
  static const Color darkBg = Color(0xFF000D1A);
  static const Color darkCard = Color(0xFF0F1D2E);
  static const Color darkCardLight = Color(0xFF162942);
  static const Color darkBorder = Color(0x0DFFFFFF); // white/5%
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextMuted = Color(0x66FFFFFF); // white/40%

  // === LIGHT THEME ===
  // Modern clean theme с голубым оттенком (в стиле темной темы)
  static const Color lightBg = Color(0xFFF0F4F8); // Голубовато-серый фон
  static const Color lightCard = Color(0xFFFFFFFF); // Чистый белый
  static const Color lightCardLight = Color(0xFFF8FAFC); // Очень светлый
  static const Color lightBorder = Color(0xFFCFD8E3); // Мягкая голубая граница
  static const Color lightText = Color(0xFF1E293B); // Темно-серый (slate-800)
  static const Color lightTextMuted = Color(0xFF64748B); // Средний серый (slate-500)

  // === ACCENT COLORS ===
  static const Color accent = Color(0xFF2D7DFF); // Primary blue
  static const Color accentLight = Color(0xFF5B9AFF);
  static const Color accentRed = Color(0xFFD64545); // Power off / Critical
  static const Color accentOrange = Color(0xFFF97316); // Exhaust / Warning
  static const Color accentGreen = Color(0xFF22C55E); // Online / Success

  // === STATUS COLORS ===
  static const Color critical = Color(0xFFD64545);
  static const Color warning = Color(0xFFF97316);
  static const Color info = Color(0xFF2D7DFF);
  static const Color success = Color(0xFF22C55E);

  // === GRADIENTS ===
  static const LinearGradient glowGradient = LinearGradient(
    colors: [Color(0x3360A5FA), Color(0x002D7DFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

}

/// Theme configuration
class AppTheme {
  final bool isDark;

  AppTheme({required this.isDark});

  // Getters for current theme colors
  Color get bg => isDark ? AppColors.darkBg : AppColors.lightBg;
  Color get card => isDark ? AppColors.darkCard : AppColors.lightCard;
  Color get cardLight => isDark ? AppColors.darkCardLight : AppColors.lightCard;
  Color get border => isDark ? AppColors.darkBorder : AppColors.lightBorder;
  Color get text => isDark ? AppColors.darkText : AppColors.lightText;
  Color get textMuted => isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

  // Button background
  Color get buttonBg => isDark
      ? Colors.white.withValues(alpha: 0.05)
      : const Color(0xFFE8EEF4); // Голубовато-серый для светлой темы

  /// Material theme
  ThemeData get materialTheme => ThemeData(
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: bg,
    extensions: [isDark ? BreezColors.dark : BreezColors.light],
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: isDark ? Brightness.dark : Brightness.light,
      surface: card,
      onSurface: text,
    ),
    fontFamily: 'Inter',
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: border),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: text,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.accent,
      inactiveTrackColor: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.black.withValues(alpha: 0.1),
      thumbColor: Colors.white,
      overlayColor: AppColors.accent.withValues(alpha: 0.2),
      trackHeight: 8,
    ),
  );

  // === STATIC INSTANCES ===
  static final _light = AppTheme(isDark: false);
  static final _dark = AppTheme(isDark: true);

  /// Static Material themes for main.dart
  static ThemeData get materialLight => _light.materialTheme;
  static ThemeData get materialDark => _dark.materialTheme;
}
