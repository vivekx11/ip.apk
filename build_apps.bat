@echo off
echo Building Local Marketplace Apps...
echo.

echo ================================
echo Building User App (Pink Theme)
echo ================================
cd user_app
call flutter clean
call flutter pub get
call flutter build apk --release
if %ERRORLEVEL% EQU 0 (
    echo ✅ User App built successfully!
    echo APK location: user_app\build\app\outputs\flutter-apk\app-release.apk
) else (
    echo ❌ User App build failed!
)
cd ..
echo.

echo ================================
echo Building Shop Owner App (Indigo Theme)
echo ================================
cd shop_owner_app
call flutter clean
call flutter pub get
call flutter build apk --release
if %ERRORLEVEL% EQU 0 (
    echo ✅ Shop Owner App built successfully!
    echo APK location: shop_owner_app\build\app\outputs\flutter-apk\app-release.apk
) else (
    echo ❌ Shop Owner App build failed!
)
cd ..
echo.

echo ================================
echo Build Summary
echo ================================
echo Both marketplace apps have been processed.
echo Check the individual results above.
echo.
pause