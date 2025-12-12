# HVAC IoT Flutter Application - Project Analysis Request

## Project Overview
Smart Home HVAC control application built with Flutter for Web/Mobile/Desktop.
Controls ventilation units (Zilon brand) via MQTT/gRPC protocols.

## Tech Stack
- **Framework**: Flutter 3.x (Web primary, Mobile secondary)
- **State Management**: BLoC pattern (flutter_bloc)
- **Architecture**: Clean Architecture (Domain/Data/Presentation layers)
- **UI System**: Custom Neumorphic Design System (soft UI)
- **Localization**: Russian (primary), English
- **Protocols**: MQTT, gRPC (planned)

## Code Statistics
- **Main app (lib/)**: ~27,000 lines
- **UI Kit (smart_ui_kit/)**: ~3,200 lines
- **Total**: ~30,000 lines of Dart code

## Architecture Structure

```
lib/
├── core/                    # Core utilities, DI, navigation
│   ├── di/                  # Dependency injection (get_it)
│   ├── l10n/                # Localization (ru/en)
│   ├── navigation/          # go_router setup
│   ├── services/            # API, gRPC, secure storage
│   └── theme/               # Legacy theme tokens
│
├── domain/                  # Business logic layer
│   ├── entities/            # Domain models (18 entities)
│   │   ├── climate.dart     # ClimateState, ClimateMode, AirQuality
│   │   ├── hvac_unit.dart   # HvacUnit device model
│   │   ├── smart_device.dart
│   │   ├── energy_stats.dart
│   │   └── ...
│   ├── repositories/        # Abstract repository interfaces
│   └── usecases/            # Business use cases
│
├── data/                    # Data layer
│   ├── repositories/        # Repository implementations
│   │   ├── mock_*.dart      # Mock implementations for development
│   │   └── *_impl.dart      # Real implementations
│   ├── models/              # Data transfer objects
│   └── grpc/                # gRPC client setup
│
├── presentation/            # UI layer
│   ├── bloc/                # BLoC state management
│   │   ├── dashboard/       # Main dashboard state
│   │   ├── hvac_list/       # Device list state
│   │   ├── hvac_detail/     # Device detail state
│   │   └── statistics/      # Statistics state
│   ├── screens/             # Main screens
│   │   └── neumorphic_dashboard_screen.dart  # Main UI (708 lines)
│   ├── pages/               # Secondary pages
│   └── widgets/             # Reusable widgets
│
└── application/             # Legacy Cubit layer (being deprecated)

packages/
└── smart_ui_kit/            # Neumorphic Design System package
    └── lib/src/
        ├── theme/           # Theme tokens, typography, colors
        │   ├── neumorphic_theme.dart
        │   └── tokens/
        │       ├── neumorphic_colors.dart
        │       ├── neumorphic_typography.dart
        │       ├── neumorphic_shadows.dart
        │       └── neumorphic_spacing.dart
        └── widgets/
            └── neumorphic/  # UI components
                ├── neumorphic_card.dart
                ├── neumorphic_button.dart
                ├── neumorphic_slider.dart        # Uses native Flutter Slider
                ├── neumorphic_temperature_dial.dart  # Uses sleek_circular_slider
                ├── neumorphic_sidebar.dart
                ├── neumorphic_dashboard_shell.dart
                └── ...
```

## Current Dashboard Layout

### Main Content (Left Panel)
1. **Device Status** - Power toggle, device name, Active/Standby indicator
2. **Sensors Grid** - Temperature (°C), Humidity (%), CO2 (ppm)
3. **Schedule** - Timeline: Wake 07:00, Away 09:00, Home 18:00, Sleep 22:00
4. **Quick Actions** - All Off, Schedule, Sync, Settings (2x2 grid)
5. **Energy Stats** - Total kWh, Hours of operation

### Right Panel (Control)
1. **Temperature Dial** - Target temperature 10-30°C (circular slider)
2. **Mode Selector** - Heating, Cooling, Auto, Ventilation
3. **Airflow Control** - Supply 0-100%, Exhaust 0-100%
4. **Presets** - Auto, Night, Turbo, Eco, Away

## Domain Model: ClimateState

```dart
class ClimateState {
  final String roomId;
  final String deviceName;
  final double currentTemperature;
  final double targetTemperature;
  final double humidity;
  final double targetHumidity;
  final double supplyAirflow;      // 0-100%
  final double exhaustAirflow;     // 0-100%
  final ClimateMode mode;          // heating/cooling/auto/dry/ventilation/off
  final String preset;             // auto/night/turbo/eco/away
  final AirQualityLevel airQuality;
  final int co2Ppm;
  final int pollutantsAqi;
  final bool isOn;
}
```

## BLoC Events (Dashboard)

```dart
// Lifecycle
DashboardStarted, DashboardRefreshed

// Device control
DeviceToggled, DevicePowerToggled, AllDevicesOff

// Climate control
TemperatureChanged, HumidityChanged, ClimateModeChanged
SupplyAirflowChanged, ExhaustAirflowChanged, PresetChanged

// Stream updates
DevicesUpdated, ClimateUpdated, EnergyUpdated, OccupantsUpdated
```

## Key Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  go_router: ^14.8.1
  get_it: ^7.7.0
  equatable: ^2.0.5
  google_fonts: ^6.1.0
  flutter_animate: ^4.5.0
  sleek_circular_slider: ^2.0.1
  fl_chart: ^0.69.2
  grpc: ^4.1.0
  mqtt_client: ^10.6.0
```

## Questions for Analysis

1. **Architecture**: Is Clean Architecture + BLoC the right choice for this IoT app?
   - Should we consider Riverpod instead of BLoC?
   - Is the separation between domain/data/presentation optimal?

2. **UI System**: Custom Neumorphic design system vs existing packages?
   - Worth the ~3200 lines of custom code?
   - Should we use flutter_neumorphic package instead?

3. **State Management**: 
   - BLoC for dashboard + legacy Cubits in application/ layer
   - How to properly migrate/unify?

4. **Performance**: 
   - Flutter Web for HVAC dashboard - right choice?
   - Any concerns with real-time MQTT updates + BLoC?

5. **Code Organization**:
   - 27k lines seems large - what should be refactored?
   - Legacy code in application/, core/widgets/ - remove or keep?

6. **Missing Features**:
   - No tests currently
   - No error boundaries
   - No offline support
   - What's the priority?

7. **Real Device Integration**:
   - Mock repositories ready, real ones not implemented
   - MQTT vs gRPC vs REST - what's best for HVAC?

## Recent Changes (Last 3 Commits)

1. `558b121` - Reorganized dashboard with real HVAC categories
2. `55852b3` - Replaced custom sliders with optimized implementations (sleek_circular_slider)
3. `5615fef` - Removed 22,000 lines of legacy Zilon UI code

## What We Need

Expert review on:
- Architecture decisions
- Performance concerns for Flutter Web + real-time IoT
- UI/UX improvements for HVAC control
- Priority of missing features
- Code quality recommendations
