@echo off
echo Cleaning Flutter project for Windows build...
echo.

echo ================================
echo Step 1: Stopping Flutter processes
echo ================================
taskkill /f /im dart.exe >nul 2>&1
taskkill /f /im flutter.exe >nul 2>&1
taskkill /f /im java.exe >nul 2>&1
echo Processes stopped (if any were running)

echo.
echo ================================
echo Step 2: Removing build directories
echo ================================
if exist build rmdir /s /q build
if exist .dart_tool rmdir /s /q .dart_tool
if exist android\.gradle rmdir /s /q android\.gradle
echo Build directories removed

echo.
echo ================================
echo Step 3: Flutter clean
echo ================================
call flutter clean
echo Flutter clean completed

echo.
echo ================================
echo Step 4: Get dependencies
echo ================================
call flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to get dependencies
    pause
    exit /b 1
)
echo ✅ Dependencies installed

echo.
echo ================================
echo Step 5: Building APK
echo ================================
call flutter build apk --release
if %ERRORLEVEL% EQU 0 (
    echo.
    echo 🎉 BUILD SUCCESSFUL! 🎉
    echo.
    echo APK Location: build\app\outputs\flutter-apk\app-release.apk
    echo File size:
    dir build\app\outputs\flutter-apk\app-release.apk
) else (
    echo.
    echo ❌ BUILD FAILED!
    echo Try running this script again or check for antivirus interference.
)

echo.
pause