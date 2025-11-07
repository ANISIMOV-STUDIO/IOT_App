# 🏗️ План архитектурной миграции - UI Kit First

> Цель: Основное приложение должно быть конструктором из блоков UI kit
> Дата: 2025-01-XX
> Статус: 🔄 В процессе

---

## 🎯 Концепция "Constructor from Blocks"

### Текущая проблема
```
IOT_App/
├── lib/presentation/widgets/    ❌ 100+ компонентов
│   ├── orange_button.dart       ❌ Должен быть в UI kit
│   ├── outline_button.dart      ❌ Должен быть в UI kit
│   ├── gradient_button.dart     ❌ Должен быть в UI kit
│   ├── empty_state.dart         ❌ Должен быть в UI kit
│   ├── error_state.dart         ❌ Должен быть в UI kit
│   └── ...                      ❌ И т.д.
```

### Желаемая архитектура
```
IOT_App/
├── lib/presentation/
│   ├── pages/                   ✅ Только экраны-конструкторы
│   ├── bloc/                    ✅ Только бизнес-логика
│   └── widgets/                 ⚠️ ТОЛЬКО domain-specific (HVAC-логика)
│       ├── device/              ✅ Специфичные для устройств
│       ├── schedule/            ✅ Специфичные для расписания
│       └── analytics/           ✅ Специфичные для аналитики

hvac_ui_kit/
├── lib/src/
│   ├── theme/                   ✅ ВСЕ цвета и стили
│   ├── widgets/                 ✅ ВСЕ переиспользуемые компоненты
│   │   ├── buttons/             ✅ Все типы кнопок
│   │   ├── cards/               ✅ Все типы карточек
│   │   ├── states/              ✅ Empty, Error, Loading
│   │   ├── inputs/              ✅ Формы и поля ввода
│   │   ├── feedback/            ✅ Snackbar, Toast, Dialog
│   │   └── layouts/             ✅ Responsive containers
```

---

## 📦 Компоненты для миграции

### 1. Кнопки (Priority: HIGH) 🔴

| Компонент | Путь | Строк | Статус |
|-----------|------|-------|--------|
| OrangeButton | `widgets/orange_button.dart` | 79 | ⏳ Pending |
| OutlineButton | `widgets/outline_button.dart` | 89 | ⏳ Pending |
| GradientButton | `widgets/gradient_button.dart` | 78 | ⏳ Pending |
| AnimatedPrimaryButton | `widgets/common/buttons/animated_primary_button.dart` | 210 | ⏳ Pending |
| AnimatedOutlineButton | `widgets/common/buttons/animated_outline_button.dart` | 199 | ⏳ Pending |
| AnimatedTextButton | `widgets/common/buttons/animated_text_button.dart` | ~150 | ⏳ Pending |
| AccessibleButton | `widgets/common/accessible_button.dart` | ~120 | ⏳ Pending |

**Итого**: 7 типов кнопок, ~925 строк

**Новая структура в UI kit**:
```dart
hvac_ui_kit/lib/src/widgets/buttons/
├── hvac_primary_button.dart       // OrangeButton → HvacPrimaryButton
├── hvac_outline_button.dart       // OutlineButton → HvacOutlineButton
├── hvac_text_button.dart          // AnimatedTextButton → HvacTextButton
├── hvac_icon_button.dart          // NEW: IconButton wrapper
└── button_types.dart              // Enums и типы
```

---

### 2. Состояния (States) (Priority: HIGH) 🔴

| Компонент | Путь | Строк | Статус |
|-----------|------|-------|--------|
| EmptyState | `widgets/common/empty_state.dart` | 110 | ⏳ Pending |
| ErrorState | `widgets/common/error_state.dart` | 123 | ⏳ Pending |
| LoadingWidget | `widgets/common/loading_widget.dart` | ~80 | ⏳ Pending |
| EnhancedEmptyState | `widgets/common/enhanced_empty_state.dart` | ~150 | ⏳ Pending |
| ErrorWidget | `widgets/common/error_widget.dart` | ~100 | ⏳ Pending |

**Итого**: 5 компонентов состояний, ~563 строк

**Новая структура в UI kit**:
```dart
hvac_ui_kit/lib/src/widgets/states/
├── hvac_empty_state.dart          // Consolidated empty states
├── hvac_error_state.dart          // Consolidated error states
├── hvac_loading_state.dart        // Consolidated loading states
└── state_types.dart               // Enums
```

