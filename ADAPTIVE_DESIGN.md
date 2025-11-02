# Адаптивный дизайн - Big-Tech подход

## 🏢 Применённые практики

Наша адаптивная система вдохновлена лучшими практиками:
- **Google Material Design 3** - Breakpoints и адаптивные компоненты
- **Airbnb** - LayoutBuilder + контекстная адаптация
- **Apple HIG** - Минимальные сенсорные цели (48dp)
- **Netflix** - Constraint-based layouts

---

## 📐 Breakpoints (Material Design 3)

### Compact (< 600dp)
- **Устройства**: Смартфоны
- **Базовый размер**: 375x812 (iPhone X)
- **Layout**: Single column
- **Слайдеры**: Вертикальная раскладка
- **Touch targets**: 48dp минимум

### Medium (600-840dp)
- **Устройства**: Планшеты, складные устройства
- **Базовый размер**: 768x1024 (iPad)
- **Layout**: Two columns / Grid
- **Слайдеры**: Горизонтальная раскладка
- **Touch targets**: 56dp

### Expanded (> 840dp)
- **Устройства**: Десктопы, большие планшеты
- **Базовый размер**: 1920x1080 (Full HD)
- **Layout**: Multi-column / Grid
- **Слайдеры**: Горизонтальная раскладка + метки
- **Touch targets**: 64dp

---

## 🎨 Использование

### 1. AdaptiveLayout - Утилиты

```dart
// Адаптивный padding
padding: AdaptiveLayout.controlPadding(context)

// Адаптивный размер иконки
size: AdaptiveLayout.iconSize(context, base: 20)

// Адаптивный размер шрифта
fontSize: AdaptiveLayout.fontSize(context, base: 14)

// Адаптивное расстояние
spacing: AdaptiveLayout.spacing(context, base: 12)

// Проверка размера устройства
if (AdaptiveLayout.useSingleColumn(context)) {
  // Mobile layout
}
```

### 2. AdaptiveControl - Wrapper

```dart
AdaptiveControl(
  builder: (context, deviceSize) {
    return Container(
      // Виджет автоматически адаптируется
    );
  },
)
```

### 3. AdaptiveSlider - Слайдер

```dart
AdaptiveSlider(
  label: 'Приточный вентилятор',
  icon: Icons.air,
  value: speed,
  max: 100,
  onChanged: (value) => setState(() => speed = value),
  color: AppTheme.info,
)
```

**Автоматически:**
- Минимальная высота touch target
- Размер thumb зависит от устройства
- Метки на планшете/десктопе
- Правильные отступы

---

## 🔧 Динамический ScreenUtil

**main.dart:**
```dart
ScreenUtilInit(
  designSize: _getDesignSize(context),
  // Автоматически выбирает базовый размер:
  // - Mobile: 375x812
  // - Tablet: 768x1024
  // - Desktop: 1920x1080
)
```

---

## 📱 Адаптивные виджеты

### VentilationTemperatureControl
- **Mobile**: Column layout (4 индикатора друг под другом)
- **Tablet**: Wrap grid 2x2
- **Desktop**: Wrap grid 2x2 с большими отступами

### VentilationModeControl
- **Mobile**: Вертикальные слайдеры
- **Tablet/Desktop**: Горизонтальные слайдеры side-by-side

---

## ✅ Преимущества

1. **Универсальность** - Работает на всех устройствах
2. **Accessibility** - Соответствует WCAG 2.1 (touch targets)
3. **Performance** - LayoutBuilder вычисляется один раз
4. **Maintainability** - Один виджет для всех экранов
5. **UX** - Оптимизированный layout для каждого устройства

---

## 🎯 Best Practices

### DO ✅

```dart
// Используйте AdaptiveLayout
fontSize: AdaptiveLayout.fontSize(context, base: 14)

// Используйте AdaptiveControl для сложных виджетов
AdaptiveControl(builder: (context, size) => ...)

// Разные layout для разных размеров
if (deviceSize == DeviceSize.compact) {
  return Column(...);
} else {
  return Row(...);
}
```

### DON'T ❌

```dart
// Хардкод размеров
fontSize: 14

// Один layout для всех
return Column(...); // На десктопе будет плохо

// Игнорирование touch targets
SizedBox(height: 20) // Слишком маленькое для кнопки
```

---

## 🚀 Расширение системы

Для добавления новых адаптивных виджетов:

1. Используйте `AdaptiveControl` wrapper
2. Получайте `deviceSize` из builder
3. Применяйте `AdaptiveLayout` утилиты
4. Создавайте разные layouts для разных размеров

```dart
class MyAdaptiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        // Ваш адаптивный код
        return Container(
          padding: AdaptiveLayout.controlPadding(context),
          child: deviceSize == DeviceSize.compact
            ? _buildMobileLayout()
            : _buildDesktopLayout(),
        );
      },
    );
  }
}
```

---

## 📊 Результаты

- ✅ Полностью адаптивные контролы
- ✅ Оптимизированные touch targets
- ✅ Правильная типографика на всех экранах
- ✅ Material Design 3 compliance
- ✅ Big-tech уровень качества
