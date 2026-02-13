@echo off
echo ========================================
echo Building Production APKs
echo ========================================
echo.

echo Building User App...
cd user_app
call flutter clean
call flutter pub get
call flutter build apk --release
cd ..
echo.
echo User App APK built at: user_app\build\app\outputs\flutter-apk\app-release.apk
echo.

echo Building Shop Owner App...
cd shop_owner_app
call flutter clean
call flutter pub get
call flutter build apk --release
cd ..
echo.
echo Shop Owner App APK built at: shop_owner_app\build\app\outputs\flutter-apk\app-release.apk
echo.

echo ========================================
echo Build Complete!
echo ========================================
echo.
echo APK Locations:
echo 1. User App: user_app\build\app\outputs\flutter-apk\app-release.apk
echo 2. Shop Owner App: shop_owner_app\build\app\outputs\flutter-apk\app-release.apk
echo.
echo You can now install these APKs on Android devices!
echo.
pause
