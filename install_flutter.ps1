# Flutter Installation Script for Windows
# This script will download and install Flutter SDK

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Flutter SDK Installation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "WARNING: Not running as Administrator." -ForegroundColor Yellow
    Write-Host "Some features may not work. Consider running as Administrator." -ForegroundColor Yellow
    Write-Host ""
}

# Configuration
$flutterVersion = "3.24.5"
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_$flutterVersion-stable.zip"
$installPath = "C:\src"
$flutterPath = "$installPath\flutter"
$downloadPath = "$env:TEMP\flutter_windows.zip"

# Create installation directory
Write-Host "[1/6] Creating installation directory..." -ForegroundColor Green
if (-not (Test-Path $installPath)) {
    New-Item -ItemType Directory -Path $installPath -Force | Out-Null
    Write-Host "      Created: $installPath" -ForegroundColor Gray
} else {
    Write-Host "      Directory already exists: $installPath" -ForegroundColor Gray
}

# Check if Flutter already exists
if (Test-Path $flutterPath) {
    Write-Host ""
    Write-Host "Flutter is already installed at: $flutterPath" -ForegroundColor Yellow
    $response = Read-Host "Do you want to reinstall? (y/n)"
    if ($response -ne 'y') {
        Write-Host "Installation cancelled." -ForegroundColor Yellow
        exit
    }
    Write-Host "Removing existing installation..." -ForegroundColor Yellow
    Remove-Item -Path $flutterPath -Recurse -Force
}

# Download Flutter
Write-Host ""
Write-Host "[2/6] Downloading Flutter SDK..." -ForegroundColor Green
Write-Host "      URL: $flutterUrl" -ForegroundColor Gray
Write-Host "      This may take several minutes (700+ MB)..." -ForegroundColor Gray

try {
    # Use faster download method
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($flutterUrl, $downloadPath)
    Write-Host "      Download completed!" -ForegroundColor Gray
} catch {
    Write-Host "      ERROR: Failed to download Flutter" -ForegroundColor Red
    Write-Host "      $_" -ForegroundColor Red
    exit 1
}

# Extract Flutter
Write-Host ""
Write-Host "[3/6] Extracting Flutter SDK..." -ForegroundColor Green
Write-Host "      This may take a few minutes..." -ForegroundColor Gray

try {
    Expand-Archive -Path $downloadPath -DestinationPath $installPath -Force
    Write-Host "      Extraction completed!" -ForegroundColor Gray
} catch {
    Write-Host "      ERROR: Failed to extract Flutter" -ForegroundColor Red
    Write-Host "      $_" -ForegroundColor Red
    exit 1
}

# Clean up download
Write-Host ""
Write-Host "[4/6] Cleaning up..." -ForegroundColor Green
Remove-Item -Path $downloadPath -Force
Write-Host "      Temporary files removed" -ForegroundColor Gray

# Add to PATH
Write-Host ""
Write-Host "[5/6] Adding Flutter to PATH..." -ForegroundColor Green

$flutterBinPath = "$flutterPath\bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($userPath -notlike "*$flutterBinPath*") {
    try {
        [Environment]::SetEnvironmentVariable(
            "Path",
            "$userPath;$flutterBinPath",
            "User"
        )
        Write-Host "      Flutter added to User PATH" -ForegroundColor Gray
        Write-Host "      You may need to restart your terminal/IDE" -ForegroundColor Yellow
    } catch {
        Write-Host "      WARNING: Could not add to PATH automatically" -ForegroundColor Yellow
        Write-Host "      Please add manually: $flutterBinPath" -ForegroundColor Yellow
    }
} else {
    Write-Host "      Flutter is already in PATH" -ForegroundColor Gray
}

# Update current session PATH
$env:Path += ";$flutterBinPath"

# Run Flutter Doctor
Write-Host ""
Write-Host "[6/6] Running Flutter Doctor..." -ForegroundColor Green
Write-Host ""

& "$flutterBinPath\flutter.bat" doctor

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Flutter installed at: $flutterPath" -ForegroundColor Green
Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Restart your terminal/PowerShell/IDE" -ForegroundColor White
Write-Host "2. Verify installation: flutter --version" -ForegroundColor White
Write-Host "3. Navigate to project: cd '$PSScriptRoot'" -ForegroundColor White
Write-Host "4. Install dependencies: flutter pub get" -ForegroundColor White
Write-Host "5. Run the app: flutter run" -ForegroundColor White
Write-Host ""
Write-Host "For more info, see SETUP_GUIDE.md" -ForegroundColor Gray
Write-Host ""
