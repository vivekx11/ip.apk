@echo off
echo ========================================
echo   Marketplace System - ngrok Setup
echo ========================================
echo.

echo Step 1: Starting Backend...
start "Backend Server" cmd /k "cd backend && npm start"
timeout /t 3 /nobreak >nul

echo.
echo Step 2: Starting ngrok...
echo.
echo ⚠️  IMPORTANT: Copy the ngrok URL that appears!
echo    It will look like: https://abc123.ngrok.io
echo.
echo Then:
echo 1. Update user_app/lib/core/constants/app_constants.dart
echo 2. Update shop_owner_app/lib/services/api_service.dart
echo 3. Change baseUrl to: https://YOUR-NGROK-URL.ngrok.io/api
echo 4. Rebuild both apps
echo.
pause

start "ngrok" cmd /k "ngrok http 3001"

echo.
echo ========================================
echo   Both services are running!
echo ========================================
echo.
echo Backend: http://localhost:3001
echo ngrok: Check the ngrok window for your public URL
echo.
echo Next steps:
echo 1. Copy the ngrok HTTPS URL
echo 2. Update API URLs in both apps
echo 3. Run: build_all_release.bat
echo.
pause