# Proto Setup Instructions

## 1. Install protoc compiler

### Option A: Download from GitHub
1. Go to https://github.com/protocolbuffers/protobuf/releases
2. Download `protoc-XX.X-win64.zip` (latest version)
3. Extract to `C:\tools\protoc\` (or any location)
4. Add `C:\tools\protoc\bin\` to your PATH environment variable

### Option B: Use chocolatey
```bash
choco install protoc
```

## 2. Install Dart protoc plugin

```bash
dart pub global activate protoc_plugin
```

Add to PATH:
- `%USERPROFILE%\AppData\Local\Pub\Cache\bin`

## 3. Verify installation

```bash
protoc --version
protoc-gen-dart --version
```

## 4. Generate Dart code

Run the generation script:
```bash
cd C:\Projects\IOT_App
.\scripts\generate_proto.bat
```

This will generate ~26 `.pb.dart` and `.pbgrpc.dart` files in `lib/generated/protos/`

## 5. Add to pubspec.yaml

Make sure these dependencies are in `pubspec.yaml`:
```yaml
dependencies:
  grpc: ^4.0.0
  protobuf: ^3.1.0
```

Then run:
```bash
flutter pub get
```

## Status

- ✅ Proto files copied (13 files in `protos/`)
- ✅ Generation script created (`scripts/generate_proto.bat`)
- ⏳ Waiting for protoc installation
- ⏳ Dart code generation pending

## Next Steps

After proto generation completes, you can continue with:
- Step 2: Core Infrastructure
- Step 3: Platform Abstraction
- Step 4: Data Mappers (requires generated proto code)
- Step 5: gRPC Clients (requires generated proto code)
