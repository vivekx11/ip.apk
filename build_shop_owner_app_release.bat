@echo off
echo Building Shop Owner App Release...
cd shop_owner_app
call flutter clean
call flutter pub get
call flutter build apk --release
echo Shop Owner App APK built successfully!
echo Location: build\app\outputs\flutter-apk\app-release.apk
pause