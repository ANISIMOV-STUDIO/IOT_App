<!--
  MARKDOWN DOCUMENTATION FILE
  This file contains Dart code EXAMPLES, not actual Dart code.
  IDE should not analyze inline code snippets as compilable Dart.
-->

# IOT_App Development Guide

---

# 🚨 КРИТИЧЕСКИ ВАЖНО - ЧИТАЙ ПЕРЕД КАЖДОЙ ЗАДАЧЕЙ

## ⛔ ТЫ ПОСТОЯННО ИГНОРИРУЕШЬ ЭТИ ПРАВИЛА - ОСТАНОВИСЬ И ПРОЧИТАЙ

### ПЕРЕД тем как писать код:

1. ✅ **Проверь существующие компоненты** - используй `BreezButton`, `BreezCard`, `BreezIconButton`, `BreezSlider`, etc.
   - **НЕ создавай** `ElevatedButton`, `TextButton`, `IconButton` — они ЗАПРЕЩЕНЫ!

2. ✅ **Используй Context7** для поиска документации библиотек
   - Перед использованием библиотеки — найди её документацию
   - `mcp__context7__resolve-library-id` → `mcp__context7__query-docs`

3. ✅ **НИКОГДА не используй magic numbers**
   - ❌ `fontSize: 14` → ✅ `fontSize: AppFontSizes.body`
   - ❌ `padding: EdgeInsets.all(16)` → ✅ `padding: EdgeInsets.all(AppSpacing.md)`
   - ❌ `BorderRadius.circular(12)` → ✅ `BorderRadius.circular(AppRadius.button)`
   - ❌ `SizedBox(height: 8)` → ✅ `SizedBox(height: AppSpacing.xs)`
   - ❌ `Colors.white` → ✅ `AppColors.white`

4. ✅ **ПОСЛЕ исправлений - ВСЕГДА запускай проверку**
   ```bash
   ./scripts/check_design_system.sh
   ```
   Если exit code = 1 (ошибка) — **ты провалил задачу!**

### 🔒 ПРАВИЛА GIT (СТРОГО):

- ⛔ **НИКОГДА не используй `git push`** — пуш запрещён полностью
- ⛔ **Коммитить ТОЛЬКО когда пользователь явно скажет** "закоммить", "создай коммит", etc.
- ✅ **Сообщения коммитов ТОЛЬКО на русском языке**
- ⛔ **БЕЗ `Co-Authored-By: Claude...`** в сообщениях коммитов
- ⛔ **НИКОГДА не используй `git commit --amend`** без явного запроса

**Пример правильного коммита:**
```bash
git add .
git commit -m "Исправлены нарушения дизайн-системы в operation_graph_painter.dart"
```

### ⚠️ НИКАКИХ "БЫСТРЫХ ВАРИАНТОВ":

- ⛔ **НЕ выбирай лёгкий путь** если он нарушает стандарты
- ⛔ **НЕ используй "временные решения"** с hardcoded значениями
- ⛔ **НЕ пиши "сначала заработает, потом исправим"**
- ✅ **Делай СРАЗУ правильно и качественно**
- ✅ **Потрать время на правильное решение** вместо костылей

**Пример неправильного подхода:**
```dart
// ❌ "Быстро сделаю, потом исправлю"
Container(
  padding: EdgeInsets.all(16),  // Быстро написал число
  child: Text('Hello', style: TextStyle(fontSize: 14)),
)
```

**Пример правильного подхода:**
```dart
// ✅ Сразу правильно, даже если дольше
Container(
  padding: EdgeInsets.all(AppSpacing.md),  // Использовал константу
  child: Text('Hello', style: TextStyle(fontSize: AppFontSizes.body)),
)
```

### ❌ ЕСЛИ ТЫ НАПИСАЛ КОД С НАРУШЕНИЯМИ:

**ТЫ ПРОВАЛИЛ ЗАДАЧУ!** Пользователь не должен тебе напоминать об этих правилах.

**Качество важнее скорости!**

---

> **ОБЯЗАТЕЛЬНО:** При каждом сеансе работы с кодом сверяйся с этим файлом.

---

## ОБЯЗАТЕЛЬНЫЕ ИНСТРУМЕНТЫ

### Context7 - Документация библиотек

**ВСЕГДА** используй Context7 для получения актуальной документации:

```
1. mcp__context7__resolve-library-id - найти ID библиотеки
2. mcp__context7__query-docs - получить документацию
```

Примеры запросов:
- Flutter widgets: `/flutter/flutter`
- BLoC: `/felangel/bloc`
- GetIt: `/nickvision/get_it`

---

## АРХИТЕКТУРА ПРОЕКТА

### Clean Architecture Layers

```
lib/
├── core/                    # Базовые сервисы и тема
│   ├── theme/              # Система дизайна
│   ├── di/                 # Dependency Injection
│   └── services/           # Core services
├── domain/                  # Бизнес-логика (чистая)
│   ├── entities/           # Модели данных
│   ├── repositories/       # Интерфейсы репозиториев
│   └── usecases/           # Use cases
├── data/                    # Реализация данных
│   ├── datasources/        # API, Local storage
│   ├── models/             # DTO модели
│   └── repositories/       # Реализации репозиториев
└── presentation/            # UI слой
    ├── bloc/               # BLoC state management
    ├── widgets/breez/      # UI компоненты
    └── screens/            # Экраны
```

---

## СИСТЕМА ДИЗАЙНА BREEZ

### Spacing (8px Grid)

**НИКОГДА** не используй hardcoded значения. **ВСЕГДА** `AppSpacing.*`:

```dart
// ✅ Правильно
SizedBox(height: AppSpacing.sm)
padding: EdgeInsets.all(AppSpacing.md)

// ❌ Неправильно
SizedBox(height: 12)
padding: EdgeInsets.all(16)
```

| Константа | Значение | Использование |
|-----------|----------|---------------|
| `xxs` | 4px | Микро-отступы внутри элементов |
| `xs` | 8px | Между мелкими элементами |
| `sm` | 12px | Стандартный отступ внутри карточек |
| `md` | 16px | Основной отступ, padding карточек |
| `lg` | 20px | Большие секции |
| `lgx` | 24px | Отступы в диалогах |
| `xl` | 32px | Между крупными блоками |
| `xxl` | 48px | Отступы экрана |

### Padding Convention

```dart
// Внешние отступы (между виджетами) — всегда sm
Padding(
  padding: EdgeInsets.all(AppSpacing.sm),  // 12px
  child: MyWidget(),
)

// Внутренние отступы — всегда xs (единообразно)
BreezCard(
  padding: EdgeInsets.all(AppSpacing.xs),  // 8px
  child: content,
)
```

| Контекст | Отступ | Значение |
|----------|--------|----------|
| Между виджетами (внешний) | `AppSpacing.sm` | 12px |
| Внутри виджета (padding) | `AppSpacing.xs` | 8px |
| Между элементами внутри | `AppSpacing.xs` | 8px |
| Микро-отступы (иконка-текст) | `AppSpacing.xxs` | 4px |

### Component Sizes (AppSizes)

**ВСЕГДА** используй `AppSizes.*` для стандартных размеров компонентов:

| Константа | Значение | Использование |
|-----------|----------|---------------|
| `tabHeight` | 36px | Стандартная высота tab/segmented control |
| `tabHeightLarge` | 48px | Большие табы |
| `buttonHeight` | 48px | Стандартная высота кнопки |
| `buttonHeightSmall` | 36px | Компактная кнопка |
| `minTouchTarget` | 48px | Минимальный размер touch target (Material) |
| `loaderSmall` | 16px | Маленький лоадер |
| `loaderMedium` | 24px | Средний лоадер |
| `loaderLarge` | 32px | Большой лоадер |

```dart
// ✅ Правильно
Container(height: AppSizes.tabHeight)
SizedBox(height: AppSizes.buttonHeight)

// ❌ Неправильно
Container(height: 36)
SizedBox(height: 48)
```

### Паттерн showCard

Виджеты с собственной карточкой должны иметь параметр `showCard` для вложенного использования:

```dart
class ModeGrid extends StatelessWidget {
  final bool showCard;  // default = true

  // В build():
  final content = _buildGrid();

  if (!showCard) return content;

  return BreezCard(
    padding: EdgeInsets.all(AppSpacing.xs),
    child: content,
  );
}

// Использование внутри другой карточки:
BreezCard(
  child: ModeGrid(showCard: false),  // Без двойной рамки
)
```

### Цвета

**ВСЕГДА** используй `BreezColors.of(context)` для темозависимых цветов:

