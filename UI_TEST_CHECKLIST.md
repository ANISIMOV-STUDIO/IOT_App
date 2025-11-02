# UI Testing Checklist - IOT App

## Mobile (< 600dp width)

### Home Screen - Room Preview Card
- [ ] Высота карты 160-180px (не больше)
- [ ] Название комнаты центрировано вертикально
- [ ] Тумблер питания компактный ("Вкл"/"Выкл")
- [ ] Статус бейджи под тумблером (top: 50.h), не перекрываются
- [ ] Бейджи компактные: padding 6w/4h, иконки 12sp, текст 11sp
- [ ] Кнопка "Подробнее" внизу справа
- [ ] Градиентный фон отображается корректно

### Home Screen - App Bar
- [ ] Logo сверху слева
- [ ] Настройки и профиль сверху справа
- [ ] Табы устройств под логотипом (вторая строка)
- [ ] Кнопка "+" для добавления устройства видна
- [ ] Табы прокручиваются горизонтально если много

### Home Screen - Control Cards
- [ ] Три карточки расположены вертикально (Column)
- [ ] Порядок: Режим работы → Температуры → Расписание
- [ ] Spacing между карточками: 16.h
- [ ] Все карточки одинаковой ширины (full width)

### Режим работы (VentilationModeControl)
- [ ] Padding карточки: 16 (AdaptiveLayout.controlPadding)
- [ ] Иконка tune в оранжевом бадже
- [ ] Spacing между секциями: 12.h
- [ ] Селектор режима: компактный, текст не обрезается
- [ ] Два слайдера вертикально (Column)
- [ ] Слайдеры: label + иконка + значок + слайдер
- [ ] Высота слайдера: 48.h (touch target)
- [ ] Spacing между слайдерами: 12.h
- [ ] Текст "Приточный вентилятор" не обрезается
- [ ] Текст "Вытяжной вентилятор" не обрезается

### Температуры (VentilationTemperatureControl)
- [ ] Padding карточки: 16
- [ ] Иконка thermostat в синем бадже
- [ ] Spacing между секциями: 12.h (было 20)
- [ ] Четыре индикатора температуры вертикально (Column)
- [ ] Spacing между индикаторами: 8.h
- [ ] Каждый индикатор: padding 10, иконка 14sp, temp 20sp
- [ ] Названия не обрезаются: "Приток", "Вытяжка", "Наружный", "Внутренний"
- [ ] Температуры отображаются с одним знаком после запятой

### Расписание (VentilationScheduleControl)
- [ ] Padding карточки: 16
- [ ] Иконка schedule в зеленом бадже
- [ ] Spacing между секциями: 12.h
- [ ] День недели и статус в одной строке, не перекрываются
- [ ] Время включения/выключения в Row, не обрезаются
- [ ] Два стата "Статус" и "Время работы" в Row
- [ ] Кнопка "Настроить расписание": padding vertical 10.h, текст не обрезается
- [ ] Нет Spacer (только на desktop)

### Automation Section
- [ ] Заголовок "Автоматизации" виден
- [ ] Карточки правил вертикально
- [ ] Кнопка "Управление правилами" видна

---

## Tablet (600-840dp width)

### Home Screen Layout
- [ ] App bar в одну линию: logo - tabs - settings/profile
- [ ] Room preview card: высота 300-400px
- [ ] Control cards горизонтально (Row) с фиксированной высотой 280px
- [ ] Все три карточки равной высоты
- [ ] Spacing между карточками: 16.w

### Control Cards - Tablet Specific
- [ ] VentilationModeControl: два слайдера горизонтально (Row)
- [ ] VentilationModeControl: есть Spacer внизу для выравнивания
- [ ] VentilationTemperatureControl: 2x2 grid (Wrap)
- [ ] VentilationTemperatureControl: есть Spacer внизу
- [ ] VentilationScheduleControl: все секции + Spacer внизу
- [ ] Все карточки одинаковой высоты визуально

### Sliders - Tablet
- [ ] Высота слайдера: 56.h (больше touch target)
- [ ] Тик-марки (0-25-50-75-100) под слайдером видны
- [ ] Слайдер thumb размер увеличен

---

## Desktop (> 840dp width)

### Home Screen Layout
- [ ] App bar в одну линию
- [ ] Sidebar справа (HomeSidebar) с пресетами и уведомлениями
- [ ] Main content занимает 7/10 ширины
- [ ] Sidebar занимает 3/10 ширины
- [ ] Room preview card: высота 300-400px
- [ ] Control cards: Row с фиксированной высотой 280px

