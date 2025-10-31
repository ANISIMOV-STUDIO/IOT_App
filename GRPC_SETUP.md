# gRPC Setup Guide

This project uses **gRPC** for communication between the Flutter frontend and the backend server.

## Architecture Overview

```
┌─────────────────┐         gRPC          ┌──────────────────┐
│                 │  ◄────────────────►   │                  │
│  Flutter App    │   Protocol Buffers    │  Backend Server  │
│  (iOS/Android)  │                       │  (Go/Node/etc)   │
│                 │                       │                  │
└─────────────────┘                       └──────────────────┘
                                                    │
                                                    │ MQTT
                                                    ▼
                                          ┌──────────────────┐
                                          │  HVAC Devices    │
                                          │  (via MQTT)      │
                                          └──────────────────┘
```

**Communication Flow:**
1. Flutter app connects to backend via **gRPC**
2. Backend manages HVAC devices via **MQTT**
3. Backend streams real-time updates to Flutter via **gRPC**

---

## Project Structure

```
IOT_App/
├── protos/                           # Protocol Buffer definitions
│   ├── hvac_service.proto           # HVAC device service (from backend)
│   ├── auth_service.proto           # Authentication service (from backend)
│   └── README.md                    # Proto documentation
│
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   └── env_config.dart      # gRPC host/port configuration
│   │   └── services/
│   │       └── grpc_service.dart    # gRPC service manager
│   │
│   └── data/
│       └── grpc/
│           ├── grpc_client.dart     # gRPC client wrapper
│           ├── generated/           # Auto-generated from .proto files
│           │   └── .gitignore       # Ignore generated files
│           └── services/            # Service implementations
│               ├── hvac_grpc_service.dart
│               └── auth_grpc_service.dart
│
└── .env.example                     # Environment variables template
```

---

## Setup Instructions

### 1. Install Protocol Buffer Compiler

#### macOS
```bash
brew install protobuf
```

#### Windows
Download from: https://github.com/protocolbuffers/protobuf/releases
Extract and add `bin/` to your PATH

#### Linux
```bash
sudo apt-get install protobuf-compiler
```

Verify installation:
```bash
protoc --version
```

### 2. Install Dart Protoc Plugin

```bash
dart pub global activate protoc_plugin
```

Add to PATH (if not already):
```bash
# macOS/Linux
export PATH="$PATH:$HOME/.pub-cache/bin"

# Windows (PowerShell)
$env:PATH += ";$env:USERPROFILE\.pub-cache\bin"
```

### 3. Get Proto Files from Backend

Coordinate with the backend team to get the `.proto` files. Place them in the `protos/` directory:

```bash
protos/
├── hvac_service.proto
├── auth_service.proto
└── common.proto (if any shared types)
```

### 4. Generate Dart Code

Run from project root:

```bash
# Generate all proto files
protoc --dart_out=grpc:lib/data/grpc/generated -Iprotos protos/*.proto

# Or generate specific file
protoc --dart_out=grpc:lib/data/grpc/generated -Iprotos protos/hvac_service.proto
```

This generates:
- `*.pb.dart` - Message classes
- `*.pbgrpc.dart` - Service stubs
- `*.pbenum.dart` - Enums
- `*.pbjson.dart` - JSON serialization

### 5. Configure Environment

Copy `.env.example` to `.env`:

```bash
cp .env.example .env
```

Edit `.env`:
```bash
# Backend API Configuration
API_BASE_URL=http://your-backend:8080

# gRPC Configuration
GRPC_HOST=your-backend-host
GRPC_PORT=50051
GRPC_USE_TLS=false  # Set to true in production
```

### 6. Run the App

```bash
flutter pub get
flutter run
```

---

## Using gRPC Services

### Example: HVAC Service

Once proto files are generated, use them like this:

