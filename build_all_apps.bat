@echo off
echo ========================================
echo Building All Marketplace Apps
echo ========================================
echo.

echo Building User App...
cd user_app
call flutter clean
call flutter pub get
call flutter build apk --release
cd ..
echo User App build complete!
echo.

echo Building Shop Owner App...
cd shop_owner_app
call flutter clean
call flutter pub get
call flutter build apk --release
cd ..
echo Shop Owner App build complete!
echo.

echo ========================================
echo All Apps Built Successfully!
echo ========================================
echo.
echo APK Locations:
echo - User App: user_app\build\app\outputs\flutter-apk\app-release.apk
echo - Shop Owner App: shop_owner_app\build\app\outputs\flutter-apk\app-release.apk
echo.
pause