```dart
final colors = BreezColors.of(context);

// Текст
colors.text       // Основной текст
colors.textMuted  // Второстепенный текст

// Фон
colors.card       // Фон карточки
colors.background // Фон экрана
colors.border     // Границы

// Акценты (статические)
AppColors.accent      // #00D9C4 - основной акцент
AppColors.accentGreen // Успех/активно
AppColors.error       // Ошибка
AppColors.warning     // Предупреждение
```

### Static Colors

Для нетемозависимых контекстов (shimmer, overlays):

```dart
// ✅ Правильно - статические цвета из AppColors
AppColors.white  // Чистый белый (#FFFFFF)
AppColors.black  // Чистый черный (#000000)

// ❌ Неправильно - не используй Colors напрямую
Colors.white
Colors.black
```

Используй в:
- Shimmer эффектах
- Полупрозрачных оверлеях
- Градиентах поверх изображений

### Opacity Constants

**ВСЕГДА** используй `AppColors.opacity*` для консистентной прозрачности:

| Константа | Значение | Использование |
|-----------|----------|---------------|
| `opacitySubtle` | 0.15 | Очень тонкие оверлеи |
| `opacityLow` | 0.3 | Легкие оверлеи, borders |
| `opacityMedium` | 0.5 | Стандартные оверлеи |
| `opacityHigh` | 0.7 | Сильные оверлеи |

```dart
// ✅ Правильно
AppColors.accent.withValues(alpha: AppColors.opacityMedium)
colors.card.withValues(alpha: AppColors.opacityHigh)

// ❌ Неправильно
AppColors.accent.withValues(alpha: 0.5)
colors.card.withOpacity(0.7)
```

### Border Radius

```dart
AppRadius.card       // 16px - карточки
AppRadius.cardSmall  // 12px - кнопки, маленькие карточки
AppRadius.button     // 12px - кнопки
AppRadius.nested     // 10px - вложенные элементы
AppRadius.chip       // 8px - chips, tags
AppRadius.indicator  // 4px - индикаторы
```

### Анимации

```dart
// Durations
AppDurations.fast    // 150ms - hover, focus
AppDurations.normal  // 200ms - стандарт
AppDurations.medium  // 300ms - раскрытие

// Curves
AppCurves.standard   // easeInOut
AppCurves.emphasize  // easeOutCubic
```

### Font Sizes

```dart
AppFontSizes.h1          // 28px
AppFontSizes.h2          // 24px
AppFontSizes.h3          // 20px
AppFontSizes.h4          // 16px
AppFontSizes.body        // 14px
AppFontSizes.bodySmall   // 13px
AppFontSizes.caption     // 12px
AppFontSizes.captionSmall// 11px
```

---

## БАЗОВЫЕ КОМПОНЕНТЫ

### Расположение

Все компоненты в `lib/presentation/widgets/breez/`:

| Компонент | Файл | Использование |
|-----------|------|---------------|
| `BreezButton` | `breez_button.dart` | Основная кнопка |
| `BreezIconButton` | `breez_icon_button.dart` | Иконка-кнопка |
| `BreezCard` | `breez_card.dart` | Карточка-контейнер |
| `BreezTextField` | `breez_text_field.dart` | Текстовое поле |
| `BreezSlider` | `breez_slider.dart` | Слайдер |
| `BreezDropdown` | `breez_dropdown.dart` | Выпадающий список |
| `BreezTab` | `breez_tab.dart` | Таб/вкладка |
| `BreezCheckbox` | `breez_checkbox.dart` | Чекбокс |
| `BreezLoader` | `breez_loader.dart` | Лоадер (вентилятор) |

### Импорт

```dart
// Все компоненты через единый экспорт
import 'package:hvac_control/presentation/widgets/breez/breez.dart';
```

---

## ЛОАДЕРЫ И СОСТОЯНИЯ ОЖИДАНИЯ

### BreezLoader

Тематический лоадер — вращающийся вентилятор (`Symbols.mode_fan` из `material_symbols_icons`).

```dart
// Размеры
BreezLoader.small()   // 16px - inline, рядом с текстом
BreezLoader.medium()  // 24px - стандартный (default)
BreezLoader.large()   // 32px - центрированный

// Кастомный цвет
BreezLoader.small(color: AppColors.accentOrange)

// С текстом (для полноэкранных состояний)
BreezLoaderWithText(text: 'Загрузка...')
```

