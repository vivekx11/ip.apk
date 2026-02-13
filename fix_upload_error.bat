@echo off
echo ========================================
echo Fixing Product Upload Error
echo ========================================
echo.

cd shop_owner_app

echo Step 1: Cleaning Flutter project...
call flutter clean

echo.
echo Step 2: Getting dependencies...
call flutter pub get

echo.
echo Step 3: Building release APK...
call flutter build apk --release

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo.
echo APK Location: shop_owner_app\build\app\outputs\flutter-apk\app-release.apk
echo.
echo Next Steps:
echo 1. Install the new APK on your phone
echo 2. Try uploading a product
echo 3. The error message will now be more specific
echo.
echo If you still see an error, note the exact message and share it!
echo.
pause
