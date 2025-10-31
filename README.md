# HVAC Control

HVAC (Heating, Ventilation, and Air Conditioning) control application built with Flutter.

## Features

- **Multi-Platform**: Runs on iOS, Android, and Web
- **Real-Time MQTT Communication**: Connects to MQTT broker for live device control
- **Adaptive UI**: Responsive design with BottomNavigationBar (mobile) and NavigationRail (desktop)
- **Clean Architecture**: Separation of concerns with Domain, Data, and Presentation layers
- **BLoC State Management**: Predictable state management using flutter_bloc
- **Temperature Control**: Circular slider for intuitive temperature adjustment
- **Multiple Modes**: Support for Cooling, Heating, Fan, and Auto modes
- **Fan Speed Control**: Variable fan speed settings
- **Temperature History**: Visual charts showing temperature trends
- **Mock Mode**: Test the app without MQTT broker connection

## Screenshots

*(Add screenshots here after running the app)*

## Architecture

The project follows **Clean Architecture** principles:

```
lib/
├── core/
│   ├── di/              # Dependency Injection
│   ├── theme/           # App Theme
│   └── utils/           # Constants & Helpers
├── data/
│   ├── datasources/     # MQTT Datasource
│   ├── models/          # Data Models
│   └── repositories/    # Repository Implementations
├── domain/
│   ├── entities/        # Business Entities
│   ├── repositories/    # Repository Interfaces
│   └── usecases/        # Business Logic
└── presentation/
    ├── bloc/            # BLoC State Management
    ├── pages/           # Screens
    └── widgets/         # Reusable Widgets
```

## Prerequisites

- Flutter SDK (3.1.5 or higher)
- Dart SDK (included with Flutter)
- For MQTT: A running MQTT broker (e.g., Mosquitto, HiveMQ)

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd IOT_App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure MQTT (Optional)**

   By default, the app runs in **Mock Mode** with fake data.

   To enable MQTT:
   - Open `lib/core/di/injection_container.dart`
   - Change `const bool useMqtt = false;` to `const bool useMqtt = true;`
   - Configure your MQTT broker settings in `lib/core/utils/constants.dart`:
     ```dart
     static const String mqttBrokerHost = 'your-broker-host';
     static const int mqttBrokerPort = 1883;
     ```

## Running the App

### Development Mode (All Platforms)

```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Platform-Specific

```bash
# iOS (requires macOS)
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome
```

## Building for Production

### Android

```bash
# APK
flutter build apk --release

# App Bundle (for Google Play)
flutter build appbundle --release
```

Output: `build/app/outputs/`

### iOS

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode to archive and upload.

### Web

```bash
flutter build web --release
```

Output: `build/web/`

## Customizing App Icons & Splash Screen

1. **Replace icon images**:
   - `assets/icon.png` (1024x1024)
   - `assets/icon_foreground.png` (1024x1024, transparent background)
   - `assets/splash_logo.png` (512x512)

2. **Generate icons**:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

3. **Generate splash screens**:
   ```bash
   flutter pub run flutter_native_splash:create
   ```

## MQTT Protocol

### Topics

| Topic | Type | Description |
|-------|------|-------------|
| `hvac/units` | Subscribe | List of all HVAC units |
| `hvac/units/+/state` | Subscribe | State updates for specific unit |
| `hvac/units/{id}/command` | Publish | Send commands to unit |

### Message Format

**Unit State (JSON)**:
```json
{
  "id": "1",
  "name": "Living Room",
  "power": true,
  "currentTemp": 22.5,
  "targetTemp": 24.0,
  "mode": "cooling",
  "fanSpeed": "auto",
  "timestamp": "2025-01-15T10:30:00Z"
}
```

**Command (JSON)**:
```json
{
  "power": true,
  "targetTemp": 25.0,
  "mode": "heating",
  "fanSpeed": "high"
}
```

## Configuration

### Switch Between Mock and MQTT

File: `lib/core/di/injection_container.dart`

```dart
// Set to true for MQTT, false for Mock data
const bool useMqtt = false;
```

### MQTT Broker Settings

File: `lib/core/utils/constants.dart`

```dart
static const String mqttBrokerHost = 'localhost';
static const int mqttBrokerPort = 1883;
static const String mqttClientId = 'hvac_control_app';
```

### Temperature Range

File: `lib/core/utils/constants.dart`

```dart
static const double minTemperature = 16.0;
static const double maxTemperature = 30.0;
```

## Testing

### Run Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/domain/usecases/get_all_units_test.dart
```

### Code Coverage

```bash
flutter test --coverage
```

## Troubleshooting

### MQTT Connection Issues

1. **Check broker is running**:
   ```bash
   # For Mosquitto on localhost
   mosquitto -v
   ```

2. **Test connection**:
   ```bash
   mosquitto_sub -h localhost -t '#' -v
   ```

3. **Firewall**: Ensure port 1883 is open

### Build Issues

1. **Clean build**:
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Check Flutter doctor**:
   ```bash
   flutter doctor -v
   ```

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: flutter_bloc
- **DI**: get_it
- **MQTT**: mqtt_client
- **Charts**: fl_chart
- **Architecture**: Clean Architecture

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Contact

For questions or support, please open an issue on GitHub.

---

**Made with ❤️ using Flutter**