### Когда использовать

| Ситуация | Лоадер |
|----------|--------|
| Изменение температуры | `BreezLoader.small(color: color)` вместо значения |
| Переключение питания | Overlay с `BreezLoader.large()` на весь виджет |
| Загрузка страницы | `BreezLoaderWithText()` по центру |
| Ожидание слайдера | Блокировка слайдера через `isPending` |

### Блокировка элементов при ожидании

**ClimateControlState** содержит флаги pending:

```dart
// Температура
isPendingHeatingTemperature  // Блокирует кнопки +/- нагрева
isPendingCoolingTemperature  // Блокирует кнопки +/- охлаждения

// Вентиляторы
isPendingSupplyFan           // Блокирует слайдер притока
isPendingExhaustFan          // Блокирует слайдер вытяжки

// Питание
isTogglingPower              // Показывает overlay на весь виджет
isTogglingSchedule           // Блокирует кнопку расписания
```

### Паттерн блокировки

```dart
// В TemperatureColumn - кнопки блокируются при isPending
final canDecrease = !isPending && (minTemp == null || temperature > minTemp!);
final canIncrease = !isPending && (maxTemp == null || temperature < maxTemp!);

// Вместо значения показываем лоадер
child: isPending
    ? BreezLoader.small(color: color)
    : Text('$temperature°C', ...),

// В FanSlider - слайдер блокируется
final isEnabled = widget.onChanged != null && !widget.isPending;

// В MainTempCard - overlay при переключении питания
if (isPowerLoading)
  Positioned.fill(
    child: Container(
      color: colors.card.withValues(alpha: 0.7),
      child: Center(child: BreezLoader.large()),
    ),
  ),
```

### Пакет material_symbols_icons

Для иконки вентилятора используется пакет `material_symbols_icons`:

```dart
import 'package:material_symbols_icons/symbols.dart';

Icon(Symbols.mode_fan, size: 24, color: AppColors.accent)
```

---

## ПАТТЕРНЫ И ПРИНЦИПЫ

### SOLID

#### S - Single Responsibility
```dart
// ❌ Неправильно - виджет делает всё
class BigWidget {
  // layout, business logic, API calls, state
}

// ✅ Правильно - разделение ответственности
class _Header extends StatelessWidget { }
class _Content extends StatelessWidget { }
class _TimeBlock extends StatefulWidget { }
```

#### O - Open/Closed
```dart
// ✅ Расширяемость через параметры, не изменение кода
class BreezTab {
  final Color? activeIndicatorColor; // Можно кастомизировать
}
```

#### D - Dependency Inversion
```dart
// ✅ Зависимость от абстракций
class ClimateBloc {
  final ClimateRepository repository; // Интерфейс, не реализация
}
```

### DRY (Don't Repeat Yourself)

```dart
// ❌ Дублирование
if (compact) {
  return Row(children: [Text(...), Switch(...)]);
} else {
  return Row(children: [Text(...), Switch(...)]);  // Тот же код!
}

// ✅ Вынести общий код
Widget _buildHeader() => Row(children: [Text(...), Switch(...)]);
```

### Map вместо switch-case

```dart
// ❌ Switch-case (verbose, error-prone)
switch (englishDay.toLowerCase()) {
  case 'monday': return l10n.monday;
  case 'tuesday': return l10n.tuesday;
  case 'wednesday': return l10n.wednesday;
  // ...
}

// ✅ Map lookup (concise, maintainable)
final dayMap = <String, String>{
  'monday': l10n.monday,
  'tuesday': l10n.tuesday,
  'wednesday': l10n.wednesday,
  // ...
};
return dayMap[englishDay.toLowerCase()] ?? englishDay;
```

### Константы вместо Magic Numbers

```dart
// ❌ Magic numbers
BorderRadius.circular(8)
Duration(milliseconds: 150)
SizedBox(height: 2)

// ✅ Константы
abstract class _TabConstants {
  static const double borderRadius = 8.0;
  static const Duration animationDuration = Duration(milliseconds: 150);
  static const double indicatorSize = 6.0;
}
```

---

## ACCESSIBILITY

**ОБЯЗАТЕЛЬНО** добавляй Semantics:

```dart
// ✅ Правильно
Semantics(
  button: true,
  label: 'Начало: 08:00',
  child: GestureDetector(...),
)

Semantics(
  header: true,
  child: Text('Понедельник'),
)

Semantics(
  toggled: isEnabled,
  label: 'Включено',
  child: Switch(...),
)
```

---

## BLoC ПАТТЕРН

### Структура файлов

```
bloc/
├── climate/
│   ├── climate_bloc.dart   # BLoC логика
│   ├── climate_event.dart  # Events (sealed class)
│   └── climate_state.dart  # State (Equatable)
```

### Events - Sealed Classes

```dart
sealed class ClimateEvent {}

final class ClimateSubscriptionRequested extends ClimateEvent {}
final class ClimatePowerToggled extends ClimateEvent {
  final bool isOn;
  ClimatePowerToggled(this.isOn);
}
```

### State - Equatable

```dart
enum ClimateStatus { initial, loading, success, failure }

class ClimateState extends Equatable {
  final ClimateStatus status;
  final ClimateData? data;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, data, errorMessage];
}
```

### Optimistic Updates

```dart
Future<void> _onPowerToggled(event, emit) async {
  final oldState = state.data;

  // 1. Оптимистичное обновление UI
  emit(state.copyWith(data: oldState?.copyWith(isOn: event.isOn)));

  try {
    // 2. Запрос к серверу
    await repository.setPower(event.isOn);
  } catch (e) {
    // 3. Откат при ошибке
    emit(state.copyWith(
      data: oldState,
      errorMessage: e.toString(),
    ));
  }
}
```

---

## СТРУКТУРА ВИДЖЕТА

### Шаблон файла

```dart
/// Описание виджета
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _WidgetConstants {
  static const double borderRadius = 10.0;
  static const Duration animationDuration = Duration(milliseconds: 150);
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Основной виджет
///
/// Описание функциональности...
class MyWidget extends StatefulWidget {
  /// Документация параметра
  final String label;

  const MyWidget({super.key, required this.label});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    // ...
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

class _SubWidget extends StatelessWidget {
  // ...
}
```

---

## NAMING CONVENTIONS

### Файлы

| Тип | Паттерн | Пример |
|-----|---------|--------|
| Компонент | `breez_*.dart` | `breez_button.dart` |
| BLoC | `*_bloc.dart` | `climate_bloc.dart` |
| Events | `*_event.dart` | `climate_event.dart` |
| State | `*_state.dart` | `climate_state.dart` |
| Entity | `*.dart` | `climate.dart` |
| Repository | `*_repository.dart` | `climate_repository.dart` |

### Классы

| Тип | Паттерн | Пример |
|-----|---------|--------|
| Widget | `Breez*` | `BreezButton` |
| Private widget | `_*` | `_DayHeader` |
| Constants | `_*Constants` | `_TabConstants` |
| BLoC | `*Bloc` | `ClimateBloc` |

### Переменные

```dart
// Состояния
_isHovered, _isPressed, _isEnabled

// Вычисляемые
get _formattedTime => ...
get _isEnabled => widget.onChanged != null

// Callbacks
_onTap(), _onHover(), _handleChange()
```

---

## LINT RULES

### Локальная проверка

Перед коммитом **ОБЯЗАТЕЛЬНО** прогоняй lint локально:

```bash
# Полный анализ кода
flutter analyze

# Проверка форматирования
dart format --set-exit-if-changed .

# Запуск тестов
flutter test
```

### Настройка analysis_options.yaml

Проект использует строгие правила линтера из `analysis_options.yaml`:

- **Обязательные типы** - все переменные должны иметь явные типы
- **Запрет unused imports** - удаляй неиспользуемые импорты
- **Константы** - используй `const` где возможно
- **Accessibility** - обязательные Semantics для интерактивных элементов

### Исправление warnings

```bash
# Показать все warnings с контекстом
flutter analyze --verbose

# Автоформатирование
dart format .

# Удалить unused imports (вручную или через IDE)
```

---

## ПРОВЕРКА ДИЗАЙН-СИСТЕМЫ

### Автоматическая проверка соответствия

Проект включает специализированный скрипт для проверки соблюдения стандартов BREEZ дизайн-системы.

**ОБЯЗАТЕЛЬНО** запускай перед каждым коммитом:

