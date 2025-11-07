# 🔄 Руководство по миграции кнопок в UI Kit

> Первый этап архитектурной миграции - Кнопки
> Дата: 2025-01-XX
> Статус: ✅ Готово к применению

---

## 🎯 Что изменилось?

### Новые компоненты в `hvac_ui_kit`

Созданы 3 новых профессиональных компонента кнопок:

1. **HvacPrimaryButton** - Основная кнопка (градиент синего)
2. **HvacOutlineButton** - Вторичная кнопка (контур)
3. **HvacTextButton** - Текстовая кнопка (без фона)
4. **HvacIconButton** - Иконочная кнопка (круглая)

---

## 📦 Что перенесено в UI Kit

### Файлы в `hvac_ui_kit/lib/src/widgets/buttons/`:

```
buttons/
├── hvac_primary_button.dart      (268 строк) ✅
├── hvac_outline_button.dart      (203 строк) ✅
├── hvac_text_button.dart         (284 строк) ✅
└── buttons.dart                  (8 строк) ✅
```

**Итого**: 763 строки чистого, производственного кода

---

## 🔄 Таблица миграции

| Старый компонент | Новый компонент | Примечание |
|------------------|-----------------|------------|
| `OrangeButton` | `HvacPrimaryButton` | Теперь синий градиент |
| `GradientButton` | `HvacPrimaryButton` | Объединены |
| `AnimatedPrimaryButton` | `HvacPrimaryButton` | Объединены |
| `OutlineButton` | `HvacOutlineButton` | Унифицирован |
| `AnimatedOutlineButton` | `HvacOutlineButton` | Объединены |
| `AnimatedTextButton` | `HvacTextButton` | Унифицирован |
| `AccessibleButton` | `HvacIconButton` | Для иконок |

---

## 📝 Примеры миграции кода

### Пример 1: Основная кнопка (Primary)

**До**:
```dart
import '../widgets/orange_button.dart';

OrangeButton(
  text: 'Войти',
  onPressed: _handleLogin,
  icon: Icons.login,
  isLoading: _isLoading,
)
```

**После**:
```dart
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

HvacPrimaryButton(
  label: 'Войти',
  onPressed: _handleLogin,
  icon: Icons.login,
  isLoading: _isLoading,
)
```

**Изменения**:
- ✅ `text` → `label`
- ✅ Импорт из UI kit
- ✅ Цвет автоматически синий (corporate theme)

---

### Пример 2: Кнопка с контуром (Outline)

**До**:
```dart
import '../widgets/outline_button.dart';

OutlineButton(
  text: 'Отмена',
  onPressed: _handleCancel,
  height: 48,
)
```

**После**:
```dart
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

HvacOutlineButton(
  label: 'Отмена',
  onPressed: _handleCancel,
  size: HvacButtonSize.medium, // 48px высота
)
```

**Изменения**:
- ✅ `text` → `label`
- ✅ `height: 48` → `size: HvacButtonSize.medium`
- ✅ Цвет автоматически синий

---

### Пример 3: Градиентная кнопка

**До**:
```dart
import '../widgets/gradient_button.dart';

GradientButton(
  text: 'Продолжить',
  onPressed: _next,
  width: 200,
)
```

**После**:
```dart
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

HvacPrimaryButton(
  label: 'Продолжить',
  onPressed: _next,
  width: 200,
)
```

**Примечание**: `GradientButton` объединен с `HvacPrimaryButton`, т.к. градиент теперь по умолчанию.

---

### Пример 4: Анимированная кнопка

**До**:
```dart
import '../widgets/common/buttons/animated_primary_button.dart';

AnimatedPrimaryButton(
  label: 'Сохранить',
  onPressed: _save,
  icon: Icons.save,
  isExpanded: true,
)
```

**После**:
```dart
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

HvacPrimaryButton(
  label: 'Сохранить',
  onPressed: _save,
  icon: Icons.save,
  isExpanded: true,
)
```

**Изменения**:
- ✅ Анимация включена по умолчанию
- ✅ Haptic feedback по умолчанию
- ✅ Hover эффекты для web

---

### Пример 5: Текстовая кнопка

**До**:
```dart
import '../widgets/common/buttons/animated_text_button.dart';

AnimatedTextButton(
  label: 'Пропустить',
  onPressed: _skip,
)
```

**После**:
```dart
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

HvacTextButton(
  label: 'Пропустить',
  onPressed: _skip,
)
```

---

### Пример 6: Иконочная кнопка

**Новый компонент** (не было в старом коде):
```dart
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

HvacIconButton(
  icon: Icons.add,
  onPressed: _addItem,
  tooltip: 'Добавить',
  iconSize: 24,
)
```

---

## 🎨 Размеры кнопок

Новая система размеров через enum:

```dart
enum HvacButtonSize {
  small,   // 40px высота, 14px текст
  medium,  // 48px высота, 16px текст (по умолчанию)
  large,   // 56px высота, 18px текст
}
```

