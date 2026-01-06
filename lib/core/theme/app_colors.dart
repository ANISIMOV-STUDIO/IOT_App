/// BREEZ Premium Design System - Color Tokens
///
/// Централизованная система цветов с премиум палитрой.
/// Teal/Cyan акцент для современного tech-premium стиля.
library;

import 'package:flutter/material.dart';

/// Семантические цветовые токены
abstract class AppColors {
  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND / ACCENT - Teal Premium
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary accent - насыщенный teal
  static const Color accent = Color(0xFF00D9C4);

  /// Accent светлый (hover)
  static const Color accentLight = Color(0xFF33E5D4);

  /// Accent тёмный (pressed)
  static const Color accentDark = Color(0xFF00B3A1);

  /// Accent с glow эффектом
  static const Color accentGlow = Color(0x4D00D9C4); // 30% opacity

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME - Premium Dark
  // ═══════════════════════════════════════════════════════════════════════════

  /// Основной фон - глубокий чёрный с холодным оттенком
  static const Color darkBg = Color(0xFF0A0E14);

  /// Карточки - приподнятая поверхность
  static const Color darkCard = Color(0xFF131920);

  /// Карточки светлые - hover состояние
  static const Color darkCardLight = Color(0xFF1A232D);

  /// Границы - subtle
  static const Color darkBorder = Color(0xFF1E2832);

  /// Границы акцентные
  static const Color darkBorderAccent = Color(0xFF2A3541);

  /// Основной текст
  static const Color darkText = Color(0xFFF1F5F9);

  /// Вторичный текст
  static const Color darkTextMuted = Color(0xFF8B9AAD);

  /// Фон кнопок
  static const Color darkButtonBg = Color(0xFF1A232D);

  /// Hover кнопок
  static const Color darkButtonHover = Color(0xFF232F3E);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME - Clean Premium
  // ═══════════════════════════════════════════════════════════════════════════

  /// Основной фон - тёплый белый
  static const Color lightBg = Color(0xFFF8FAFB);

  /// Карточки - чистый белый
  static const Color lightCard = Color(0xFFFFFFFF);

  /// Карточки - hover
  static const Color lightCardLight = Color(0xFFF1F5F8);

  /// Границы - более заметные
  static const Color lightBorder = Color(0xFFCBD5E1);

  /// Границы акцентные - для hover состояний
  static const Color lightBorderAccent = Color(0xFF94A3B8);

  /// Основной текст
  static const Color lightText = Color(0xFF0F172A);

  /// Вторичный текст
  static const Color lightTextMuted = Color(0xFF64748B);

  /// Фон кнопок
  static const Color lightButtonBg = Color(0xFFE2E8F0);

  /// Hover кнопок
  static const Color lightButtonHover = Color(0xFFCBD5E1);

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS COLORS - Насыщенные
  // ═══════════════════════════════════════════════════════════════════════════

  /// Критическая ошибка - coral/rose
  static const Color critical = Color(0xFFFF6B6B);
  static const Color criticalLight = Color(0xFFFF8A8A);
  static const Color criticalDark = Color(0xFFE64545);
  static const Color criticalBg = Color(0x1AFF6B6B); // 10%

  /// Предупреждение - amber/gold
  static const Color warning = Color(0xFFFFB020);
  static const Color warningLight = Color(0xFFFFC54D);
  static const Color warningDark = Color(0xFFE69500);
  static const Color warningBg = Color(0x1AFFB020);

  /// Информация - cyan (accent)
  static const Color info = Color(0xFF00D9C4);
  static const Color infoBg = Color(0x1A00D9C4);

  /// Успех - emerald
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);
  static const Color successBg = Color(0x1A10B981);

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERACTIVE STATES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Hover overlay - для темной темы
  static const Color darkHoverOverlay = Color(0x0DFFFFFF); // white 5%

  /// Pressed overlay - для темной темы
  static const Color darkPressedOverlay = Color(0x1AFFFFFF); // white 10%

  /// Hover overlay - для светлой темы
  static const Color lightHoverOverlay = Color(0x0D000000); // black 5%

  /// Pressed overlay - для светлой темы
  static const Color lightPressedOverlay = Color(0x1A000000); // black 10%

  /// Focus ring
  static const Color focusRing = Color(0xFF00D9C4);

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Accent glow gradient (для кнопок)
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D9C4), Color(0xFF00B3A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium glow - для карточек
  static const LinearGradient glowGradient = LinearGradient(
    colors: [Color(0x4D00D9C4), Color(0x0000D9C4)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Dark card gradient - subtle depth
  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF151C24), Color(0xFF0F1419)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SHADOWS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Subtle shadow для темной темы
  static List<BoxShadow> get darkShadowSm => [
        const BoxShadow(
          color: Color(0x40000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];

  /// Medium shadow
  static List<BoxShadow> get darkShadowMd => [
        const BoxShadow(
          color: Color(0x60000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ];

  /// Glow shadow для accent элементов
  static List<BoxShadow> get accentShadow => [
        const BoxShadow(
          color: Color(0x4D00D9C4),
          blurRadius: 20,
          offset: Offset(0, 4),
        ),
      ];

  /// Light theme shadows
  static List<BoxShadow> get lightShadowSm => [
        const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get lightShadowMd => [
        const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // SKELETON / SHIMMER
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color darkShimmerBase = Color(0xFF1A232D);
  static const Color darkShimmerHighlight = Color(0xFF232F3E);
  static const Color lightShimmerBase = Color(0xFFE2E8F0);
  static const Color lightShimmerHighlight = Color(0xFFF1F5F9);

  // ═══════════════════════════════════════════════════════════════════════════
  // CARD GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Тёмный градиент для главной карточки - более контрастный голубой
  static const List<Color> darkCardGradientColors = [
    Color(0xFF1E3A5F), // Насыщенный тёмно-синий
    Color(0xFF0D2137), // Глубокий тёмно-синий
  ];

  /// Светлый градиент для главной карточки - более выраженный голубой
  static const List<Color> lightCardGradientColors = [
    Color(0xFFE0F2FF), // Светло-голубой
    Color(0xFFC7E4F9), // Голубой с насыщенностью
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // LEGACY ALIASES (для совместимости)
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color accentRed = critical;
  static const Color accentOrange = warning;
  static const Color accentGreen = success;
}

/// Анимации и переходы
abstract class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration theme = Duration(milliseconds: 400);
}

/// Кривые анимации
abstract class AppCurves {
  static const Curve standard = Curves.easeOutCubic;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
  static const Curve bounce = Curves.elasticOut;
}
