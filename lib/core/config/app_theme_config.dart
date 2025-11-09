/// Централизованная конфигурация темы приложения
///
/// ЗДЕСЬ можно изменить ВСЕ стили, цвета и анимации
/// БЕЗ изменения кода компонентов!
///
/// Просто измените значения ниже и вся app обновится.
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Главная конфигурация темы приложения
class AppThemeConfig {
  AppThemeConfig._(); // Private constructor

  // ═══════════════════════════════════════════════════════════════════════════
  // ОСНОВНАЯ ТЕМА
  // ═══════════════════════════════════════════════════════════════════════════

  /// Использовать светлую или темную тему
  ///
  /// Измените на `true` для светлой темы, `false` для темной
  static const bool useLightTheme = false;

  /// Получить текущую тему приложения
  static ThemeData get theme => useLightTheme
      ? HvacTheme.lightTheme()
      : HvacTheme.darkTheme();

  // ═══════════════════════════════════════════════════════════════════════════
  // ЦВЕТОВАЯ ПАЛИТРА (можно переопределить)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Основной цвет приложения
  ///
  /// По умолчанию: HvacColors.primary (синий #2563EB)
  /// Измените для другой цветовой схемы
  static const Color primaryColor = HvacColors.primary;

  /// Цвет акцента (для кнопок, активных элементов)
  static const Color accentColor = HvacColors.accent;

  /// Цвет успеха
  static const Color successColor = HvacColors.success;

  /// Цвет ошибки
  static const Color errorColor = HvacColors.error;

  /// Цвет предупреждения
  static const Color warningColor = HvacColors.warning;

  /// Цвет информации
  static const Color infoColor = HvacColors.info;

  /// Цвет фона
  static const Color backgroundColor = HvacColors.backgroundDark;

  /// Цвет карточек
  static const Color cardColor = HvacColors.backgroundCard;

  // ═══════════════════════════════════════════════════════════════════════════
  // АНИМАЦИИ (длительность и кривые)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Длительность быстрых анимаций (кнопки, переключатели)
  ///
  /// Рекомендуется: 200-250ms для отзывчивости
  static const Duration fastAnimation = AnimationDurations.fast; // 200ms

  /// Длительность обычных анимаций (модальные окна, переходы)
  ///
  /// Рекомендуется: 300-400ms для плавности
  static const Duration normalAnimation = AnimationDurations.normal; // 300ms

  /// Длительность медленных анимаций (сложные переходы)
  ///
  /// Рекомендуется: 400-600ms для emphasis
  static const Duration slowAnimation = AnimationDurations.medium; // 400ms

  /// Основная кривая анимации (плавное появление)
  ///
  /// Изменение кривой меняет "ощущение" всех анимаций:
  /// - SmoothCurves.silky - очень плавно (премиум feel)
  /// - SmoothCurves.emphasized - Material Design 3 (современно)
  /// - SmoothCurves.easeInOut - стандартно (классика)
  static const Curve defaultCurve = SmoothCurves.silky;

  /// Кривая для входа (появление элементов)
  static const Curve entryCurve = SmoothCurves.smoothEntry;

  /// Кривая для выхода (исчезновение элементов)
  static const Curve exitCurve = SmoothCurves.smoothExit;

  // ═══════════════════════════════════════════════════════════════════════════
  // SPRING АНИМАЦИИ (физика движения)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Spring для интерактивных элементов (draggable, swipeable)
  ///
  /// Изменение spring меняет физику движения:
  /// - smooth: iOS-like плавность (БЕЗ отскока)
  /// - bouncy: игривый отскок (с bounce)
  /// - snappy: быстрый отклик (резкий)
  /// - gentle: мягкая физика (subtle)
  static const SpringDescription interactiveSpring = SpringConstants.smooth;

  /// Spring для кнопок и микро-взаимодействий
  static const SpringDescription buttonSpring = SpringConstants.snappy;

  /// Spring для модальных окон
  static const SpringDescription modalSpring = SpringConstants.gentle;

  // ═══════════════════════════════════════════════════════════════════════════
  // РАДИУСЫ СКРУГЛЕНИЯ
  // ═══════════════════════════════════════════════════════════════════════════

  /// Радиус для маленьких элементов (chips, badges)
  ///
  /// Увеличьте для более округлого дизайна
  static const double smallRadius = HvacRadius.sm; // 8.0

  /// Радиус для средних элементов (кнопки, поля ввода)
  static const double mediumRadius = HvacRadius.md; // 12.0

