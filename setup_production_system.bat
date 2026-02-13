@echo off
echo ========================================
echo Production-Ready Marketplace Setup
echo ========================================
echo.

echo Step 1: Cleaning User App...
cd user_app
call flutter clean
call flutter pub get
cd ..
echo User App cleaned and dependencies installed!
echo.

echo Step 2: Cleaning Shop Owner App...
cd shop_owner_app
call flutter clean
call flutter pub get
cd ..
echo Shop Owner App cleaned and dependencies installed!
echo.

echo Step 3: Installing Backend Dependencies...
cd backend
call npm install
cd ..
echo Backend dependencies installed!
echo.

echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next Steps:
echo 1. Make sure Firebase Storage is enabled
echo 2. Update Firebase Storage rules (see PRODUCTION_READY_GUIDE.md)
echo 3. Start backend: cd backend && npm start
echo 4. Run user app: cd user_app && flutter run
echo 5. Run shop owner app: cd shop_owner_app && flutter run
echo.
echo For detailed instructions, see:
echo - PRODUCTION_READY_GUIDE.md
echo - QUICK_FIX_IMPLEMENTATION.md
echo.
pause