```bash
# Из корня проекта
cd IOT_App && ./scripts/check_design_system.sh

# Или из директории IOT_App
./scripts/check_design_system.sh
```

### Что проверяется (8 категорий)

Скрипт проверяет весь код в `lib/` на соответствие стандартам:

| № | Категория | Что проверяется | Что использовать |
|---|-----------|-----------------|------------------|
| 1 | **Colors.white/black** | Использование Flutter Colors напрямую | `AppColors.white`, `AppColors.black` |
| 2 | **EdgeInsets** | Hardcoded значения padding/margin | `AppSpacing.*` (xxs, xs, sm, md, lg, xl, xxl) |
| 3 | **BorderRadius** | Hardcoded значения скруглений | `AppRadius.*` (card, button, chip, nested) |
| 4 | **Duration** | Hardcoded длительности анимаций | `AppDurations.*` (fast, normal, medium) |
| 5 | **ElevatedButton** | Использование Material кнопок | `BreezButton` |
| 6 | **TextButton** | Использование Material кнопок | `BreezButton` или `BreezIconButton` |
| 7 | **SizedBox** | Hardcoded width/height | `AppSpacing.*`, `AppSizes.*` |
| 8 | **Font sizes** | Hardcoded размеры шрифтов | `AppFontSizes.*` (h1-h4, body, caption) |

### Пример вывода

```bash
================================================
   Design System Violations Checker
================================================

[1/8] Checking for hardcoded Colors.white and Colors.black...
  ✅ No violations found

[2/8] Checking for hardcoded EdgeInsets...
  ❌ lib/presentation/screens/dashboard/dashboard_screen.dart
     Line 45: Use AppSpacing constants instead of hardcoded values

[3/8] Checking for hardcoded BorderRadius.circular...
  ✅ No violations found

...

================================================
   Summary
================================================
❌ Found 1 file(s) with design system violations.

Please fix the violations above by:
  1. Using AppSpacing.* for all spacing and padding
  2. Using AppRadius.* for all border radius values
  3. Using AppDurations.* for all animation durations
  4. Using AppFontSizes.* for all font sizes
  5. Using AppColors.white/black instead of Colors.white/black
  6. Using Breez* components instead of Material buttons
```

### Исключённые файлы

Скрипт автоматически исключает файлы дизайн-системы:
- `lib/core/theme/*.dart` - сами константы темы
- `lib/core/config/app_constants.dart` - конфигурация
- `lib/core/navigation/app_router.dart` - роутинг

### При обнаружении нарушений

1. **Прочитай вывод** - скрипт указывает файл и строку
2. **Открой файл** и найди указанную строку
3. **Замени hardcoded значение** на константу из дизайн-системы:
   ```dart
   // ❌ До
   fontSize: 14
   padding: EdgeInsets.all(16)
   BorderRadius.circular(12)

   // ✅ После
   fontSize: AppFontSizes.body
   padding: EdgeInsets.all(AppSpacing.md)
   BorderRadius.circular(AppRadius.button)
   ```
4. **Запусти скрипт снова** - проверь, что нарушение исправлено
5. **Повтори** до тех пор, пока все 8 категорий не будут зелёными

### Exit Code

- **0** - все проверки пройдены ✅
- **1** - найдены нарушения ❌

Это позволяет использовать скрипт в CI/CD пайплайнах.

---

## ЧЕКЛИСТ ПЕРЕД КОММИТОМ

### Автоматические проверки
- [ ] **`./scripts/check_design_system.sh`** - все 8 категорий ✅
- [ ] `flutter analyze` без warnings
- [ ] `dart format --set-exit-if-changed .` без изменений
- [ ] `flutter test` все тесты проходят

### Дизайн-система
- [ ] Нет hardcoded цветов, размеров, отступов
- [ ] Используются AppSpacing.*, AppColors.*, AppRadius.*
- [ ] Используются AppSizes.* для размеров компонентов
- [ ] Используются AppFontSizes.* для размеров шрифтов
- [ ] Opacity values используют AppColors.opacity*
- [ ] Нет использования Colors.white/Colors.black (только AppColors.white/black)
- [ ] Нет Material кнопок (только BreezButton/BreezIconButton)

### Код-качество
- [ ] Добавлены Semantics для accessibility
- [ ] Constants вынесены в abstract class
- [ ] Нет дублирования кода (DRY)
- [ ] Каждый класс имеет одну ответственность (SRP)
- [ ] Документация на публичных API
- [ ] Код соответствует этому гайду

