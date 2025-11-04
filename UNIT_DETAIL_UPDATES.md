# Unit Detail Screen - Обновления

## Обзор изменений

Unit Detail Screen был обновлен с использованием новых компонентов из hvac_ui_kit для улучшения пользовательского интерфейса и добавления анимаций.

## Добавленные компоненты

### 1. Hero Анимации
- **HvacIconHero** - анимация иконки устройства (вкл/выкл)
- **HvacStatusHero** - анимация названия устройства
- **HvacTemperatureHero** - анимация температуры с главного экрана

```dart
HvacTemperatureHero(
  tag: 'unit_temp_${unit.id}',
  temperature: '$temp°C',
  style: TextStyle(fontSize: 52.sp, fontWeight: FontWeight.w700),
)
```

### 2. График температуры (HvacAnimatedLineChart)
- Отображает температуру за последние 24 часа
- Использует fl_chart для плавной анимации
- Градиентная заливка под графиком

```dart
HvacAnimatedLineChart(
  spots: _generateTemperatureData(),
  lineColor: HvacColors.primaryOrange,
  gradientStartColor: HvacColors.primaryOrange,
  gradientEndColor: HvacColors.info,
  showDots: false,
  showGrid: true,
)
```

### 3. HvacGradientBorder
- Контейнер с градиентной рамкой для температурной карточки
- Использует фирменные цвета (оранжевый -> синий)

```dart
HvacGradientBorder(
  gradientColors: [HvacColors.primaryOrange, HvacColors.info],
  borderWidth: 3,
  child: Container(/* ... */),
)
```

### 4. HvacNeumorphicButton
- Кнопки управления с эффектом neumorphic дизайна
- Анимация нажатия с изменением теней
- Используется для кнопок "Включить/Выключить" и "Режим"

```dart
HvacNeumorphicButton(
  onPressed: () { /* ... */ },
  child: Row(
    children: [
      Icon(Icons.power_settings_new),
      Text('Включить'),
    ],
  ),
)
```

### 5. HvacInteractiveScale
- Оборачивает кнопки для добавления scale анимации при нажатии
- Масштабирование до 0.95 при нажатии

```dart
HvacInteractiveScale(
  onTap: () { /* ... */ },
  child: HvacNeumorphicButton(/* ... */),
)
```

### 6. HvacRefreshIndicator
- Добавлен pull-to-refresh для обновления данных устройства
- Работает как на mobile, так и на tablet layouts
- Фирменный стиль с оранжевым индикатором

```dart
HvacRefreshIndicator(
  onRefresh: _refreshData,
  child: TabBarView(/* ... */),
)
```

### 7. HvacPulsingDot
- Пульсирующий индикатор онлайн-статуса
- Отображается когда устройство включено
- Зеленый цвет для активного статуса

```dart
HvacPulsingDot(
  color: HvacColors.success,
  size: 8,
)
```

## Структура изменений

### unit_detail_screen.dart
1. Добавлены импорты:
   - `import 'package:fl_chart/fl_chart.dart';`
   - `import '../../domain/entities/ventilation_mode.dart';`

2. Добавлены методы:
   - `_generateTemperatureData()` - генерация моковых данных
   - `_refreshData()` - обновление данных устройства

3. Обновлены layouts:
   - Mobile: добавлен HvacRefreshIndicator
   - Tablet: добавлен HvacRefreshIndicator с SingleChildScrollView

4. Обновлен AppBar:
   - Hero анимации для иконки и названия
   - HvacPulsingDot для онлайн статуса

### overview_tab.dart
1. Добавлены импорты:
   - `import 'package:fl_chart/fl_chart.dart';`

2. Новые секции:
   - **_buildHeroTemperatureCard()** - большая карточка температуры с градиентной рамкой
   - **_buildTemperatureChart()** - график температуры за 24 часа
   - **_buildControlButtons()** - neumorphic кнопки управления

3. Обновленные секции:
   - **_buildStatusCard()** - добавлен HvacPulsingDot и "ONLINE" статус

## Hero Tags

Для правильной работы Hero анимаций используются следующие теги:

- `'unit_icon_${unit.id}'` - иконка устройства
- `'unit_name_${unit.id}'` - название устройства
- `'unit_temp_${unit.id}'` - температура

**Важно:** Убедитесь, что home screen использует те же теги для соответствующих элементов.

## Моковые данные

График температуры использует сгенерированные данные с небольшими вариациями:

```dart
List<FlSpot> _generateTemperatureData() {
  final baseTemp = unit.supplyAirTemp ?? 22.0;
  final spots = <FlSpot>[];

  for (int i = 0; i < 24; i++) {
    final variance = (i % 3) * 0.8 - 0.4;
    spots.add(FlSpot(i.toDouble(), baseTemp + variance));
  }

  return spots;
}
```

## TODO

- [ ] Подключить реальные данные температуры из API
- [ ] Реализовать функционал кнопок управления (вкл/выкл, смена режима)
- [ ] Добавить Hero анимации на home screen для согласованности
- [ ] Добавить анимации переходов между режимами

## Зависимости

Убедитесь, что в `pubspec.yaml` добавлены:

```yaml
dependencies:
  hvac_ui_kit:
    path: ../hvac_ui_kit
  fl_chart: ^0.66.0
```

## Примечания

- Все компоненты адаптивны и работают на mobile, tablet и desktop
- Анимации оптимизированы для производительности
- Используются фирменные цвета и стили из HvacColors и HvacTypography
