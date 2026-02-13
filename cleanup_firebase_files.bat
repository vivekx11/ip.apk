@echo off
echo ========================================
echo   Firebase Files Cleanup Script
echo ========================================
echo.
echo This script will delete Firebase-related files
echo from both Flutter apps.
echo.
echo WARNING: This action cannot be undone!
echo.
pause

echo.
echo Cleaning Shop Owner App...
echo.

if exist "shop_owner_app\lib\firebase_options.dart" (
    del "shop_owner_app\lib\firebase_options.dart"
    echo   ✓ Deleted firebase_options.dart
) else (
    echo   - firebase_options.dart not found
)

if exist "shop_owner_app\android\app\google-services.json" (
    del "shop_owner_app\android\app\google-services.json"
    echo   ✓ Deleted google-services.json
) else (
    echo   - google-services.json not found
)

if exist "shop_owner_app\lib\services\firebase_service.dart" (
    del "shop_owner_app\lib\services\firebase_service.dart"
    echo   ✓ Deleted firebase_service.dart
) else (
    echo   - firebase_service.dart not found
)

if exist "shop_owner_app\lib\services\photo_upload_service.dart" (
    del "shop_owner_app\lib\services\photo_upload_service.dart"
    echo   ✓ Deleted photo_upload_service.dart (old Firebase version)
) else (
    echo   - photo_upload_service.dart not found
)

echo.
echo Cleaning User App...
echo.

if exist "user_app\lib\firebase_options.dart" (
    del "user_app\lib\firebase_options.dart"
    echo   ✓ Deleted firebase_options.dart
) else (
    echo   - firebase_options.dart not found
)

if exist "user_app\android\app\google-services.json" (
    del "user_app\android\app\google-services.json"
    echo   ✓ Deleted google-services.json
) else (
    echo   - google-services.json not found
)

if exist "user_app\lib\services\firebase_service.dart" (
    del "user_app\lib\services\firebase_service.dart"
    echo   ✓ Deleted firebase_service.dart
) else (
    echo   - firebase_service.dart not found
)

echo.
echo ========================================
echo   Cleanup Complete!
echo ========================================
echo.
echo Next steps:
echo   1. Update pubspec.yaml files to remove Firebase dependencies
echo   2. Run 'flutter clean' in both apps
echo   3. Run 'flutter pub get' in both apps
echo   4. Update main.dart files to remove Firebase initialization
echo.
echo See FIREBASE_REMOVAL_GUIDE.md for detailed instructions.
echo.
pause
