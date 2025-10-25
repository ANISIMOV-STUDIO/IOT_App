# HVAC Control - Setup & Development Guide

Complete guide for setting up and running the HVAC Control application.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Development Setup](#development-setup)
3. [MQTT Broker Setup](#mqtt-broker-setup)
4. [Testing the App](#testing-the-app)
5. [Switching Modes](#switching-modes)
6. [Common Issues](#common-issues)

---

## Quick Start

The fastest way to see the app in action:

```bash
# 1. Install dependencies
flutter pub get

# 2. Run in Mock mode (no MQTT required)
flutter run
```

The app will start with **fake data** showing 4 HVAC units. You can interact with all controls.

---

## Development Setup

### 1. Flutter Installation

**Check if Flutter is installed:**
```bash
flutter --version
```

**If not installed, visit:** https://docs.flutter.dev/get-started/install

### 2. IDE Setup (Recommended)

**Visual Studio Code:**
- Install "Flutter" extension
- Install "Dart" extension

**Android Studio:**
- Install "Flutter" plugin
- Install "Dart" plugin

### 3. Verify Setup

```bash
flutter doctor -v
```

Fix any issues reported by `flutter doctor`.

### 4. Clone & Setup Project

```bash
# Clone repository
git clone <your-repo-url>
cd IOT_App

# Get dependencies
flutter pub get

# Run the app
flutter run
```

---

## MQTT Broker Setup

To connect the app to a real MQTT broker:

### Option 1: Local Mosquitto Broker

**Install Mosquitto:**

**macOS:**
```bash
brew install mosquitto
brew services start mosquitto
```

**Windows:**
- Download from: https://mosquitto.org/download/
- Install and run as service

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install mosquitto mosquitto-clients
sudo systemctl start mosquitto
sudo systemctl enable mosquitto
```

**Test Broker:**
```bash
# Terminal 1: Subscribe
mosquitto_sub -h localhost -t '#' -v

# Terminal 2: Publish
mosquitto_pub -h localhost -t 'test' -m 'Hello MQTT'
```

### Option 2: Cloud MQTT Broker

**Free cloud brokers for testing:**
- HiveMQ Cloud: https://www.hivemq.com/mqtt-cloud-broker/
- CloudMQTT: https://www.cloudmqtt.com/
- EMQX Cloud: https://www.emqx.com/en/cloud

### Configure App for MQTT

**1. Enable MQTT mode:**

File: `lib/core/di/injection_container.dart`
```dart
const bool useMqtt = true;  // Change from false to true
```

**2. Set broker address:**

File: `lib/core/utils/constants.dart`
```dart
static const String mqttBrokerHost = 'localhost';  // or your broker IP
static const int mqttBrokerPort = 1883;
```

**3. Run the app:**
```bash
flutter run
```

---

## Testing the App

### Mock Mode Testing (No MQTT needed)

The app includes a mock repository with simulated data:

1. Ensure Mock mode is enabled:
   ```dart
   // lib/core/di/injection_container.dart
   const bool useMqtt = false;
   ```

2. Run the app:
   ```bash
   flutter run
   ```

3. You'll see 4 pre-configured units:
   - Living Room (Cooling, ON)
   - Bedroom (Cooling, ON)
   - Kitchen (Fan, OFF)
   - Office (Heating, ON)

4. Mock features:
   - ✅ Temperature changes simulate gradual adjustment
   - ✅ All controls work (power, temp, mode, fan speed)
   - ✅ Real-time updates every 5 seconds
   - ✅ Temperature history with fake data

### MQTT Mode Testing

**Backend Simulation Script:**

Create a Python script to simulate HVAC units:

```python
# mqtt_simulator.py
import paho.mqtt.client as mqtt
import json
import time
import random

BROKER = "localhost"
PORT = 1883

# Simulated units
units = [
    {"id": "1", "name": "Living Room", "power": True, "currentTemp": 22.5,
     "targetTemp": 24.0, "mode": "cooling", "fanSpeed": "auto"},
    {"id": "2", "name": "Bedroom", "power": True, "currentTemp": 23.0,
     "targetTemp": 22.0, "mode": "cooling", "fanSpeed": "medium"},
]

client = mqtt.Client()
client.connect(BROKER, PORT, 60)

def publish_units():
    # Publish units list
    client.publish("hvac/units", json.dumps(units))

    # Publish individual states
    for unit in units:
        unit["timestamp"] = time.strftime("%Y-%m-%dT%H:%M:%SZ")
        client.publish(f"hvac/units/{unit['id']}/state", json.dumps(unit))

def on_message(client, userdata, msg):
    print(f"Command received: {msg.topic} -> {msg.payload.decode()}")
    # Parse and apply command to unit...

client.on_message = on_message
client.subscribe("hvac/units/+/command")

# Main loop
client.loop_start()
try:
    while True:
        publish_units()
        time.sleep(5)
except KeyboardInterrupt:
    print("Stopping...")
    client.loop_stop()
```

**Run simulator:**
```bash
pip install paho-mqtt
python mqtt_simulator.py
```

**Then run Flutter app in MQTT mode.**

---

## Switching Modes

### From Mock to MQTT

1. **Edit** `lib/core/di/injection_container.dart`:
   ```dart
   const bool useMqtt = true;
   ```

2. **Hot restart** the app (press `R` in terminal or click Hot Restart button)

### From MQTT to Mock

1. **Edit** `lib/core/di/injection_container.dart`:
   ```dart
   const bool useMqtt = false;
   ```

2. **Hot restart** the app

**Note:** Hot reload (`r`) won't work for DI changes. Always use Hot Restart (`R`).

---

## Common Issues

### Issue 1: "flutter: command not found"

**Solution:**
- Add Flutter to PATH
- Restart terminal/IDE
- Verify: `flutter doctor`

### Issue 2: MQTT connection fails

**Symptoms:**
- App shows "Error" or empty list
- Console shows "MQTT connection failed"

**Solutions:**
1. **Check broker is running:**
   ```bash
   # macOS/Linux
   ps aux | grep mosquitto

   # Windows
   tasklist | findstr mosquitto
   ```

2. **Test broker manually:**
   ```bash
   mosquitto_sub -h localhost -t '#' -v
   ```

3. **Check firewall:**
   - Ensure port 1883 is open
   - Windows: Add firewall exception

4. **Check broker address:**
   - For localhost: Use `localhost` or `127.0.0.1`
   - For network: Use actual IP (e.g., `192.168.1.100`)
   - For emulator: Use `10.0.2.2` (Android) or `localhost` (iOS)

### Issue 3: Build errors after pubspec changes

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue 4: Hot reload doesn't work

**Solution:**
- Use Hot Restart (`R`) instead
- For DI changes, hot reload never works
- Stop and restart the app

### Issue 5: Icons/Splash not showing

**Generate assets:**
```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

### Issue 6: Temperature chart not displaying

**Check:**
- `fl_chart` dependency installed
- Temperature history loaded (may be empty in MQTT mode)
- In Mock mode, chart should always show

---

## Platform-Specific Notes

### Android Emulator

**MQTT Localhost:**
- Use `10.0.2.2` instead of `localhost`
- Or use your machine's IP address

**Internet Permission:**
Already configured in `android/app/src/main/AndroidManifest.xml`

### iOS Simulator

**MQTT Localhost:**
- Use `localhost` (works directly)

**Network Permission:**
Already configured in `ios/Runner/Info.plist`

### Web

**MQTT:**
- Requires WebSocket MQTT broker (not standard MQTT)
- Configure broker with WebSocket support on port 9001
- May need CORS configuration

### macOS/Windows/Linux

**MQTT Localhost:**
- Use `localhost` or `127.0.0.1`

---

## Development Workflow

### Recommended Workflow

1. **Start in Mock mode** for UI development
2. **Test all features** without MQTT complexity
3. **Switch to MQTT** once UI is stable
4. **Test with real broker** or simulator

### Making Changes

**UI Changes:**
- Edit widgets in `lib/presentation/widgets/`
- Use Hot Reload (`r`) for instant updates

**BLoC Changes:**
- Edit in `lib/presentation/bloc/`
- Use Hot Restart (`R`)

**Repository Changes:**
- Edit in `lib/data/repositories/`
- Use Hot Restart (`R`)

**Theme Changes:**
- Edit `lib/core/theme/app_theme.dart`
- Use Hot Reload (`r`)

---

## Testing Checklist

Before considering the app complete, test:

- [ ] Mock mode works
- [ ] MQTT mode connects
- [ ] All HVAC units display
- [ ] Temperature slider works
- [ ] Mode selection works
- [ ] Fan speed control works
- [ ] Power toggle works
- [ ] Temperature chart displays
- [ ] Responsive navigation (mobile vs desktop)
- [ ] Settings screen accessible
- [ ] About dialog works
- [ ] Hot reload works for UI changes
- [ ] App builds for target platforms

---

## Next Steps

1. **Add icon images** to `assets/` folder
2. **Run icon generator**: `flutter pub run flutter_launcher_icons`
3. **Test on all target platforms**
4. **Set up CI/CD** (optional)
5. **Deploy to stores** (optional)

---

## Useful Commands

```bash
# Development
flutter run                          # Run app
flutter run -d <device>             # Run on specific device
flutter devices                      # List devices

# Building
flutter build apk                    # Android APK
flutter build appbundle              # Android App Bundle
flutter build ios                    # iOS
flutter build web                    # Web
flutter build macos                  # macOS
flutter build windows                # Windows
flutter build linux                  # Linux

# Maintenance
flutter clean                        # Clean build artifacts
flutter pub get                      # Get dependencies
flutter pub upgrade                  # Upgrade dependencies
flutter doctor                       # Check setup

# Code Quality
flutter analyze                      # Static analysis
flutter test                         # Run tests
flutter test --coverage              # Test with coverage

# Assets
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

---

**Happy Coding! 🚀**
