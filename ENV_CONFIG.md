# Environment Configuration Guide

This document explains how to configure the HVAC Control application using environment variables.

## Configuration Methods

The application supports two ways to configure MQTT settings:

1. **Environment Variables** (for build-time configuration)
2. **UI Settings** (for runtime configuration via Settings screen)

## Using Environment Variables

### Step 1: Create Environment File

Copy the example file:
```bash
cp .env.example .env
```

Edit `.env` with your settings:
```env
USE_MQTT=true
MQTT_BROKER_HOST=192.168.1.100
MQTT_BROKER_PORT=1883
MQTT_CLIENT_ID=hvac_control_app
MQTT_USERNAME=your_username
MQTT_PASSWORD=your_password
MQTT_USE_SSL=false
```

### Step 2: Build with Environment Variables

#### Android
```bash
flutter build apk --dart-define=USE_MQTT=true --dart-define=MQTT_BROKER_HOST=192.168.1.100 --dart-define=MQTT_BROKER_PORT=1883
```

#### iOS
```bash
flutter build ios --dart-define=USE_MQTT=true --dart-define=MQTT_BROKER_HOST=192.168.1.100 --dart-define=MQTT_BROKER_PORT=1883
```

#### Web
```bash
flutter build web --dart-define=USE_MQTT=true --dart-define=MQTT_BROKER_HOST=ws://192.168.1.100 --dart-define=MQTT_BROKER_PORT=9001
```

#### Desktop (Windows/macOS/Linux)
```bash
flutter build windows --dart-define=USE_MQTT=true --dart-define=MQTT_BROKER_HOST=192.168.1.100
flutter build macos --dart-define=USE_MQTT=true --dart-define=MQTT_BROKER_HOST=192.168.1.100
flutter build linux --dart-define=USE_MQTT=true --dart-define=MQTT_BROKER_HOST=192.168.1.100
```

### Step 3: Run with Environment Variables

```bash
flutter run --dart-define=USE_MQTT=true --dart-define=MQTT_BROKER_HOST=192.168.1.100
```

## Available Environment Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `USE_MQTT` | boolean | `false` | Enable MQTT mode (true) or use Mock mode (false) |
| `MQTT_BROKER_HOST` | string | `localhost` | MQTT broker hostname or IP address |
| `MQTT_BROKER_PORT` | integer | `1883` | MQTT broker port number |
| `MQTT_CLIENT_ID` | string | `hvac_control_app` | Unique client identifier |
| `MQTT_USERNAME` | string | _(empty)_ | Optional authentication username |
| `MQTT_PASSWORD` | string | _(empty)_ | Optional authentication password |
| `MQTT_USE_SSL` | boolean | `false` | Enable SSL/TLS encryption |

## Using UI Settings

For runtime configuration without rebuilding:

1. Launch the app
2. Navigate to **Settings** screen
3. Tap on **MQTT Broker** settings
4. Enter your broker details
5. Save and restart the app

**Note:** UI settings override environment variables.

## Examples

### Example 1: Local MQTT Broker (Development)
```bash
flutter run \
  --dart-define=USE_MQTT=true \
  --dart-define=MQTT_BROKER_HOST=localhost \
  --dart-define=MQTT_BROKER_PORT=1883
```

### Example 2: Remote MQTT Broker with Authentication
```bash
flutter run \
  --dart-define=USE_MQTT=true \
  --dart-define=MQTT_BROKER_HOST=mqtt.example.com \
  --dart-define=MQTT_BROKER_PORT=1883 \
  --dart-define=MQTT_USERNAME=myuser \
  --dart-define=MQTT_PASSWORD=mypassword
```

### Example 3: Secure MQTT with SSL/TLS
```bash
flutter run \
  --dart-define=USE_MQTT=true \
  --dart-define=MQTT_BROKER_HOST=mqtt.example.com \
  --dart-define=MQTT_BROKER_PORT=8883 \
  --dart-define=MQTT_USE_SSL=true \
  --dart-define=MQTT_USERNAME=myuser \
  --dart-define=MQTT_PASSWORD=mypassword
```

### Example 4: Mock Mode (No MQTT Broker)
```bash
flutter run --dart-define=USE_MQTT=false
# or simply:
flutter run
```

## Configuration Script (Optional)

Create a shell script for easier configuration:

**config.sh** (Linux/macOS):
```bash
#!/bin/bash
flutter run \
  --dart-define=USE_MQTT=true \
  --dart-define=MQTT_BROKER_HOST=192.168.1.100 \
  --dart-define=MQTT_BROKER_PORT=1883 \
  --dart-define=MQTT_CLIENT_ID=hvac_app \
  --dart-define=MQTT_USERNAME=admin \
  --dart-define=MQTT_PASSWORD=secret123
```

**config.bat** (Windows):
```batch
@echo off
flutter run ^
  --dart-define=USE_MQTT=true ^
  --dart-define=MQTT_BROKER_HOST=192.168.1.100 ^
  --dart-define=MQTT_BROKER_PORT=1883 ^
  --dart-define=MQTT_CLIENT_ID=hvac_app ^
  --dart-define=MQTT_USERNAME=admin ^
  --dart-define=MQTT_PASSWORD=secret123
```

Make it executable:
```bash
chmod +x config.sh
./config.sh
```

## Security Notes

1. **Never commit `.env` files** to version control (already in `.gitignore`)
2. **Use SSL/TLS** for production deployments
3. **Rotate credentials** regularly
4. **Use strong passwords** for MQTT authentication
5. **Restrict broker access** with firewall rules

## Troubleshooting

### Issue: Settings not applied
- Make sure you're using `--dart-define` flags when running/building
- Check that environment variables are spelled correctly
- Restart the app after changing settings

### Issue: Cannot connect to broker
- Verify broker is running and accessible
- Check firewall settings
- Ensure correct host and port
- Try telnet: `telnet <host> <port>`

### Issue: Authentication failed
- Verify username and password are correct
- Check broker logs for authentication errors
- Ensure broker has authentication enabled

## More Information

- [Flutter Build Modes](https://docs.flutter.dev/deployment)
- [MQTT Protocol](https://mqtt.org/)
- [Environment Variables in Flutter](https://docs.flutter.dev/deployment/flavors)