### Control Cards - Desktop Specific
- [ ] Все три карточки строго одинаковой высоты (280px)
- [ ] VentilationModeControl: слайдеры с короткими названиями ("Приточный", "Вытяжной")
- [ ] VentilationTemperatureControl: 2x2 grid с фиксированной шириной ~180.w
- [ ] VentilationScheduleControl: все элементы + Spacer
- [ ] Визуально все карточки выглядят сбалансированно

### Sliders - Desktop
- [ ] Высота слайдера: 64.h (максимальный touch target)
- [ ] Тик-марки видны
- [ ] Анимация при hover работает

### Sidebar
- [ ] Пресеты отображаются корректно
- [ ] Кнопки "Все вкл/выкл" работают
- [ ] Notifications panel внизу

---

## Общие проверки (все разрешения)

### Overflow Errors
- [ ] Нет ошибок "RenderFlex overflowed" в консоли
- [ ] Все тексты с Flexible/Expanded где нужно
- [ ] Все иконки с текстом имеют SizedBox между ними

### Touch Targets
- [ ] Все кнопки минимум 48x48 на mobile
- [ ] Слайдеры минимум 48h на mobile, 64h на desktop
- [ ] Switch в тумблере достаточно большой

### Typography
- [ ] Все шрифты адаптивные (AdaptiveLayout.fontSize)
- [ ] Иерархия шрифтов: заголовки 16sp, подзаголовки 12sp, body 14sp
- [ ] Все тексты читаемые на темном фоне

### Colors
- [ ] Primary orange: #FF9D5C
- [ ] Background dark: правильный темный цвет
- [ ] Card background: контрастирует с фоном
- [ ] Text colors: primary (светлый), secondary (серый)
- [ ] Status colors: success (green), error (red), info (blue), warning (orange)

### Spacing Consistency
- [ ] Mobile: 12.h между элементами внутри карточек
- [ ] Desktop: 16 между элементами внутри карточек
- [ ] 16.h/w между карточками
- [ ] 20.w padding экрана по краям

### Animations
- [ ] Fade in анимации работают плавно
- [ ] Slide анимации не дергаются
- [ ] Переключение между устройствами плавное

---

## Тестовые сценарии

1. **Resize test**: Измените размер окна браузера/эмулятора от 375px до 1920px
   - [ ] Все элементы адаптируются без overflow
   - [ ] Переходы между breakpoints плавные
   - [ ] Ничего не "прыгает"

2. **Rotation test** (mobile): Поверните устройство
   - [ ] Portrait: все вертикально
   - [ ] Landscape: все адаптируется

3. **Long text test**: Добавьте устройство с очень длинным названием
   - [ ] Название обрезается с ellipsis
   - [ ] Не ломает layout

4. **No data test**: Отключите все устройства
   - [ ] Empty state отображается
   - [ ] Нет ошибок

5. **Scroll test**: Добавьте много устройств
   - [ ] Табы прокручиваются
   - [ ] Контент прокручивается
   - [ ] Нет performance issues

---

## Как тестировать

### Flutter Web (Chrome DevTools)
```bash
flutter run -d chrome
```
Затем в Chrome DevTools:
- Toggle device toolbar (Ctrl+Shift+M)
- Выберите: iPhone SE, iPhone 12 Pro, iPad, Desktop

### Flutter Emulator
```bash
# Android
flutter emulators
flutter emulators --launch <emulator_id>
flutter run

# iOS (только на Mac)
open -a Simulator
flutter run
```

### Горячая перезагрузка
При изменении кода нажмите `r` в терминале для hot reload

---

## Известные проблемы для проверки

1. ❓ ScreenUtilInit с ValueKey правильно реагирует на resize?
2. ❓ Spacer в control cards не вызывает mouse tracker assertions?
3. ❓ Все Flexible обертки на месте для длинных текстов?
4. ❓ Status badges на мобиле не перекрываются при 4+ бейджах?
5. ❓ AdaptiveSlider tick marks отображаются только на tablet/desktop?

---

## После тестирования

Если найдете проблемы, сделайте скриншоты:
1. Покажите мне скриншот проблемы
2. Укажите разрешение экрана (напр. "375x812 mobile")
3. Опишите что не так

Я смогу быстро исправить на основе визуальной информации!