---

### 3. Карточки (Cards) (Priority: MEDIUM) 🟡

| Компонент | Путь | Строк | Статус |
|-----------|------|-------|--------|
| AnimatedCard | `widgets/common/animated_card.dart` | ~120 | ⏳ Pending |
| GlassmorphicCard | `widgets/common/glassmorphic_card.dart` | ~200 | ⏳ Pending |
| DashboardStatCard | `widgets/dashboard_stat_card.dart` | ~150 | ⏳ Pending |
| TemperatureInfoCard | `widgets/temperature_info_card.dart` | ~180 | ⏳ Pending |

**Итого**: 4 типа карточек, ~650 строк

**Новая структура в UI kit**:
```dart
hvac_ui_kit/lib/src/widgets/cards/
├── hvac_card.dart                 // Base card
├── hvac_stat_card.dart            // Statistics card
├── hvac_info_card.dart            // Info card with icon
├── hvac_glass_card.dart           // Glassmorphic card
└── card_types.dart                // Enums
```

---

### 4. Уведомления (Feedback) (Priority: MEDIUM) 🟡

| Компонент | Путь | Строк | Статус |
|-----------|------|-------|--------|
| AppSnackbar | `widgets/common/app_snackbar.dart` | ~100 | ⏳ Pending |
| SuccessSnackbar | `widgets/common/snackbar/success_snackbar.dart` | ~80 | ⏳ Pending |
| WarningSnackbar | `widgets/common/snackbar/warning_snackbar.dart` | ~80 | ⏳ Pending |
| InfoSnackbar | `widgets/common/snackbar/info_snackbar.dart` | ~80 | ⏳ Pending |
| ToastNotification | `widgets/common/snackbar/toast_notification.dart` | ~120 | ⏳ Pending |

**Итого**: 5 компонентов уведомлений, ~460 строк

**Новая структура в UI kit**:
```dart
hvac_ui_kit/lib/src/widgets/feedback/
├── hvac_snackbar.dart             // Unified snackbar system
├── hvac_toast.dart                // Toast notifications
├── hvac_dialog.dart               // Dialog wrapper
└── feedback_types.dart            // Enums и типы
```

---

### 5. Формы и поля ввода (Priority: MEDIUM) 🟡

| Компонент | Путь | Строк | Статус |
|-----------|------|-------|--------|
| AuthInputField | `widgets/auth/auth_input_field.dart` | ~150 | ⏳ Pending |
| AuthPasswordField | `widgets/auth/auth_password_field.dart` | ~180 | ⏳ Pending |
| PasswordStrengthIndicator | `widgets/auth/password_strength_indicator.dart` | ~120 | ⏳ Pending |

**Итого**: 3 компонента форм, ~450 строк

**Новая структура в UI kit**:
```dart
hvac_ui_kit/lib/src/widgets/inputs/
├── hvac_text_field.dart           // Generic text input
├── hvac_password_field.dart       // Password with toggle
├── hvac_search_field.dart         // Search input
└── input_decorations.dart         // Input styles
```

---

### 6. Анимации и визуальные эффекты (Priority: LOW) 🟢

| Компонент | Путь | Строк | Статус |
|-----------|------|-------|--------|
| ShimmerLoader | `widgets/common/shimmer/base_shimmer.dart` | ~150 | ⏳ Pending |
| PulseSkeleton | `widgets/common/shimmer/pulse_skeleton.dart` | ~120 | ⏳ Pending |
| EnhancedShimmer | `widgets/common/enhanced_shimmer.dart` | ~180 | ⏳ Pending |
| LoginSkeleton | `widgets/common/login_skeleton.dart` | ~200 | ⏳ Pending |

**Итого**: 4 компонента анимаций, ~650 строк

**Примечание**: Часть уже есть в UI kit (HvacSkeletonLoader)

---

## 🔄 План миграции (Поэтапный)

### Этап 1: Кнопки (HIGH Priority) ✅
- [x] Создать `hvac_ui_kit/lib/src/widgets/buttons/`
- [ ] Перенести все 7 типов кнопок
- [ ] Унифицировать API (HvacButton с вариантами)
- [ ] Обновить цвета на corporate (blue theme)
- [ ] Экспортировать в `hvac_ui_kit.dart`
- [ ] Заменить импорты в основном приложении

