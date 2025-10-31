# Protocol Buffers (Protobuf) Files

This directory contains `.proto` files that define the gRPC service interfaces and message types.

## How to Generate Dart Code

### Prerequisites

Install the Protocol Buffer Compiler (protoc) and Dart plugin:

```bash
# Install protoc
# - macOS: brew install protobuf
# - Windows: Download from https://github.com/protocolbuffers/protobuf/releases
# - Linux: sudo apt-get install protobuf-compiler

# Install Dart protoc plugin
dart pub global activate protoc_plugin
```

Add to your PATH (if not already):
```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### Generate Dart Code from .proto Files

Run this command from the project root:

```bash
protoc --dart_out=grpc:lib/data/grpc/generated -Iprotos protos/*.proto
```

This will generate Dart files in `lib/data/grpc/generated/`

### Example Proto File Structure

```proto
syntax = "proto3";

package hvac.v1;

option dart_package = "hvac_control.grpc";

// Service definition
service HvacService {
  rpc GetDevices(GetDevicesRequest) returns (GetDevicesResponse);
  rpc UpdateDeviceState(UpdateDeviceStateRequest) returns (Device);
}

// Message definitions
message Device {
  string id = 1;
  string name = 2;
  bool power = 3;
  double current_temp = 4;
  double target_temp = 5;
  string mode = 6;
}

message GetDevicesRequest {}

message GetDevicesResponse {
  repeated Device devices = 1;
}

message UpdateDeviceStateRequest {
  string device_id = 1;
  bool power = 2;
  double target_temp = 3;
}
```

## Project Structure

```
protos/
├── hvac_service.proto      # HVAC device management
├── auth_service.proto       # Authentication
└── README.md               # This file

lib/data/grpc/
├── generated/              # Auto-generated from .proto
│   ├── hvac_service.pb.dart
│   ├── hvac_service.pbgrpc.dart
│   └── ...
├── grpc_client.dart        # gRPC client wrapper
└── services/               # Service implementations
    ├── hvac_grpc_service.dart
    └── auth_grpc_service.dart
```

## Notes

- `.proto` files should be committed to version control
- Generated `.pb.dart` and `.pbgrpc.dart` files should be in `.gitignore`
- Run generation command whenever `.proto` files are updated
- Backend team should provide the `.proto` files or keep them in sync
