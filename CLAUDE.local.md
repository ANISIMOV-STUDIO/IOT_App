# IOT_App Development Guide

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
| `xl` | 32px | Между крупными блоками |
| `xxl` | 48px | Отступы экрана |

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

### Импорт

```dart
// Все компоненты через единый экспорт
import 'package:hvac_control/presentation/widgets/breez/breez.dart';
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

## ЧЕКЛИСТ ПЕРЕД КОММИТОМ

- [ ] Нет hardcoded цветов, размеров, отступов
- [ ] Используются AppSpacing.*, AppColors.*, AppRadius.*
- [ ] Добавлены Semantics для accessibility
- [ ] Constants вынесены в abstract class
- [ ] Нет дублирования кода (DRY)
- [ ] Каждый класс имеет одну ответственность (SRP)
- [ ] Документация на публичных API
- [ ] `flutter analyze` без warnings
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

*Последнее обновление: 2026-01-08*