**Ожидаемый результат**:
```dart
// До
import '../widgets/orange_button.dart';
OrangeButton(text: 'Submit', onPressed: _submit);

// После
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
HvacPrimaryButton(label: 'Submit', onPressed: _submit);
```

---

### Этап 2: Состояния (HIGH Priority)
- [ ] Создать `hvac_ui_kit/lib/src/widgets/states/`
- [ ] Перенести Empty/Error/Loading states
- [ ] Унифицировать API
- [ ] Добавить адаптивность (mobile/tablet/desktop)
- [ ] Экспортировать в `hvac_ui_kit.dart`
- [ ] Заменить импорты в основном приложении

---

### Этап 3: Карточки (MEDIUM Priority)
- [ ] Создать `hvac_ui_kit/lib/src/widgets/cards/`
- [ ] Перенести все типы карточек
- [ ] Унифицировать декорацию (glassmorphism)
- [ ] Добавить responsive padding
- [ ] Экспортировать в `hvac_ui_kit.dart`

---

### Этап 4: Уведомления (MEDIUM Priority)
- [ ] Создать `hvac_ui_kit/lib/src/widgets/feedback/`
- [ ] Перенести snackbar/toast компоненты
- [ ] Создать единый API для показа уведомлений
- [ ] Добавить типы (success, error, warning, info)
- [ ] Экспортировать в `hvac_ui_kit.dart`

---

### Этап 5: Формы (MEDIUM Priority)
- [ ] Создать `hvac_ui_kit/lib/src/widgets/inputs/`
- [ ] Перенести input fields
- [ ] Унифицировать валидацию
- [ ] Добавить accessibility
- [ ] Экспортировать в `hvac_ui_kit.dart`

---

### Этап 6: Очистка (LOW Priority)
- [ ] Удалить старые файлы из основного приложения
- [ ] Проверить неиспользуемые импорты
- [ ] Обновить документацию
- [ ] Создать миграционный гайд

---

## 📊 Метрики до и после

### До миграции
```
IOT_App/lib/presentation/widgets/: 100+ файлов, ~8,000 строк
hvac_ui_kit/lib/src/widgets/:      10 файлов,   ~1,500 строк

Переиспользуемость:                LOW (дублирование)
Maintainability:                   MEDIUM (сложно найти)
Dependency graph:                  COMPLEX (циклы)
```

### После миграции (цель)
```
IOT_App/lib/presentation/widgets/: ~40 файлов,   ~3,000 строк (только domain)
hvac_ui_kit/lib/src/widgets/:      ~35 файлов,   ~6,500 строк (все UI)

Переиспользуемость:                HIGH (single source)
Maintainability:                   HIGH (четкая структура)
Dependency graph:                  CLEAN (UI kit → App)
```

---

## 🎨 Унификация API

### Текущее состояние (хаос)
```dart
// 7 разных API для кнопок
OrangeButton(text: 'Submit', onPressed: _submit);
OutlineButton(text: 'Cancel', onPressed: _cancel);
GradientButton(text: 'Next', onPressed: _next);
AnimatedPrimaryButton(label: 'Confirm', onPressed: _confirm);
AnimatedOutlineButton(label: 'Back', onPressed: _back);
```

### После унификации (порядок)
```dart
// Единый API с вариантами
HvacButton.primary(label: 'Submit', onPressed: _submit);
HvacButton.secondary(label: 'Cancel', onPressed: _cancel);
HvacButton.text(label: 'Skip', onPressed: _skip);
HvacButton.icon(icon: Icons.add, onPressed: _add);

// Или через параметр
HvacButton(
  label: 'Submit',
  variant: ButtonVariant.primary,
  onPressed: _submit,
);
```

---

## 🔍 Критерии отбора компонентов

### ✅ Переносим в UI kit:
1. **Визуальные компоненты** без бизнес-логики
2. **Переиспользуемые** в 2+ местах
3. **Generic** (не зависят от domain)
4. **Stateless** или минимальный state (анимации)

### ❌ Оставляем в основном приложении:
1. **Domain-specific** (DeviceCard с HVAC логикой)
2. **BLoC-зависимые** (требуют конкретный BLoC)
3. **Screen-specific** (используется только в 1 экране)
4. **Business logic** (расчеты, валидация бизнес-правил)

---

## 📝 Примеры миграции

### Пример 1: Кнопка

