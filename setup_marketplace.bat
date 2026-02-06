@echo off
echo ========================================
echo    Marketplace System Setup
echo ========================================
echo.

echo [1/4] Setting up Backend...
cd backend
if not exist node_modules (
    echo Installing backend dependencies...
    npm install
) else (
    echo Backend dependencies already installed.
)

if not exist .env (
    echo Creating .env file...
    copy .env.example .env
    echo Please edit backend/.env with your MongoDB connection string
) else (
    echo .env file already exists.
)

echo.
echo [2/4] Setting up User App...
cd ..\user_app
echo Getting Flutter dependencies for User App...
call flutter pub get

echo.
echo [3/4] Setting up Shop Owner App...
cd ..\shop_owner_app
echo Getting Flutter dependencies for Shop Owner App...
call flutter pub get

echo.
echo [4/4] Setup Complete!
echo.
echo ========================================
echo    Next Steps:
echo ========================================
echo 1. Start MongoDB (if using local instance)
echo 2. Edit backend/.env with your database URL
echo 3. Start the backend server:
echo    cd backend
echo    npm run dev
echo.
echo 4. Build and run the Flutter apps:
echo    cd user_app
echo    flutter run
echo.
echo    cd shop_owner_app  
echo    flutter run
echo.
echo ========================================
echo    API Endpoints:
echo ========================================
echo Backend API: http://localhost:3000/api
echo Health Check: http://localhost:3000/api/health
echo.
pause