---

## RESPONSIVE DESIGN

### Breakpoints

```dart
// Проверка типа устройства
if (AppBreakpoints.isMobile(context)) { }
if (AppBreakpoints.isTablet(context)) { }
if (AppBreakpoints.isDesktop(context)) { }

// Или через extension
context.isMobile
context.isDesktop

// Количество колонок грида
final columns = AppBreakpoints.getGridColumns(context); // 1, 2, 3, или 4
```

### Адаптивные значения

```dart
// В виджете
padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md)

// Через breakpoints
padding: context.isMobile
    ? EdgeInsets.all(AppSpacing.sm)
    : EdgeInsets.all(AppSpacing.md)
```

---

## MOBILE UI ПАТТЕРНЫ

### Сегментированный контрол vs Навигация

**Проблема:** Двойная навигация (табы внутри + bottom nav) запутывает пользователя.

**Решение:** Внутренние табы делать визуально как **сегментированный контрол**:

```dart
// ❌ Выглядит как навигация (путает)
TabBar с underline indicator

// ✅ Выглядит как переключатель контента
Container(
  decoration: BoxDecoration(
    color: colors.buttonBg.withValues(alpha: 0.5),
    borderRadius: BorderRadius.circular(AppRadius.chip),
  ),
  child: Row(children: segments),
)
```

| Элемент | Навигация (bottom bar) | Контент (segmented) |
|---------|------------------------|---------------------|
| Фон | Сплошной | Полупрозрачный |
| Выбранный | Акцентная иконка | Подсветка + рамка |
| Текст | Под иконкой | Рядом с иконкой |
| Высота | 56-64px | 36px |

### Mobile Layout Structure

```dart
abstract class _MobileLayoutConstants {
  static const double tabContentHeight = 150.0;  // Фиксированная высота
}

// Структура:
Column(
  children: [
    Expanded(child: MainControlCard()),      // Занимает остаток
    SizedBox(height: AppSpacing.sm),
    BreezCard(                               // Табы + контент вместе
      child: Column(
        children: [
          MobileTabBar(),                    // 36px
          SizedBox(height: AppSpacing.xs),
          SizedBox(
            height: tabContentHeight,        // 150px фикс
            child: TabBarView(),
          ),
        ],
      ),
    ),
  ],
)
```

### Touch Targets

Минимальный размер кнопки: **48x48px** (Material Design)

```dart
const double kMinTouchTarget = 48.0;

// В BreezIconButton автоматически:
final buttonSize = size < kMinTouchTarget ? kMinTouchTarget : size;
```

---

## ЧАСТЫЕ ОШИБКИ

### ❌ Late initialization error

```dart
// ❌ Проблема с hot reload
late int _selectedIndex;

@override
void initState() {
  _selectedIndex = DateTime.now().weekday - 1;
}

// ✅ Инициализация при объявлении
int _selectedIndex = DateTime.now().weekday - 1;
```

### ❌ RenderFlex overflow

```dart
// ❌ Column со Spacer в ограниченном пространстве
Column(children: [Widget(), Spacer(), Widget()])

// ✅ Используй Expanded или ListView
Column(children: [Widget(), Expanded(child: Widget())])
```

### ❌ Забыл mounted check

```dart
// ❌ setState после dispose
final result = await showDialog();
setState(() => _value = result);

// ✅ Проверка mounted
final result = await showDialog();
if (mounted) setState(() => _value = result);
```

---

## ОБРАЗЦОВЫЕ ВИДЖЕТЫ

При создании новых виджетов используй эти файлы как эталон:

| Виджет | Файл | Что смотреть |
|--------|------|--------------|
| DailyScheduleWidget | `daily_schedule_widget.dart` | Полная структура: Constants, SRP, Semantics |
| BreezTab | `breez_tab.dart` | Accessibility, hover, extracted methods |
| TemperatureColumn | `temp_column.dart` | Compact mode, Semantics на кнопках |
| ClimateBloc | `climate_bloc.dart` | Optimistic updates, sealed events |

---

## АУДИТ ПРОЕКТА

Полный отчёт по соответствию стандартам: `AUDIT_REPORT.md`

Текущая оценка: **92%**

---

*Последнее обновление: 2026-01-18*