**До** (`IOT_App/lib/presentation/widgets/orange_button.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class OrangeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  // ...
}
```

**После** (`hvac_ui_kit/lib/src/widgets/buttons/hvac_primary_button.dart`):
```dart
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class HvacPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  // ...
}
```

**Использование** (`IOT_App/lib/presentation/pages/login_screen.dart`):
```dart
// До
import '../widgets/orange_button.dart';
OrangeButton(text: 'Login', onPressed: _login);

// После
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
HvacPrimaryButton(label: 'Login', onPressed: _login);
```

---

### Пример 2: Empty State

**До** (`IOT_App/lib/presentation/widgets/common/empty_state.dart`):
```dart
class EmptyState extends StatelessWidget {
  final String message;
  final String? title;
  // ...
}
```

**После** (`hvac_ui_kit/lib/src/widgets/states/hvac_empty_state.dart`):
```dart
class HvacEmptyState extends StatelessWidget {
  final String message;
  final String? title;
  final EmptyStateVariant variant; // NEW: mobile/tablet/desktop
  // ...
}
```

---

## 🚀 Преимущества после миграции

### 1. Единый источник истины (Single Source of Truth)
- ✅ Все UI компоненты в одном месте
- ✅ Изменение стиля в 1 месте → применяется везде
- ✅ Нет дублирования кода

### 2. Легкая поддержка (Maintainability)
- ✅ Четкая структура: UI kit vs Domain logic
- ✅ Проще найти нужный компонент
- ✅ Легче онбордить новых разработчиков

### 3. Тестируемость (Testability)
- ✅ UI kit можно тестировать независимо
- ✅ Widget tests для всех компонентов
- ✅ Visual regression testing

### 4. Документация (Documentation)
- ✅ UI kit как живая документация
- ✅ Storybook/Widgetbook для демонстрации
- ✅ API reference автогенерация

### 5. Переиспользование (Reusability)
- ✅ UI kit можно использовать в других проектах
- ✅ Можно опубликовать как pub package
- ✅ Версионирование независимо от приложения

---

## ⚠️ Риски и митигация

### Риск 1: Сломать существующий функционал
**Митигация**:
- Миграция поэтапная (по категориям)
- Тестирование после каждого этапа
- Сохранение старых файлов до полной миграции

### Риск 2: API breaking changes
**Митигация**:
- Использовать named constructors для вариантов
- Сохранить обратную совместимость где возможно
- Документировать все изменения

### Риск 3: Увеличение сложности зависимостей
**Митигация**:
- Минимизировать зависимости в UI kit
- Использовать dependency injection
- Четкие boundaries между слоями

---

## 📈 Timeline (ориентировочный)

| Этап | Компоненты | Время | Статус |
|------|------------|-------|--------|
| 1 | Кнопки (7 типов) | 4-6 часов | ⏳ Pending |
| 2 | Состояния (5 типов) | 3-4 часа | ⏳ Pending |
| 3 | Карточки (4 типа) | 3-4 часа | ⏳ Pending |
| 4 | Уведомления (5 типов) | 3-4 часа | ⏳ Pending |
| 5 | Формы (3 типа) | 2-3 часа | ⏳ Pending |
| 6 | Очистка и тесты | 2-3 часа | ⏳ Pending |

**Итого**: 17-24 часа чистой работы

---

## ✅ Критерии успеха

- [ ] Все кнопки в UI kit
- [ ] Все состояния (empty/error/loading) в UI kit
- [ ] Все карточки в UI kit
- [ ] Все уведомления в UI kit
- [ ] Все формы в UI kit
- [ ] `dart analyze` без ошибок
- [ ] `flutter build web` успешно
- [ ] Все экраны работают как раньше
- [ ] Уменьшение строк кода в основном приложении на 40%+
- [ ] Документация обновлена

---

## 🎉 Итоговая архитектура

```
BREEZ Home (IOT_App)
├── Только конструктор из блоков
├── Только domain-specific компоненты
└── Только бизнес-логика (BLoC)

HVAC UI Kit
├── ВСЕ переиспользуемые UI компоненты
├── ВСЕ цвета и стили
├── ВСЕ анимации и эффекты
└── ZERO бизнес-логики
```

**"The app is just a constructor from UI kit blocks"** ✅

---

*Создано с помощью [Claude Code](https://claude.com/claude-code)*
*Co-Authored-By: Claude <noreply@anthropic.com>*
