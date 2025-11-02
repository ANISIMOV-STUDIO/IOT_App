@echo off
echo ========================================
echo Re-enabling new agent files
echo ========================================
echo.

REM Re-enable auth files
if exist "lib\presentation\bloc\auth\secure_auth_bloc.dart.disabled" (
    ren "lib\presentation\bloc\auth\secure_auth_bloc.dart.disabled" "secure_auth_bloc.dart"
    echo [OK] Enabled secure_auth_bloc.dart
)

if exist "lib\presentation\pages\secure_login_screen.dart.disabled" (
    ren "lib\presentation\pages\secure_login_screen.dart.disabled" "secure_login_screen.dart"
    echo [OK] Enabled secure_login_screen.dart
)

REM Re-enable refactored DI
if exist "lib\core\di\injection_container_refactored.dart.disabled" (
    ren "lib\core\di\injection_container_refactored.dart.disabled" "injection_container_refactored.dart"
    echo [OK] Enabled injection_container_refactored.dart
)

if exist "lib\core\di\secure_injection_container.dart.disabled" (
    ren "lib\core\di\secure_injection_container.dart.disabled" "secure_injection_container.dart"
    echo [OK] Enabled secure_injection_container.dart
)

REM Re-enable refactored BLoCs
if exist "lib\presentation\bloc\auth\auth_bloc_refactored.dart.disabled" (
    ren "lib\presentation\bloc\auth\auth_bloc_refactored.dart.disabled" "auth_bloc_refactored.dart"
    echo [OK] Enabled auth_bloc_refactored.dart
)

if exist "lib\presentation\bloc\hvac_list\hvac_list_bloc_refactored.dart.disabled" (
    ren "lib\presentation\bloc\hvac_list\hvac_list_bloc_refactored.dart.disabled" "hvac_list_bloc_refactored.dart"
    echo [OK] Enabled hvac_list_bloc_refactored.dart
)

REM Re-enable new repositories
if exist "lib\data\repositories\auth_repository_impl.dart.disabled" (
    ren "lib\data\repositories\auth_repository_impl.dart.disabled" "auth_repository_impl.dart"
    echo [OK] Enabled auth_repository_impl.dart
)

if exist "lib\data\repositories\device_repository_impl.dart.disabled" (
    ren "lib\data\repositories\device_repository_impl.dart.disabled" "device_repository_impl.dart"
    echo [OK] Enabled device_repository_impl.dart
)

REM Re-enable optimized widgets
if exist "lib\presentation\widgets\optimized.disabled" (
    ren "lib\presentation\widgets\optimized.disabled" "optimized"
    echo [OK] Enabled optimized folder
)

if exist "lib\presentation\widgets\home\home_states_enhanced.dart.disabled" (
    ren "lib\presentation\widgets\home\home_states_enhanced.dart.disabled" "home_states_enhanced.dart"
    echo [OK] Enabled home_states_enhanced.dart
)

if exist "lib\presentation\pages\schedule_screen_enhanced.dart.disabled" (
    ren "lib\presentation\pages\schedule_screen_enhanced.dart.disabled" "schedule_screen_enhanced.dart"
    echo [OK] Enabled schedule_screen_enhanced.dart
)

REM Re-enable secure services
if exist "lib\core\services\secure_api_service.dart.disabled" (
    ren "lib\core\services\secure_api_service.dart.disabled" "secure_api_service.dart"
    echo [OK] Enabled secure_api_service.dart
)

if exist "lib\core\services\secure_storage_service.dart.disabled" (
    ren "lib\core\services\secure_storage_service.dart.disabled" "secure_storage_service.dart"
    echo [OK] Enabled secure_storage_service.dart
)

if exist "lib\core\services\environment_config.dart.disabled" (
    ren "lib\core\services\environment_config.dart.disabled" "environment_config.dart"
    echo [OK] Enabled environment_config.dart
)

REM Re-enable use cases
if exist "lib\domain\usecases.disabled" (
    ren "lib\domain\usecases.disabled" "usecases"
    echo [OK] Enabled usecases folder
)

if exist "lib\domain\repositories.disabled" (
    ren "lib\domain\repositories.disabled" "repositories"
    echo [OK] Enabled repositories folder
)

REM Re-enable tests
if exist "test.disabled" (
    ren "test.disabled" "test"
    echo [OK] Enabled test folder
)

echo.
echo ========================================
echo Done! Files are re-enabled
echo You can now work on gradual migration
echo ========================================
pause