  /// Радиус для больших элементов (карточки)
  static const double largeRadius = HvacRadius.lg; // 16.0

  /// Радиус для очень больших элементов (модальные окна)
  static const double extraLargeRadius = HvacRadius.xl; // 24.0

  // ═══════════════════════════════════════════════════════════════════════════
  // ОТСТУПЫ И SPACING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Очень маленький отступ (между элементами в группе)
  static const double xsSpacing = HvacSpacing.xs; // 4.0

  /// Маленький отступ (внутри карточек)
  static const double smSpacing = HvacSpacing.sm; // 8.0

  /// Средний отступ (между секциями)
  static const double mdSpacing = HvacSpacing.md; // 16.0

  /// Большой отступ (padding карточек)
  static const double lgSpacing = HvacSpacing.lg; // 24.0

  /// Очень большой отступ (между экранами)
  static const double xlSpacing = HvacSpacing.xl; // 32.0

  // ═══════════════════════════════════════════════════════════════════════════
  // ТЕНИ И ЭФФЕКТЫ
  // ═══════════════════════════════════════════════════════════════════════════

  /// Тень для карточек
  ///
  /// null = без тени (flat design)
  /// HvacShadows.card = легкая тень
  /// HvacShadows.elevated = поднятая тень
  static const List<BoxShadow>? cardShadow = null; // Flat design

  /// Blur для glassmorphism эффекта
  ///
  /// Увеличьте для более сильного blur эффекта
  static const double glassBlur = HvacColors.blurMedium; // 12.0

  // ═══════════════════════════════════════════════════════════════════════════
  // ТИПОГРАФИКА
  // ═══════════════════════════════════════════════════════════════════════════

  /// Размер шрифта для заголовков
  ///
  /// Увеличьте для более крупных заголовков
  static const double headlineFontSize = 24.0;

  /// Размер шрифта для подзаголовков
  static const double titleFontSize = 20.0;

  /// Размер шрифта для основного текста
  static const double bodyFontSize = 16.0;

  /// Размер шрифта для вспомогательного текста
  static const double captionFontSize = 14.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // СПЕЦИФИЧНЫЕ НАСТРОЙКИ КОМПОНЕНТОВ
  // ═══════════════════════════════════════════════════════════════════════════

  /// Высота кнопок
  static const double buttonHeight = 48.0;

  /// Высота полей ввода
  static const double inputHeight = 56.0;

  /// Высота карточек (если фиксированная)
  static const double? cardHeight = null; // null = динамическая высота

  /// Использовать анимацию при появлении карточек
  static const bool animateCardEntrance = true;

  /// Задержка между анимациями карточек (stagger)
  static const Duration cardStaggerDelay = AnimationDurations.staggerShort; // 50ms

  // ═══════════════════════════════════════════════════════════════════════════
  // ДОСТУПНОСТЬ
  // ═══════════════════════════════════════════════════════════════════════════

  /// Минимальный размер touch target (для пальцев)
  ///
  /// Рекомендуется: 48.0 для мобильных устройств
  static const double minimumTouchTarget = 48.0;

  /// Использовать bold текст для лучшей читаемости
  static const bool useBoldText = false;

  /// Коэффициент масштабирования текста
  ///
  /// 1.0 = нормально
  /// > 1.0 = крупнее (для accessibility)
  static const double textScaleFactor = 1.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTION vs DEBUG
  // ═══════════════════════════════════════════════════════════════════════════

  /// Показывать debug баннер
  static const bool showDebugBanner = false;

  /// Использовать production анимации (отключить в debug для быстроты)
  static const bool useProductionAnimations = true;

  /// Логировать изменения темы
  static const bool logThemeChanges = false;
}

/// Preset конфигурации для разных стилей
class AppThemePresets {
  /// iOS-стиль (плавный, минималистичный)
  static void applyIOSStyle() {
    // Изменить значения в AppThemeConfig
    // useLightTheme = true
    // interactiveSpring = SpringConstants.smooth
    // defaultCurve = SmoothCurves.silky
  }

  /// Material Design 3 стиль (современный, emphasized)
  static void applyMaterial3Style() {
    // useLightTheme = true
    // defaultCurve = SmoothCurves.emphasized
    // cardShadow = HvacShadows.card
  }

  /// Flat Design стиль (минимализм, без теней)
  static void applyFlatStyle() {
    // cardShadow = null
    // useLightTheme = true
  }

  /// Glassmorphism стиль (прозрачность, blur)
  static void applyGlassStyle() {
    // useLightTheme = false
    // glassBlur = 20.0
  }
}
