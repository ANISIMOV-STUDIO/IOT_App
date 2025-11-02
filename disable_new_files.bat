@echo off
echo ========================================
echo Temporarily disabling new agent files
echo to allow app to compile
echo ========================================
echo.

REM Disable new auth files
if exist "lib\presentation\bloc\auth\secure_auth_bloc.dart" (
    ren "lib\presentation\bloc\auth\secure_auth_bloc.dart" "secure_auth_bloc.dart.disabled"
    echo [OK] Disabled secure_auth_bloc.dart
)

if exist "lib\presentation\pages\secure_login_screen.dart" (
    ren "lib\presentation\pages\secure_login_screen.dart" "secure_login_screen.dart.disabled"
    echo [OK] Disabled secure_login_screen.dart
)

REM Disable refactored DI
if exist "lib\core\di\injection_container_refactored.dart" (
    ren "lib\core\di\injection_container_refactored.dart" "injection_container_refactored.dart.disabled"
    echo [OK] Disabled injection_container_refactored.dart
)

if exist "lib\core\di\secure_injection_container.dart" (
    ren "lib\core\di\secure_injection_container.dart" "secure_injection_container.dart.disabled"
    echo [OK] Disabled secure_injection_container.dart
)

REM Disable refactored BLoCs
if exist "lib\presentation\bloc\auth\auth_bloc_refactored.dart" (
    ren "lib\presentation\bloc\auth\auth_bloc_refactored.dart" "auth_bloc_refactored.dart.disabled"
    echo [OK] Disabled auth_bloc_refactored.dart
)

if exist "lib\presentation\bloc\hvac_list\hvac_list_bloc_refactored.dart" (
    ren "lib\presentation\bloc\hvac_list\hvac_list_bloc_refactored.dart" "hvac_list_bloc_refactored.dart.disabled"
    echo [OK] Disabled hvac_list_bloc_refactored.dart
)

REM Disable new repositories
if exist "lib\data\repositories\auth_repository_impl.dart" (
    ren "lib\data\repositories\auth_repository_impl.dart" "auth_repository_impl.dart.disabled"
    echo [OK] Disabled auth_repository_impl.dart
)

if exist "lib\data\repositories\device_repository_impl.dart" (
    ren "lib\data\repositories\device_repository_impl.dart" "device_repository_impl.dart.disabled"
    echo [OK] Disabled device_repository_impl.dart
)

REM Disable optimized widgets with errors
if exist "lib\presentation\widgets\optimized" (
    ren "lib\presentation\widgets\optimized" "optimized.disabled"
    echo [OK] Disabled optimized folder
)

if exist "lib\presentation\widgets\home\home_states_enhanced.dart" (
    ren "lib\presentation\widgets\home\home_states_enhanced.dart" "home_states_enhanced.dart.disabled"
    echo [OK] Disabled home_states_enhanced.dart
)

if exist "lib\presentation\pages\schedule_screen_enhanced.dart" (
    ren "lib\presentation\pages\schedule_screen_enhanced.dart" "schedule_screen_enhanced.dart.disabled"
    echo [OK] Disabled schedule_screen_enhanced.dart
)

REM Disable secure services
if exist "lib\core\services\secure_api_service.dart" (
    ren "lib\core\services\secure_api_service.dart" "secure_api_service.dart.disabled"
    echo [OK] Disabled secure_api_service.dart
)

if exist "lib\core\services\secure_storage_service.dart" (
    ren "lib\core\services\secure_storage_service.dart" "secure_storage_service.dart.disabled"
    echo [OK] Disabled secure_storage_service.dart
)

if exist "lib\core\services\environment_config.dart" (
    ren "lib\core\services\environment_config.dart" "environment_config.dart.disabled"
    echo [OK] Disabled environment_config.dart
)

REM Disable use cases
if exist "lib\domain\usecases" (
    ren "lib\domain\usecases" "usecases.disabled"
    echo [OK] Disabled usecases folder
)

if exist "lib\domain\repositories" (
    ren "lib\domain\repositories" "repositories.disabled"
    echo [OK] Disabled repositories folder
)

REM Disable tests
if exist "test" (
    ren "test" "test.disabled"
    echo [OK] Disabled test folder
)

echo.
echo ========================================
echo Done! Problematic files are now disabled
echo Try running: flutter run
echo ========================================
echo.
echo To re-enable files later, run: enable_new_files.bat
pause
