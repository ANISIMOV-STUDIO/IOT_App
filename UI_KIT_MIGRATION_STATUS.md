# Статус миграции на HVAC UI Kit

**Дата проверки:** 2025-11-09
**Проверено файлов:** 216 в `lib/presentation/`

---

## 📊 Общая статистика

| Метрика | Значение | Статус |
|---------|----------|--------|
| **Используют UI Kit** | 200 файлов | ✅ 93% |
| **Только Material** | 16 файлов | ⚠️ 7% |
| **Хардкодных цветов** | 594 вхождения | ❌ Требует внимания |
| **Миграция завершена** | Частично | ⚠️ 85% |

---

## ✅ Что мигрировано

### Успешно используют UI Kit (200 файлов)

**Основные экраны:**
- ✅ Dashboard/Home screens (refactored versions)
- ✅ Settings screens (refactored)
- ✅ Auth/Login screens (refactored)
- ✅ Schedule screens (refactored)
- ✅ Device management screens
- ✅ Onboarding screens

**Компоненты:**
- ✅ HVAC cards
- ✅ Dashboard widgets
- ✅ Device cards
- ✅ Temperature controls
- ✅ Schedule cards
- ✅ Navigation components
- ✅ Form inputs (refactored versions)

---

## ⚠️ Требуют миграции (16 файлов)

### Категория 1: НУЖНА МИГРАЦИЯ (6 файлов)

Эти файлы содержат UI компоненты и должны использовать UI Kit:

1. **lib/presentation/pages/responsive_shell.dart**
   - Использует: `Scaffold` напрямую
   - Рекомендация: Использовать `HvacScaffold` или обернуть в UI Kit layout

2. **lib/presentation/pages/room_detail/room_detail_content.dart**
   - Использует: стандартные `Padding`, `Column`, `Row`
   - Рекомендация: Использовать `HvacCard`, `HvacSpacing` константы

3. **lib/presentation/widgets/auth/responsive_utils.dart**
   - Содержит: utility функции для responsive
   - Рекомендация: Использовать `responsive` из UI Kit

4. **lib/presentation/widgets/qr_scanner/qr_scanner_responsive.dart**
   - Содержит: responsive логику
   - Рекомендация: Мигрировать на `responsive` из UI Kit

5. **lib/presentation/widgets/qr_scanner/scanner_corner_marker.dart**
   - Содержит: кастомный виджет с `CustomPaint`
   - Рекомендация: Проверить, есть ли в UI Kit, если нет - оставить как есть

6. **lib/presentation/widgets/schedule/schedule_state_manager.dart**
   - Содержит: state management логику
   - Рекомендация: Проверить использование UI Kit паттернов

### Категория 2: ЛОГИКА (UI Kit не нужен) (8 файлов)

Эти файлы содержат только бизнес-логику, Material import используется для типов:

- ✅ `lib/presentation/bloc/hvac_detail/hvac_detail_bloc.dart` (BLoC)
- ✅ `lib/presentation/pages/home/home_screen_logic.dart` (логика)
- ✅ `lib/presentation/pages/home_screen_logic.dart` (логика)
- ✅ `lib/presentation/pages/schedule/schedule_logic.dart` (логика)
- ✅ `lib/presentation/widgets/common/snackbar/snackbar_types.dart` (типы)
- ✅ `lib/presentation/widgets/home/notifications/notification_grouper.dart` (логика)
- ✅ `lib/presentation/widgets/optimized/list/lazy_list_controller.dart` (контроллер)
- ✅ `lib/presentation/widgets/optimized/list/virtual_scroll_controller.dart` (контроллер)

### Категория 3: УТИЛИТЫ (UI Kit не нужен) (2 файла)

Низкоуровневые утилиты:

- ✅ `lib/presentation/widgets/utils/performance_monitor.dart` (мониторинг)
- ✅ `lib/presentation/widgets/utils/ripple_painter.dart` (кастомный painter)

---

## ❌ Проблемы

### 1. Хардкодные цвета (594 вхождения в 100 файлах)

**Примеры файлов с хардкодными цветами:**

Top 10 файлов с наибольшим количеством:
1. `lib/presentation/widgets/ventilation_temperature_control.dart` - 15 цветов
2. `lib/presentation/widgets/group_control_panel.dart` - 15 цветов
3. `lib/presentation/widgets/home/tablet_presets_panel.dart` - 15 цветов
4. `lib/presentation/widgets/automation_panel.dart` - 14 энергии
5. `lib/presentation/widgets/energy_chart.dart` - 14 цветов
6. `lib/presentation/widgets/schedule/day_schedule_card.dart` - 14 цветов
7. `lib/presentation/widgets/home/home_app_bar.dart` - 14 цветов
8. `lib/presentation/widgets/temperature_chart.dart` - 13 цветов
9. `lib/presentation/widgets/air_quality_indicator.dart` - 12 цветов
10. `lib/presentation/widgets/auth/password_strength_indicator.dart` - 12 цветов

