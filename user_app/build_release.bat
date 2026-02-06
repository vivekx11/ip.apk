@echo off
echo ========================================
echo Building Release APK for User App
echo ========================================
echo.

echo Step 1: Cleaning previous builds...
call flutter clean
echo.

echo Step 2: Getting dependencies...
call flutter pub get
echo.

echo Step 3: Building release APK...
echo This may take a few minutes...
call flutter build apk --release

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo.
echo Release APK location:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
echo File size:
for %%I in (build\app\outputs\flutter-apk\app-release.apk) do echo %%~zI bytes
echo.
echo You can now install this APK on any Android device.
echo.
pause