@echo off
echo ========================================
echo   Starting Backend Server
echo ========================================
echo.

cd backend

if not exist node_modules (
    echo ERROR: Dependencies not installed!
    echo Please run setup_backend.bat first
    pause
    exit /b 1
)

if not exist .env (
    echo ERROR: .env file not found!
    echo Please copy .env.example to .env and configure it
    pause
    exit /b 1
)

echo Starting server...
echo.
echo Press Ctrl+C to stop the server
echo.

npm start
