# BREEZ Home UI/UX Improvement Plan
## "What Would Steve Say?" Edition

> "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

---

## PHASE 1: КРИТИЧЕСКИЕ - Архитектура информации ✅

### 1.1 Устранить дублирование
- [x] **P1-1**: Убрать дублирование "ZILON ZPE-6000" → DeviceHeaderCard теперь только power toggle
- [x] **P1-2**: Объединить уведомления → только NotificationCenterCard в Global Zone
- [x] **P1-3**: Убрать "ОБЩИЕ ДАННЫЕ" label → заменён на spacing

### 1.2 Создать визуальную иерархию
- [x] **P1-4**: PRIMARY action = большая кнопка питания в центре DeviceHeaderCard
- [x] **P1-5**: Сгруппировать элементы → EnvironmentCard (Temp+Humidity+CO2)
- [x] **P1-6**: Device/Global Zone → DeviceZoneContainer визуально выделяет зону

---

## PHASE 2: ТИПОГРАФИКА - Читаемость и консистентность ✅

### 2.1 Исправить обрезанный текст
- [x] **P2-1**: "Статистика использ..." → сокращено до "Энергия"
- [x] **P2-2**: "Охлажден..." → mode buttons теперь только иконки + Tooltip
- [x] **P2-3**: Аудит всех текстов на overflow/ellipsis → добавлен maxLines где нужно

### 2.2 Унифицировать числа и единицы
- [x] **P2-4**: Температура: всегда целые (22°)
- [x] **P2-5**: Единицы: температура °, влажность %, CO2 ppm, энергия кВт⋅ч
- [x] **P2-6**: Создать Typography Scale → lib/core/theme/typography.dart

---

## PHASE 3: ЦВЕТ И ВИЗУАЛ - Система, не хаос ✅

### 3.1 Цветовая система
- [x] **P3-1**: Semantic colors: success/warning/error/info - определены
- [x] **P3-2**: Palette упрощена: удалены airExcellent/airModerate/airPoor → используются status colors
- [x] **P3-3**: GlowingStatusDot - уменьшена яркость (alpha 0.6→0.3, spread 0.3→0.1)
- [x] **P3-4**: Badge colors - alerts badge изменён с destructive на warning

### 3.2 Визуальная консистентность
- [x] **P3-5**: CO₂ gauge - редизайн: icon + value + unit (как _MetricItem)
- [x] **P3-6**: Border radius scale добавлен в AppSpacing (xs/sm/md/lg/xl)
- [x] **P3-7**: Temperature dial - упрощён: убран gradient, чистый solid color

---

## PHASE 4: UX - Понятность без инструкций

### 4.1 Добавить контекст
- [x] **P4-1**: Toggle - DeviceHeaderCard показывает статус (Активно/Ожидание/Офлайн)
- [x] **P4-2**: Quick actions - уже имеют labels под иконками
- [x] **P4-3**: Слайдеры - добавлены метки Мин/Норма/Макс с подсветкой нормы
- [x] **P4-4**: Air quality - цветовая индикация + badge (Отлично/Хорошо/Умеренно/Плохо)

### 4.2 Убрать пустоту
- [x] **P4-5**: Расписание - UnifiedScheduleCard показывает device + global schedules
- [x] **P4-6**: Empty states - уже реализованы во всех карточках

---

## PHASE 5: LAYOUT & SPACING - Сетка и ритм ✅

### 5.1 Grid система
- [x] **P5-1**: 8px grid - AppSpacing в lib/core/theme/spacing.dart
- [x] **P5-2**: Карточки используют ShadCard с консистентным стилем
- [x] **P5-3**: Gaps: xs=8, sm=12, md=16, lg=24 - определены в AppSpacing

### 5.2 Карточки
- [x] **P5-4**: Card padding: sm=16, md=24, lg=32 - в AppSpacing
- [x] **P5-5**: ShadCard обеспечивает стандартный стиль

---

## PHASE 6: FOOTER & CHROME - Убрать шум ✅

### 6.1 Footer cleanup
- [x] **P6-1**: Погода - оставлена как единственный элемент (контекст для HVAC)
- [x] **P6-2**: Синхронизация - удалена (шум)
- [x] **P6-3**: Версия - удалена (перенести в Settings)

### 6.2 Header/Sidebar polish
- [x] **P6-4**: Аватар - улучшен: gradient, shadow, larger size (36px)
- [x] **P6-5**: Sidebar hover states - добавлен явный hoverColor
- [x] **P6-6**: Active state - левый индикатор + bold text + primary background

---

## PHASE 7: POLISH & DETAILS - Финальный блеск ✅

### 7.1 Micro-interactions
- [x] **P7-1**: Hover states - InkWell + hoverColor в sidebar и карточках
- [x] **P7-2**: Transitions - AnimatedContainer 200ms везде
- [x] **P7-3**: Loading states - ShadProgress для dashboard loading

### 7.2 Accessibility
- [x] **P7-4**: Contrast - warning color изменён на amber-600 (#D97706) для WCAG AA
- [x] **P7-5**: Focus states - все ключевые элементы (nav, mode buttons, tabs, quick actions)
- [x] **P7-6**: Touch targets - кнопки 64x64 (power), иконки 44x44

---

## ПРИНЦИПЫ (проверять каждое решение)

1. **Иерархия**: Что самое важное? Это видно сразу?
2. **Простота**: Можно ли убрать? Если да - убрать.
3. **Консистентность**: Похожие вещи выглядят одинаково?
4. **Контекст**: Пользователь понимает что это без объяснений?
5. **Эмоция**: Приятно ли пользоваться? Хочется ли вернуться?

---

## PROGRESS TRACKING

Started: 2025-12-23
Current Phase: ✅ ALL PHASES COMPLETE
Completed: 42/42 (100%)

---

## STEVE'S VOICE (напоминание)

> "Simple can be harder than complex. You have to work hard to get your thinking clean to make it simple."

> "People don't know what they want until you show it to them."

> "Details matter, it's worth waiting to get it right."
