@echo off
echo Building All Apps for Release...

echo.
echo ========================================
echo Building User App...
echo ========================================
cd user_app
call flutter clean
call flutter pub get
call flutter build apk --release
cd ..

echo.
echo ========================================
echo Building Shop Owner App...
echo ========================================
cd shop_owner_app
call flutter clean
call flutter pub get
call flutter build apk --release
cd ..

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo User App APK: user_app\build\app\outputs\flutter-apk\app-release.apk
echo Shop Owner App APK: shop_owner_app\build\app\outputs\flutter-apk\app-release.apk
pause