**Использование**:
```dart
HvacPrimaryButton(
  label: 'Маленькая',
  onPressed: _action,
  size: HvacButtonSize.small,
)

HvacPrimaryButton(
  label: 'Средняя',
  onPressed: _action,
  size: HvacButtonSize.medium, // default
)

HvacPrimaryButton(
  label: 'Большая',
  onPressed: _action,
  size: HvacButtonSize.large,
)
```

---

## 🎯 Кастомизация

### Цвета

```dart
// Primary button - только градиент (нельзя изменить цвет)
HvacPrimaryButton(...)

// Outline button - можно кастомизировать
HvacOutlineButton(
  label: 'Отмена',
  onPressed: _cancel,
  borderColor: HvacColors.error,     // Красный контур
  textColor: HvacColors.error,       // Красный текст
)

// Text button - можно кастомизировать
HvacTextButton(
  label: 'Удалить',
  onPressed: _delete,
  textColor: HvacColors.error,       // Красный текст
)

// Icon button - можно кастомизировать
HvacIconButton(
  icon: Icons.delete,
  onPressed: _delete,
  iconColor: HvacColors.error,       // Красная иконка
  backgroundColor: HvacColors.errorSubtle, // Фон
)
```

---

## ✨ Новые возможности

### 1. Автоматические hover эффекты для веб

```dart
HvacPrimaryButton(
  label: 'Hover me',
  onPressed: _action,
)
// ✅ Автоматически:
// - Изменение opacity при hover
// - Cursor: pointer
// - Увеличение тени
// - Border анимация (для outline)
```

### 2. Haptic feedback

```dart
HvacPrimaryButton(
  label: 'Touch me',
  onPressed: _action,
  enableHaptic: true, // default
)
// ✅ Автоматически:
// - Вибрация при нажатии
// - Легкая вибрация при hover
```

### 3. Loading states

```dart
HvacPrimaryButton(
  label: 'Загрузка...',
  onPressed: _action,
  isLoading: _isLoading, // Показывает spinner
)
```

### 4. Expanded кнопки

```dart
HvacPrimaryButton(
  label: 'Растянуть',
  onPressed: _action,
  isExpanded: true, // Занимает всю ширину
)
```

---

## 🔍 Где использовать какую кнопку?

### HvacPrimaryButton (Основная)
- ✅ Главное действие на экране
- ✅ Отправка форм (Submit, Login, Save)
- ✅ Подтверждение (Confirm, Apply)
- ✅ Позитивные действия (Create, Add, Start)

**Пример**: Login button, Save settings, Create device

### HvacOutlineButton (Вторичная)
- ✅ Альтернативное действие
- ✅ Отмена (Cancel, Back)
- ✅ Нейтральные действия (Skip, Later)
- ✅ Дополнительные опции

**Пример**: Cancel button, Go back, Skip onboarding

### HvacTextButton (Текстовая)
- ✅ Третичные действия
- ✅ Навигационные ссылки
- ✅ "Learn more", "Forgot password"
- ✅ Неважные действия

**Пример**: Forgot password, Terms of service, Help

### HvacIconButton (Иконочная)
- ✅ Действия с иконками
- ✅ Toolbars и app bars
- ✅ Быстрые действия (Add, Edit, Delete)
- ✅ Компактные интерфейсы

**Пример**: Add button, Menu button, Settings icon

---

## 🚨 Breaking Changes

### 1. Параметр `text` → `label`
```dart
// До
OrangeButton(text: 'Click')

// После
HvacPrimaryButton(label: 'Click')
```

### 2. Цвет кнопок теперь синий (не оранжевый)
```dart
// Автоматически используется HvacColors.accent (#2C7BE5)
// Это корпоративный цвет из новой темы
```

### 3. Высота через enum, а не число
```dart
// До
OutlineButton(height: 48)

// После
HvacOutlineButton(size: HvacButtonSize.medium)
```

### 4. Импорты изменились
```dart
// До
import '../widgets/orange_button.dart';
import '../widgets/outline_button.dart';

// После
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
```

---

## 📋 Чеклист миграции

### Шаг 1: Найти использования старых кнопок
```bash
grep -r "OrangeButton" lib/
grep -r "OutlineButton" lib/
grep -r "GradientButton" lib/
grep -r "AnimatedPrimaryButton" lib/
grep -r "AnimatedOutlineButton" lib/
grep -r "AnimatedTextButton" lib/
```

### Шаг 2: Заменить импорты
```dart
// Удалить
import '../widgets/orange_button.dart';
import '../widgets/outline_button.dart';
import '../widgets/gradient_button.dart';
import '../widgets/common/buttons/animated_primary_button.dart';
import '../widgets/common/buttons/animated_outline_button.dart';

// Добавить
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
```

### Шаг 3: Заменить использования
- [ ] `OrangeButton` → `HvacPrimaryButton`
- [ ] `GradientButton` → `HvacPrimaryButton`
- [ ] `AnimatedPrimaryButton` → `HvacPrimaryButton`
- [ ] `OutlineButton` → `HvacOutlineButton`
- [ ] `AnimatedOutlineButton` → `HvacOutlineButton`
- [ ] `AnimatedTextButton` → `HvacTextButton`

### Шаг 4: Обновить параметры
- [ ] `text` → `label`
- [ ] `height: X` → `size: HvacButtonSize.Y`
- [ ] Проверить `isExpanded`, `isLoading`, `icon`

### Шаг 5: Протестировать
- [ ] Компиляция без ошибок
- [ ] Визуальная проверка всех экранов
- [ ] Проверка hover эффектов (web)
- [ ] Проверка haptic feedback (mobile)

### Шаг 6: Удалить старые файлы (опционально)
```bash
# После полной миграции можно удалить:
rm lib/presentation/widgets/orange_button.dart
rm lib/presentation/widgets/outline_button.dart
rm lib/presentation/widgets/gradient_button.dart
rm -rf lib/presentation/widgets/common/buttons/
```

---

## 🎯 Быстрый поиск и замена

### Regex для поиска (VS Code)

**Найти**: `OrangeButton\(\s*text:\s*`
**Заменить**: `HvacPrimaryButton(label: `

**Найти**: `OutlineButton\(\s*text:\s*`
**Заменить**: `HvacOutlineButton(label: `

**Найти**: `GradientButton\(\s*text:\s*`
**Заменить**: `HvacPrimaryButton(label: `

**Найти**: `AnimatedPrimaryButton\(\s*label:\s*`
**Заменить**: `HvacPrimaryButton(label: `

---

## 📊 Статистика миграции

### Было (в основном приложении)
```
lib/presentation/widgets/
├── orange_button.dart           79 строк  ❌
├── outline_button.dart          89 строк  ❌
├── gradient_button.dart         78 строк  ❌
└── common/buttons/
    ├── animated_primary_button.dart   210 строк  ❌
    ├── animated_outline_button.dart   199 строк  ❌
    ├── animated_text_button.dart      ~150 строк ❌
    └── base_animated_button.dart      ~100 строк ❌

Итого: ~905 строк разрозненного кода
```

### Стало (в UI kit)
```
hvac_ui_kit/lib/src/widgets/buttons/
├── hvac_primary_button.dart     268 строк  ✅
├── hvac_outline_button.dart     203 строк  ✅
├── hvac_text_button.dart        284 строк  ✅
└── buttons.dart                 8 строк    ✅

Итого: 763 строки чистого кода
```

### Выигрыш
- ✅ Уменьшение кода на ~140 строк (убрана дублирование)
- ✅ Единый API для всех кнопок
- ✅ Единый источник истины (Single Source of Truth)
- ✅ Легче поддерживать и тестировать

---

## 🔮 Что дальше?

### Следующий этап миграции: States (Empty, Error, Loading)

После миграции кнопок, следующие компоненты:
1. EmptyState → HvacEmptyState
2. ErrorState → HvacErrorState
3. LoadingWidget → HvacLoadingState

См. `ARCHITECTURE_MIGRATION_PLAN.md` для полного roadmap.

---

## ❓ FAQ

### В: Можно ли использовать оранжевый цвет?
**О**: Нет, новая корпоративная тема использует только синий. Если нужен другой цвет для особых случаев (например, ошибка), используйте:
```dart
HvacOutlineButton(
  label: 'Удалить',
  borderColor: HvacColors.error,
  textColor: HvacColors.error,
)
```

### В: Как сделать кнопку disabled?
**О**: Просто передайте `null` в `onPressed`:
```dart
HvacPrimaryButton(
  label: 'Отправить',
  onPressed: isValid ? _submit : null, // null = disabled
)
```

### В: Работают ли эти кнопки на мобильных?
**О**: Да, кнопки адаптивные:
- 📱 Mobile: Haptic feedback, touch-friendly размеры
- 🖥️ Web: Hover effects, cursor management
- 💻 Desktop: Keyboard navigation (будет добавлено)

### В: Можно ли отключить haptic feedback?
**О**: Да:
```dart
HvacPrimaryButton(
  label: 'Silent',
  onPressed: _action,
  enableHaptic: false,
)
```

### В: Как добавить свою кастомную кнопку?
**О**: Лучше использовать существующие компоненты с кастомизацией:
```dart
HvacOutlineButton(
  label: 'Custom',
  borderColor: Color(0xFFFF00FF),
  textColor: Color(0xFFFF00FF),
)
```

Если действительно нужна уникальная кнопка, создайте в UI kit и предложите PR.

---

## ✅ Критерии успеха миграции

- [ ] Все старые импорты заменены на `hvac_ui_kit`
- [ ] Все `text` параметры заменены на `label`
- [ ] Все кнопки используют новые компоненты
- [ ] `dart analyze` без ошибок
- [ ] Приложение компилируется
- [ ] Все экраны визуально корректны
- [ ] Hover эффекты работают на web
- [ ] Haptic feedback работает на mobile

---

## 📞 Помощь и поддержка

При возникновении проблем:
1. Проверьте этот гайд
2. Смотрите примеры в `hvac_ui_kit/lib/src/widgets/buttons/`
3. Откройте issue в репозитории

---

*Создано с помощью [Claude Code](https://claude.com/claude-code)*
*Co-Authored-By: Claude <noreply@anthropic.com>*
