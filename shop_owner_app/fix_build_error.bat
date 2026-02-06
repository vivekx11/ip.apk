@echo off
echo ========================================
echo Fixing Shop Owner App Build Error
echo ========================================
echo.

echo Step 1: Stopping any running processes...
taskkill /f /im "java.exe" 2>nul
taskkill /f /im "gradle.exe" 2>nul
taskkill /f /im "flutter.exe" 2>nul
echo.

echo Step 2: Cleaning build directory...
rmdir /s /q build 2>nul
echo.

echo Step 3: Flutter clean...
flutter clean
echo.

echo Step 4: Getting dependencies...
flutter pub get
echo.

echo Step 5: Building release APK...
flutter build apk --release

echo.
echo ========================================
echo Build process completed!
echo ========================================
pause