**Рекомендации:**
- Заменить `Color(0xFF...)` на `HvacColors.*`
- Заменить `Colors.*` на `HvacColors.*`
- Использовать theme-aware цвета из UI Kit

### 2. Смешанное использование (157 файлов)

157 файлов используют ОДНОВРЕМЕННО:
- Стандартные виджеты (`Container`, `Text`, `Card`)
- UI Kit компоненты (`HvacCard`, `HvacColors`)

**Проблема:** Непоследовательный дизайн, сложность поддержки

**Решение:**
1. Заменить стандартные виджеты на UI Kit аналоги где возможно
2. Для базовых виджетов (`Container`, `Column`, `Row`) - допустимо
3. Но использовать `HvacColors`, `HvacTypography`, `HvacSpacing`

---

## 📋 План действий

### Приоритет 1: Критичные (немедленно)

- [ ] **Хардкодные цвета** - создать скрипт для автозамены
  ```bash
  # Пример замены:
  Color(0xFF6C63FF) → HvacColors.primary
  Colors.white → HvacColors.white
  ```

### Приоритет 2: Высокий (на этой неделе)

- [ ] **responsive_shell.dart** - использовать HvacScaffold
- [ ] **room_detail_content.dart** - использовать HvacCard, HvacSpacing
- [ ] **responsive_utils.dart** - мигрировать на `responsive` из UI Kit
- [ ] **qr_scanner_responsive.dart** - мигрировать на `responsive` из UI Kit

### Приоритет 3: Средний (по возможности)

- [ ] **scanner_corner_marker.dart** - проверить наличие в UI Kit
- [ ] **schedule_state_manager.dart** - провести рефакторинг
- [ ] Убрать смешанное использование в топ-20 файлах

### Приоритет 4: Низкий (опционально)

- [ ] Оптимизация импортов
- [ ] Документация использования UI Kit
- [ ] Линтер правила для проверки UI Kit usage

---

## 🎯 Рекомендации

### Для новых компонентов

```dart
// ❌ НЕ ДЕЛАТЬ ТАК:
Container(
  color: Color(0xFF6C63FF),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16, color: Colors.white),
  ),
)

// ✅ ДЕЛАТЬ ТАК:
HvacCard(
  backgroundColor: HvacColors.primary,
  child: Text(
    'Hello',
    style: HvacTypography.bodyMedium.copyWith(
      color: HvacColors.white,
    ),
  ),
)
```

### Для существующих компонентов

1. Импортировать UI Kit:
   ```dart
   import 'package:hvac_ui_kit/hvac_ui_kit.dart';
   ```

2. Заменить цвета:
   ```dart
   // Было:
   color: Color(0xFF6C63FF)

   // Стало:
   color: HvacColors.primary
   ```

3. Заменить типографику:
   ```dart
   // Было:
   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)

   // Стало:
   style: HvacTypography.bodyMedium
   ```

4. Использовать spacing:
   ```dart
   // Было:
   SizedBox(height: 16)

   // Стало:
   SizedBox(height: HvacSpacing.md) // or use responsive spacing
   ```

---

## 📈 Прогресс миграции

```
Миграция UI Kit: [███████████████████░░] 85%

✅ Импорты UI Kit:      200/216 (93%)
⚠️  Цвета:             122/216 (56%) - нужна замена хардкода
⚠️  Виджеты:           166/216 (77%)
✅ Логика (не требует): 10/216  (5%)
```

---

## 🔍 Как проверить

Запустите валидацию:

```bash
# Найти файлы без UI Kit
grep -r "import 'package:flutter/material.dart'" lib/presentation/ \
  | grep -v "hvac_ui_kit" \
  | cut -d: -f1 \
  | sort -u

# Найти хардкодные цвета
grep -r "Color(0x\|Colors\." lib/presentation/ --include="*.dart"

# Найти использование стандартных виджетов
grep -r "ElevatedButton\|TextButton\|Card(" lib/presentation/ --include="*.dart"
```

---

## ✅ Выводы

**Положительное:**
- 93% файлов импортируют UI Kit
- Основные экраны мигрированы
- Refactored версии используют UI Kit

**Требует внимания:**
- 594 хардкодных цвета в 100 файлах
- 157 файлов смешивают UI Kit и стандартные виджеты
- 6 файлов требуют полной миграции

**Общая оценка:** ⭐⭐⭐⭐☆ (4/5)
- Миграция выполнена на 85%
- Основная архитектура на UI Kit
- Требуется очистка хардкодных значений

---

**Следующий шаг:** Создать скрипт автозамены хардкодных цветов на `HvacColors`
