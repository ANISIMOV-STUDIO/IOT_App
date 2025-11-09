# 🎨 UI Kit Theming Guide

**Полное руководство по настройке стилей и анимаций БЕЗ изменения кода**

---

## 📋 Оглавление

1. [Быстрый старт](#быстрый-старт)
2. [Изменение темы (светлая/темная)](#изменение-темы)
3. [Настройка цветов](#настройка-цветов)
4. [Настройка анимаций](#настройка-анимаций)
5. [Настройка радиусов и отступов](#настройка-радиусов-и-отступов)
6. [Готовые пресеты стилей](#готовые-пресеты)
7. [Примеры кастомизации](#примеры-кастомизации)

---

## 🚀 Быстрый старт

### Где находится конфигурация?

**Все настройки в одном файле:**
```
lib/core/config/app_theme_config.dart
```

### Как применить тему?

В `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'core/config/app_theme_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HVAC App',

      // 👇 Просто используйте это!
      theme: AppThemeConfig.theme,

      home: const HomeScreen(),
    );
  }
}
```

---

## 🌗 Изменение темы

### Переключение светлая/темная

В `app_theme_config.dart` измените:

```dart
/// Использовать светлую или темную тему
static const bool useLightTheme = false;  // ← Измените на true
```

**Результат:** Вся app автоматически переключится на светлую тему!

---

## 🎨 Настройка цветов

### Изменить основной цвет приложения

```dart
/// Основной цвет приложения
static const Color primaryColor = Color(0xFFFF6B35);  // Оранжевый
// ИЛИ
static const Color primaryColor = HvacColors.primary;  // Синий (по умолчанию)
```

### Доступные цвета из UI Kit:

```dart
// Основные
HvacColors.primary           // #2563EB - Синий
HvacColors.primaryLight      // #60A5FA - Светло-синий
HvacColors.primaryDark       // #1E40AF - Темно-синий

// Семантические
HvacColors.success           // #10B981 - Зеленый
HvacColors.error             // #DC2626 - Красный
HvacColors.warning           // #F59E0B - Оранжевый
HvacColors.info              // #2C7BE5 - Синий

// Фоны
HvacColors.backgroundDark    // #1E293B - Темный фон
HvacColors.backgroundCard    // #FFFFFF - Белый (карточки)
HvacColors.backgroundSecondary // #F8FAFC - Светло-серый

// Текст
HvacColors.textPrimary       // #0F172A - Основной текст
HvacColors.textSecondary     // #64748B - Вспомогательный
HvacColors.textTertiary      // #94A3B8 - Третичный
```

### Пример: Зеленая цветовая схема

```dart
static const Color primaryColor = HvacColors.success;  // #10B981
static const Color accentColor = Color(0xFF34D399);    // Светло-зеленый
```

---

## ⚡ Настройка анимаций

### Изменить скорость анимаций

```dart
/// Быстрые анимации (кнопки)
static const Duration fastAnimation = Duration(milliseconds: 150);  // Быстрее
// ИЛИ
static const Duration fastAnimation = Duration(milliseconds: 300);  // Медленнее
```

### Изменить "ощущение" анимаций

```dart
/// Основная кривая анимации
static const Curve defaultCurve = SmoothCurves.silky;  // Премиум, плавно
// ИЛИ
static const Curve defaultCurve = SmoothCurves.emphasized;  // Material Design 3
// ИЛИ
static const Curve defaultCurve = Curves.easeInOut;  // Классика
```

### Доступные кривые анимации:

```dart
// Плавные (рекомендуется)
SmoothCurves.silky               // Очень плавно (премиум)
SmoothCurves.emphasized          // Material Design 3
SmoothCurves.smoothEntry         // Для появления
SmoothCurves.smoothExit          // Для исчезновения

// Стандартные
Curves.easeIn                    // Ускорение
Curves.easeOut                   // Замедление
Curves.easeInOut                 // Плавно
Curves.linear                    // Линейно
```

### Spring анимации (физика движения)

```dart
/// Spring для интерактивных элементов
static const SpringDescription interactiveSpring = SpringConstants.smooth;  // iOS-like
// ИЛИ
static const SpringDescription interactiveSpring = SpringConstants.bouncy;  // С отскоком
// ИЛИ
static const SpringDescription interactiveSpring = SpringConstants.snappy;  // Быстро
```

**Доступные spring константы:**

| Константа | Описание | Использование |
|-----------|----------|---------------|
| `SpringConstants.smooth` | iOS-like плавность (БЕЗ отскока) | Draggable, swipeable элементы |
| `SpringConstants.bouncy` | Игривый отскок | Модальные окна, карточки |
| `SpringConstants.snappy` | Быстрый, резкий | Кнопки, переключатели |
| `SpringConstants.gentle` | Мягкая физика | Subtle анимации |
| `SpringConstants.interactive` | Универсальный | Любые интерактивные элементы |

---

## 📐 Настройка радиусов и отступов

### Радиусы скругления

```dart
/// Сделать все элементы более округлыми
static const double smallRadius = 12.0;    // Было: 8.0
static const double mediumRadius = 16.0;   // Было: 12.0
static const double largeRadius = 24.0;    // Было: 16.0
```

**Пример: Квадратный дизайн**

```dart
static const double smallRadius = 0.0;
static const double mediumRadius = 0.0;
static const double largeRadius = 0.0;
```

### Отступы

```dart
/// Увеличить padding везде
static const double lgSpacing = 32.0;  // Было: 24.0
static const double xlSpacing = 48.0;  // Было: 32.0
```

---

## 🎯 Готовые пресеты

### iOS Style

```dart
// В app_theme_config.dart
static const bool useLightTheme = true;
static const Curve defaultCurve = SmoothCurves.silky;
static const SpringDescription interactiveSpring = SpringConstants.smooth;
static final List<BoxShadow>? cardShadow = null;  // Без теней
```

**Результат:** Приложение выглядит как нативный iOS app

### Material Design 3

```dart
static const bool useLightTheme = true;
static const Curve defaultCurve = SmoothCurves.emphasized;
static const SpringDescription interactiveSpring = SpringConstants.snappy;
static final List<BoxShadow>? cardShadow = HvacShadows.card;
```

**Результат:** Современный Google Material Design 3

### Flat Design

```dart
static const bool useLightTheme = true;
static final List<BoxShadow>? cardShadow = null;
static const double smallRadius = 4.0;
static const double mediumRadius = 4.0;
```

**Результат:** Минималистичный flat дизайн

### Glassmorphism

```dart
static const bool useLightTheme = false;
static const double glassBlur = 20.0;  // Сильный blur
static final List<BoxShadow>? cardShadow = HvacShadows.glass;
```

**Результат:** Прозрачные элементы с blur эффектом

---

## 💡 Примеры кастомизации

### Пример 1: Быстрые анимации (snappy app)

```dart
static const Duration fastAnimation = Duration(milliseconds: 100);
static const Duration normalAnimation = Duration(milliseconds: 150);
static const Curve defaultCurve = Curves.easeOut;
static const SpringDescription interactiveSpring = SpringConstants.snappy;
```

**Эффект:** Все работает очень быстро и отзывчиво

### Пример 2: Плавные анимации (luxury app)

```dart
static const Duration fastAnimation = Duration(milliseconds: 300);
static const Duration normalAnimation = Duration(milliseconds: 500);
static const Curve defaultCurve = SmoothCurves.silky;
static const SpringDescription interactiveSpring = SpringConstants.smooth;
```

**Эффект:** Премиум ощущение, все плавно

### Пример 3: Игривый дизайн (playful app)

```dart
static const Curve defaultCurve = Curves.elasticOut;
static const SpringDescription interactiveSpring = SpringConstants.bouncy;
static const Duration normalAnimation = Duration(milliseconds: 600);
```

**Эффект:** Веселые bounce анимации

### Пример 4: Корпоративный стиль (serious app)

```dart
static const bool useLightTheme = true;
static const Color primaryColor = Color(0xFF2C3E50);  // Темно-синий
static final List<BoxShadow>? cardShadow = null;
static const Curve defaultCurve = Curves.easeInOut;
static const double smallRadius = 2.0;
```

**Эффект:** Серьезный, профессиональный вид

---

## 🔧 Расширенная кастомизация

### Создание своей цветовой схемы

```dart
// 1. Определите основные цвета
static const Color brandPrimary = Color(0xFF6366F1);   // Индиго
static const Color brandSecondary = Color(0xFFA855F7); // Пурпурный
static const Color brandAccent = Color(0xFFEC4899);    // Розовый

// 2. Примените их
static const Color primaryColor = brandPrimary;
static const Color accentColor = brandAccent;
static const Color successColor = Color(0xFF10B981);
```

### Создание своих анимаций

```dart
// Кастомная кривая
static const Curve customCurve = Cubic(0.17, 0.67, 0.83, 0.67);

// Кастомная spring
static const SpringDescription customSpring = SpringDescription(
  mass: 1.0,
  stiffness: 150.0,
  damping: 15.0,
);
```

---

## 📱 Responsive дизайн

### Адаптивные размеры

```dart
/// Использовать responsive sizing
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

// В виджете
double cardPadding = responsive.spacing.lg;  // Автоматически адаптируется
```

---

## ✅ Checklist перед production

- [ ] Выбрана подходящая тема (светлая/темная)
- [ ] Цвета соответствуют бренду
- [ ] Анимации не слишком медленные (< 500ms)
- [ ] Анимации не слишком быстрые (> 100ms)
- [ ] Радиусы скругления консистентны
- [ ] Отступы соответствуют дизайну
- [ ] Протестировано на разных устройствах
- [ ] Accessibility проверен

---

## 🎓 Советы и best practices

### 1. Длительность анимаций

```
100-200ms   - Микро-взаимодействия (кнопки, hover)
200-300ms   - Быстрые переходы (модальные, tabs)
300-500ms   - Обычные переходы (страницы, карточки)
500-800ms   - Медленные переходы (сложные анимации)
```

### 2. Выбор кривых

```
easeOut       - Для появления элементов (быстрый старт)
easeIn        - Для исчезновения элементов (быстрый конец)
easeInOut     - Для движения (плавно с обеих сторон)
linear        - Для прогресс-баров
```

### 3. Spring физика

```
smooth    - Для premium apps (iOS-like)
bouncy    - Для playful apps (игры, детские)
snappy    - Для productivity apps (быстрая работа)
gentle    - Для luxury apps (премиум ощущение)
```

### 4. Цветовая палитра

- **Не более 3-4 основных цветов**
- Используйте оттенки одного цвета
- Обеспечьте достаточный контраст (WCAG AA)
- Проверьте на цветовую слепоту

---

## 🚀 Что дальше?

1. **Экспериментируйте** - меняйте значения и смотрите результат
2. **Тестируйте** - проверяйте на разных устройствах
3. **Итерируйте** - находите оптимальные значения
4. **Документируйте** - записывайте ваши изменения

---

## 📚 Дополнительные ресурсы

- [Material Design 3 Guidelines](https://m3.material.io/)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Animation Best Practices](https://material.io/design/motion/understanding-motion.html)

---

**Важно:** Все изменения в `app_theme_config.dart` применяются **автоматически** при перезапуске приложения. Не нужно менять код компонентов!

🎉 **Наслаждайтесь кастомизацией!**
