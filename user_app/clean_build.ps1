# PowerShell script to clean and build Flutter app
Write-Host "🧹 Cleaning Flutter project for Windows build..." -ForegroundColor Cyan
Write-Host ""

Write-Host "================================" -ForegroundColor Yellow
Write-Host "Step 1: Stopping Flutter processes" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow

# Stop Flutter processes
Get-Process -Name "dart" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name "flutter" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host "✅ Processes stopped (if any were running)" -ForegroundColor Green

Write-Host ""
Write-Host "================================" -ForegroundColor Yellow
Write-Host "Step 2: Removing build directories" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow

# Remove build directories
if (Test-Path "build") { Remove-Item -Recurse -Force "build" -ErrorAction SilentlyContinue }
if (Test-Path ".dart_tool") { Remove-Item -Recurse -Force ".dart_tool" -ErrorAction SilentlyContinue }
if (Test-Path "android\.gradle") { Remove-Item -Recurse -Force "android\.gradle" -ErrorAction SilentlyContinue }
Write-Host "✅ Build directories removed" -ForegroundColor Green

Write-Host ""
Write-Host "================================" -ForegroundColor Yellow
Write-Host "Step 3: Flutter clean" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow

flutter clean
Write-Host "✅ Flutter clean completed" -ForegroundColor Green

Write-Host ""
Write-Host "================================" -ForegroundColor Yellow
Write-Host "Step 4: Get dependencies" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow

flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to get dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "✅ Dependencies installed" -ForegroundColor Green

Write-Host ""
Write-Host "================================" -ForegroundColor Yellow
Write-Host "Step 5: Building APK" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow

flutter build apk --release
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "🎉 BUILD SUCCESSFUL! 🎉" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK Location: build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Cyan
    
    if (Test-Path "build\app\outputs\flutter-apk\app-release.apk") {
        $fileSize = (Get-Item "build\app\outputs\flutter-apk\app-release.apk").Length / 1MB
        Write-Host "File size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Cyan
    }
} else {
    Write-Host ""
    Write-Host "❌ BUILD FAILED!" -ForegroundColor Red
    Write-Host "Try running this script again or check for antivirus interference." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit"