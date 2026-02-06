@echo off
echo Fixing Shop Owner App Build Issues...
echo.

echo Step 1: Closing any running processes...
taskkill /f /im "java.exe" 2>nul
taskkill /f /im "gradle.exe" 2>nul
taskkill /f /im "flutter.exe" 2>nul

echo Step 2: Waiting for file locks to release...
timeout /t 3 /nobreak >nul

echo Step 3: Attempting to clean build directory...
cd shop_owner_app
rmdir /s /q build 2>nul

echo Step 4: Running flutter clean...
flutter clean

echo Step 5: Getting dependencies...
flutter pub get

echo Step 6: Building release APK...
flutter build apk --release

echo.
if %ERRORLEVEL% EQU 0 (
    echo ✅ Shop Owner App built successfully!
    echo Location: shop_owner_app\build\app\outputs\flutter-apk\app-release.apk
) else (
    echo ❌ Build failed. Try the following:
    echo 1. Close Android Studio and any IDEs
    echo 2. Restart your computer
    echo 3. Run this script again
)

pause