```dart
import 'package:hvac_control/core/di/injection_container.dart' as di;
import 'package:hvac_control/core/services/grpc_service.dart';
import 'package:hvac_control/data/grpc/generated/hvac_service.pbgrpc.dart';

class HvacGrpcService {
  late HvacServiceClient _client;

  HvacGrpcService() {
    final grpcService = di.sl<GrpcService>();
    _client = HvacServiceClient(grpcService.client.channel);
  }

  Future<List<Device>> getDevices() async {
    try {
      final request = GetDevicesRequest();
      final response = await _client.getDevices(request);
      return response.devices;
    } catch (e) {
      print('Error getting devices: $e');
      rethrow;
    }
  }

  Future<Device> updateDeviceState({
    required String deviceId,
    bool? power,
    double? targetTemp,
  }) async {
    try {
      final request = UpdateDeviceStateRequest()
        ..deviceId = deviceId;

      if (power != null) request.power = power;
      if (targetTemp != null) request.targetTemp = targetTemp;

      final response = await _client.updateDeviceState(request);
      return response;
    } catch (e) {
      print('Error updating device: $e');
      rethrow;
    }
  }

  // Streaming example
  Stream<Device> watchDeviceUpdates(String deviceId) {
    final request = WatchDeviceRequest()..deviceId = deviceId;
    return _client.watchDevice(request);
  }
}
```

---

## Development Workflow

### When Backend Updates Proto Files

1. Get updated `.proto` files from backend
2. Place in `protos/` directory
3. Regenerate Dart code:
   ```bash
   protoc --dart_out=grpc:lib/data/grpc/generated -Iprotos protos/*.proto
   ```
4. Update service implementations if needed
5. Test changes

### Adding New Services

1. Get new `.proto` file from backend
2. Generate Dart code
3. Create service wrapper in `lib/data/grpc/services/`
4. Register in DI container if needed
5. Use in BLoC or use cases

---

## Testing gRPC Connection

### Test Connection

```dart
// In your app initialization or debug screen
final grpcService = di.sl<GrpcService>();

if (grpcService.isConnected) {
  print('✅ gRPC connected');
} else {
  print('❌ gRPC not connected');
  await grpcService.reconnect();
}
```

### Using Mock Mode

During development, you can use the Mock repository:

```dart
// lib/core/di/injection_container.dart
sl.registerLazySingleton<HvacRepository>(
  () => MockHvacRepository(), // Use mock while backend is in development
  // () => HvacGrpcRepository(), // Switch to gRPC when ready
);
```

---

## Production Considerations

### Enable TLS

In production, always use TLS:

```bash
# .env
GRPC_USE_TLS=true
GRPC_HOST=api.yourapp.com
GRPC_PORT=443
```

### Error Handling

Always handle gRPC errors:

```dart
try {
  final response = await _client.someMethod(request);
  return response;
} on GrpcError catch (e) {
  if (e.code == StatusCode.unavailable) {
    print('Server unavailable');
  } else if (e.code == StatusCode.unauthenticated) {
    print('Authentication failed');
  }
  rethrow;
} catch (e) {
  print('Unexpected error: $e');
  rethrow;
}
```

### Connection Management

Handle connection lifecycle:

```dart
// On app start
await grpcService.initialize();

// On app pause (optional)
await grpcService.disconnect();

// On app resume (optional)
await grpcService.reconnect();

// On app terminate
await grpcService.disconnect();
```

---

## Troubleshooting

### "protoc: command not found"
- Install Protocol Buffer Compiler (see step 1)
- Verify with `protoc --version`

### "protoc-gen-dart: command not found"
- Install Dart plugin: `dart pub global activate protoc_plugin`
- Add `~/.pub-cache/bin` to PATH

### Generated files not found
- Check generation command ran successfully
- Verify files are in `lib/data/grpc/generated/`
- Restart IDE/editor

### gRPC connection fails
- Check backend is running
- Verify host/port in `.env`
- Check firewall/network settings
- Try with `GRPC_USE_TLS=false` for local development

### "Unresolved reference" errors
- Regenerate proto files
- Run `flutter pub get`
- Restart IDE/editor
- Check imports in generated files

---

## Resources

- **gRPC Dart**: https://grpc.io/docs/languages/dart/
- **Protocol Buffers**: https://developers.google.com/protocol-buffers
- **grpc package**: https://pub.dev/packages/grpc
- **protobuf package**: https://pub.dev/packages/protobuf

---

## Backend Integration Checklist

- [ ] Get `.proto` files from backend team
- [ ] Generate Dart code from proto files
- [ ] Configure gRPC host/port in `.env`
- [ ] Implement service wrappers
- [ ] Update repository implementations
- [ ] Test connection with backend
- [ ] Handle authentication/authorization
- [ ] Test streaming updates
- [ ] Enable TLS for production
- [ ] Document API changes

---

**Note:** This project is configured for gRPC but currently uses Mock data. Switch to gRPC implementation once backend is ready.
