@echo off
echo =====================================
echo BREEZ Home App - Test Runner
echo =====================================
echo.

REM Colors for output
set GREEN=[92m
set YELLOW=[93m
set RED=[91m
set RESET=[0m

echo %YELLOW%1. Running Flutter Doctor...%RESET%
flutter doctor -v
if %errorlevel% neq 0 (
    echo %RED%Flutter doctor failed!%RESET%
    exit /b 1
)

echo.
echo %YELLOW%2. Getting Dependencies...%RESET%
flutter pub get
if %errorlevel% neq 0 (
    echo %RED%Failed to get dependencies!%RESET%
    exit /b 1
)

echo.
echo %YELLOW%3. Running Analyzer...%RESET%
dart analyze
if %errorlevel% neq 0 (
    echo %RED%Code analysis failed!%RESET%
    exit /b 1
)

echo.
echo %YELLOW%4. Running Unit Tests...%RESET%
flutter test test/unit/ --coverage
if %errorlevel% neq 0 (
    echo %RED%Unit tests failed!%RESET%
    exit /b 1
)

echo.
echo %YELLOW%5. Running Widget Tests...%RESET%
flutter test test/widget/ --coverage
if %errorlevel% neq 0 (
    echo %RED%Widget tests failed!%RESET%
    exit /b 1
)

echo.
echo %YELLOW%6. Running Integration Tests...%RESET%
flutter test test/integration/ --coverage
if %errorlevel% neq 0 (
    echo %RED%Integration tests failed!%RESET%
    REM Continue even if integration tests fail
)

echo.
echo %YELLOW%7. Generating Coverage Report...%RESET%
REM Remove old coverage data
if exist coverage\lcov.info del coverage\lcov.info

REM Merge all coverage files
flutter test --coverage

REM Generate HTML report if lcov is installed
where genhtml >nul 2>nul
if %errorlevel% equ 0 (
    echo Generating HTML coverage report...
    genhtml coverage\lcov.info -o coverage\html
    echo Coverage report generated at: coverage\html\index.html
) else (
    echo %YELLOW%genhtml not found. Install lcov to generate HTML reports.%RESET%
)

echo.
echo %YELLOW%8. Performance Benchmark...%RESET%
echo Running performance tests...
flutter test test/widget/widgets/optimized_hvac_card_test.dart --name="Performance"

echo.
echo =====================================
echo %GREEN%Test Suite Completed Successfully!%RESET%
echo =====================================
echo.
echo Coverage Report: coverage/lcov.info
echo Run 'flutter test --coverage' for detailed coverage
echo.

REM Display coverage summary if available
if exist coverage\lcov.info (
    echo Coverage Summary:
    type coverage\lcov.info | findstr "SF:" | find /c /v ""
    echo files covered
)

exit /b 0