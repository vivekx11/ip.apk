@echo off
echo Building User App Release...
cd user_app
call flutter clean
call flutter pub get
call flutter build apk --release
echo User App APK built successfully!
echo Location: build\app\outputs\flutter-apk\app-release.apk
pause