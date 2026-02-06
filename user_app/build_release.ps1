Write-Host "========================================" -ForegroundColor Green
Write-Host "Building Release APK for User App" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Step 1: Cleaning previous builds..." -ForegroundColor Yellow
flutter clean
Write-Host ""

Write-Host "Step 2: Getting dependencies..." -ForegroundColor Yellow
flutter pub get
Write-Host ""

Write-Host "Step 3: Building release APK..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Cyan
flutter build apk --release

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Release APK location:" -ForegroundColor Yellow
Write-Host "build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
Write-Host ""

if (Test-Path "build\app\outputs\flutter-apk\app-release.apk") {
    $fileSize = (Get-Item "build\app\outputs\flutter-apk\app-release.apk").Length
    Write-Host "File size: $([math]::Round($fileSize/1MB, 2)) MB" -ForegroundColor Cyan
} else {
    Write-Host "APK file not found. Build may have failed." -ForegroundColor Red
}

Write-Host ""
Write-Host "You can now install this APK on any Android device." -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to continue"