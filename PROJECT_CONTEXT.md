# BREEZ Home - Контекст проекта для AI-ассистента

## Обзор проекта

**BREEZ Home** - это Flutter веб-приложение для управления HVAC-оборудованием (вентиляция, кондиционирование, отопление) компании BREEZ. Это **НЕ** обычный умный дом с телевизорами и розетками - это специализированное приложение для управления промышленными и бытовыми вентиляционными установками.

### Ключевые характеристики:
- **Платформа**: Flutter Web (только веб)
- **Язык интерфейса**: Русский (основной), Английский
- **Цветовая схема**: BREEZ Blue (#2563EB) - корпоративный синий
- **UI Framework**: Material Design 3 + Custom BREEZ widgets
- **Архитектура**: Clean Architecture + BLoC

---

## Архитектура проекта

```
lib/
├── core/                    # Ядро приложения
│   ├── di/                  # Dependency Injection (GetIt)
│   ├── l10n/                # Локализация (ru/en)
│   ├── navigation/          # GoRouter
│   ├── services/            # ThemeService, LanguageService
│   └── theme/               # AppColors, AppTheme, Spacing
│
├── data/                    # Слой данных
│   └── repositories/        # Мок-репозитории (пока нет реального API)
│
├── domain/                  # Бизнес-логика
│   ├── entities/            # Сущности (ClimateState, SmartDevice, etc.)
│   └── repositories/        # Абстрактные интерфейсы репозиториев
│
├── presentation/            # UI слой
│   ├── bloc/                # BLoC (DashboardBloc)
│   ├── screens/             # Экраны
│   └── widgets/             # UI компоненты
│       ├── common/          # Общие виджеты
│       ├── layout/          # AppShell (responsive layout)
│       └── ui/              # Карточки, графики, кнопки
│
└── main.dart
```

---

## Мок-данные (Mock Repositories)

### 1. MockSmartDeviceRepository
**Файл**: `lib/data/repositories/mock_smart_device_repository.dart`

Управляет списком HVAC устройств для быстрого переключения на дашборде.

```dart
// Типы HVAC устройств (SmartDeviceType enum)
enum SmartDeviceType {
  ventilation,    // Приточно-вытяжная установка (ПВУ)
  airCondition,   // Кондиционер
  recuperator,    // Рекуператор
  humidifier,     // Увлажнитель
  dehumidifier,   // Осушитель
  heater,         // Нагреватель воздуха
  cooler,         // Охладитель воздуха
}

// Мок-устройства:
- ПВ-1 (id: 'pv_1') - вентиляция, включена, гостиная
- ПВ-2 (id: 'pv_2') - вентиляция, выключена, спальня
- ПВ-3 (id: 'pv_3') - вентиляция, включена, офис
```

**Методы**:
- `getAllDevices()` - получить все устройства
- `getDevicesByRoom(roomId)` - устройства по комнате
- `toggleDevice(id, isOn)` - включить/выключить
- `watchDevices()` - Stream обновлений

---

### 2. MockClimateRepository
**Файл**: `lib/data/repositories/mock_climate_repository.dart`

Основной репозиторий климат-контроля. Поддерживает **несколько устройств** с разными состояниями.

```dart
// Мок HVAC устройства:

1. ZILON ZPE-6000 (id: 'zilon-1')
   - Тип: Приточная установка
   - Комната: main
   - Температура: 21.5°C → 22.0°C (target)
   - Влажность: 58%
   - Приток/Вытяжка: 65% / 50%
   - Режим: auto
   - CO₂: 720 ppm
   - Качество воздуха: good
   - Статус: включена, онлайн

2. LG Dual Inverter (id: 'lg-1')
   - Тип: Сплит-система
   - Комната: bedroom
   - Температура: 24.0°C → 23.0°C
   - Влажность: 45%
   - Режим: cooling
   - CO₂: 520 ppm
   - Статус: выключена, онлайн

3. Xiaomi Mi Humidifier (id: 'xiaomi-1')
   - Тип: Увлажнитель
   - Комната: living
   - Влажность: 52% → 55%
   - Режим: ventilation
   - Статус: выключена, ОФЛАЙН
```

**ClimateState** содержит:
- `currentTemperature`, `targetTemperature`
- `humidity`, `targetHumidity`
- `supplyAirflow`, `exhaustAirflow` (приток/вытяжка %)
- `mode` (heating, cooling, auto, dry, ventilation, off)
- `preset` (auto, night, turbo, eco, away)
- `airQuality` (excellent, good, moderate, poor, hazardous)
- `co2Ppm`, `pollutantsAqi`
- `isOn`

**Пресеты** автоматически меняют параметры:
- `night`: температура 19°C, приток 30%, вытяжка 25%
- `turbo`: приток 100%, вытяжка 90%
- `eco`: температура 20°C, приток 40%, вытяжка 35%
- `away`: температура 16°C, приток 20%, вытяжка 15%

---

### 3. MockEnergyRepository
**Файл**: `lib/data/repositories/mock_energy_repository.dart`

Статистика энергопотребления.

```dart
// Потребление по устройствам:
- ПВ-1: 18 кВт·ч
- ПВ-2: 14 кВт·ч
- ПВ-3: 16 кВт·ч

// Почасовые данные генерируются случайно (1-4 кВт·ч/час)
```

**EnergyStats**:
- `totalKwh` - общее потребление за день
- `totalHours` - часов работы
- `hourlyData` - список HourlyUsage (hour, kwh)

---

### 4. MockOccupantRepository
**Файл**: `lib/data/repositories/mock_occupant_repository.dart`

Жители/пользователи системы.

```dart
// Мок-жители:
- Иван (id: 'occ_1') - дома
- Мария (id: 'occ_2') - дома
- Алексей (id: 'occ_3') - не дома
- Ольга (id: 'occ_4') - дома
- Дмитрий (id: 'occ_5') - не дома
```

**Occupant**:
- `id`, `name`, `avatarUrl`
- `isHome` - находится ли дома
- `currentRoom` - в какой комнате

---

## Сущности (Domain Entities)

### SmartDevice
```dart
class SmartDevice {
  String id;
  String name;           // "ПВ-1", "ПВ-2"
  SmartDeviceType type;  // ventilation, airCondition, etc.
  bool isOn;
  String? roomId;
  double powerConsumption;  // кВт
  Duration activeTime;
  DateTime lastUpdated;
}
```

### HvacDevice
```dart
class HvacDevice {
  String id;
  String name;      // "ZILON ZPE-6000"
  String brand;     // "ZILON", "LG", "Xiaomi"
  String type;      // "Приточная установка", "Сплит-система"
  bool isOnline;
  bool isActive;
  IconData icon;
}
```

### ClimateState
```dart
class ClimateState {
  String roomId;
  String deviceName;
  double currentTemperature;
  double targetTemperature;
  double humidity;
  double targetHumidity;
  double supplyAirflow;    // Приток %
  double exhaustAirflow;   // Вытяжка %
  ClimateMode mode;
  String preset;
  AirQualityLevel airQuality;
  int co2Ppm;
  int pollutantsAqi;
  bool isOn;
}
```

---

## DashboardBloc

**Файл**: `lib/presentation/bloc/dashboard/dashboard_bloc.dart`

Центральный BLoC для главного экрана.

### События (Events):
- `DashboardStarted` - инициализация
- `DashboardRefreshed` - обновить данные
- `DeviceToggled(deviceId, isOn)` - переключить устройство
- `TemperatureChanged(temperature)` - изменить целевую температуру
- `HumidityChanged(humidity)` - изменить влажность
- `ClimateModeChanged(mode)` - сменить режим
- `PresetChanged(preset)` - сменить пресет
- `HvacDeviceSelected(deviceId)` - выбрать HVAC устройство
- `AllDevicesOff` - выключить всё

### Состояние (State):
```dart
class DashboardState {
  DashboardStatus status;        // loading, success, failure
  List<SmartDevice> devices;     // Устройства для shortcuts
  ClimateState? climate;         // Текущее состояние климата
  EnergyStats? energyStats;      // Статистика энергии
  List<Occupant> occupants;      // Жители
  List<HvacDevice> hvacDevices;  // HVAC устройства
  String? selectedHvacDeviceId;  // Выбранное устройство
}
```

---

## UI Компоненты

### AppShell (`lib/presentation/widgets/layout/app_shell.dart`)
Responsive layout с:
- Header (логотип, поиск, аватар)
- Bottom navigation (всегда видима, macOS dock style)
- Синий градиент навигации

### UI Widgets (`lib/presentation/widgets/ui/`)
- `AppCard`, `GradientCard`, `OutlineCard` - карточки
- `WelcomeBanner` - приветственный баннер
- `DeviceShortcut`, `DeviceShortcutsGrid` - быстрые переключатели устройств
- `TemperatureCard`, `CircularStatCard` - карточки статистики
- `EnergyChartCard` - график энергопотребления
- `RoomsRow`, `RoomData` - список комнат

---

## Цветовая схема (AppColors)

```dart
// Primary - BREEZ Blue
primary: #2563EB (Blue-600)
primaryLight: #3B82F6 (Blue-500)
primaryDark: #1D4ED8 (Blue-700)

// Accent - Cyan
accent: #06B6D4 (Cyan-500)

// Backgrounds
background: #F8FAFC (Slate-50)
surface: #FFFFFF
surfaceVariant: #EFF6FF (Blue-50)

// Text
textPrimary: #0F172A (Slate-900)
textSecondary: #475569 (Slate-600)
textMuted: #94A3B8 (Slate-400)

// Climate modes
heating: #EF4444 (Red)
cooling: #3B82F6 (Blue)
modeAuto: #8B5CF6 (Violet)
ventilation: #06B6D4 (Cyan)

// Status
success: #22C55E
warning: #F59E0B
error: #EF4444
info: #3B82F6
```

---

## Локализация

**Языки**: Русский (по умолчанию), Английский

**Файлы**:
- `lib/core/l10n/app_strings.dart` - интерфейс
- `lib/core/l10n/ru_strings.dart` - русский
- `lib/core/l10n/en_strings.dart` - английский

**Использование**:
```dart
final s = context.l10n;
Text(s.temperature); // "Температура"
Text(s.ventilationUnit); // "Приточно-вытяжная установка"
```

---

## Важные замечания для разработки

1. **Это HVAC приложение** - никаких телевизоров, умных ламп и розеток. Только вентиляция, кондиционирование, отопление.

2. **Мок-данные** - пока нет реального API, все данные моковые. При подключении API нужно заменить Mock*Repository на реальные реализации.

3. **Корпоративный цвет** - синий (#2563EB), НЕ фиолетовый.

4. **Responsive** - приложение должно работать на мобильных и десктопах. Breakpoint: 768px.

5. **BLoC pattern** - вся логика в BLoC, UI только отображает состояние.

6. **Clean Architecture** - строгое разделение на data/domain/presentation.

---

## Запуск проекта

```bash
# Установка зависимостей
flutter pub get

# Запуск в Chrome
flutter run -d chrome

# Анализ кода
dart analyze
```

---

## Структура навигации

```
/ (Dashboard)
├── Главная (Home)
├── Комнаты (Rooms)
├── Расписание (Schedule)
├── Статистика (Statistics)
└── Уведомления (Notifications)
```

---

## TODO / Roadmap

- [ ] Подключение реального API (gRPC/REST)
- [ ] Авторизация пользователей
- [ ] Push-уведомления
- [ ] Графики потребления за неделю/месяц
- [ ] Управление расписанием
- [ ] Настройки аккаунта
