@echo off
echo Generating Dart code from protobuf files...

set PROTO_DIR=protos
set OUT_DIR=lib\generated\protos

REM Create output directory
if not exist %OUT_DIR% mkdir %OUT_DIR%

REM Generate Dart code for all proto files
protoc ^
  --dart_out=grpc:%OUT_DIR% ^
  --proto_path=%PROTO_DIR% ^
  %PROTO_DIR%\common.proto ^
  %PROTO_DIR%\hvac_device.proto ^
  %PROTO_DIR%\climate.proto ^
  %PROTO_DIR%\energy.proto ^
  %PROTO_DIR%\graph_data.proto ^
  %PROTO_DIR%\schedule.proto ^
  %PROTO_DIR%\notification.proto ^
  %PROTO_DIR%\occupant.proto ^
  %PROTO_DIR%\hvac_service.proto ^
  %PROTO_DIR%\analytics_service.proto ^
  %PROTO_DIR%\schedule_service.proto ^
  %PROTO_DIR%\notification_service.proto ^
  %PROTO_DIR%\occupant_service.proto

if %ERRORLEVEL% EQU 0 (
  echo.
  echo ===============================================
  echo Proto generation complete!
  echo Generated files are in: %OUT_DIR%
  echo ===============================================
) else (
  echo.
  echo ===============================================
  echo ERROR: Proto generation failed!
  echo Make sure protoc is installed and in PATH
  echo ===============================================
)

pause
