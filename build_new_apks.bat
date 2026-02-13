@echo off
echo ========================================
echo Building New APKs - Simple System
echo ========================================
echo.

echo Step 1: Building Shop Owner App...
cd shop_owner_app
call flutter clean
call flutter pub get
call flutter build apk --release
echo.
echo Shop Owner APK ready at: shop_owner_app\build\app\outputs\flutter-apk\app-release.apk
echo.

echo Step 2: Building User App...
cd ..\user_app
call flutter clean
call flutter pub get  
call flutter build apk --release
echo.
echo User APK ready at: user_app\build\app\outputs\flutter-apk\app-release.apk
echo.

echo ========================================
echo Both APKs Built Successfully!
echo ========================================
echo.
echo Install karo phone mein aur test karo!
pause
