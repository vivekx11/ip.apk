@echo off
echo Testing User App Build...
echo.

echo ================================
echo Step 1: Clean Project
echo ================================
call flutter clean
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Clean failed!
    pause
    exit /b 1
)
echo ✅ Clean successful

echo.
echo ================================
echo Step 2: Get Dependencies
echo ================================
call flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Dependencies failed!
    pause
    exit /b 1
)
echo ✅ Dependencies installed

echo.
echo ================================
echo Step 3: Check for Compilation Issues
echo ================================
call flutter analyze
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️ Analysis found issues (may still build)
) else (
    echo ✅ Analysis passed
)

echo.
echo ================================
echo Step 4: Build APK
echo ================================
call flutter build apk --release
if %ERRORLEVEL% EQU 0 (
    echo.
    echo 🎉 BUILD SUCCESSFUL! 🎉
    echo.
    echo APK Location: build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo You can now install this APK on your Android device.
) else (
    echo.
    echo ❌ BUILD FAILED!
    echo Check the error messages above for details.
)

echo.
pause