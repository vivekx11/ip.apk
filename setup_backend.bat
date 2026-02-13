@echo off
echo ========================================
echo   Backend Setup Script
echo ========================================
echo.

cd backend

echo [1/3] Installing Node.js dependencies...
call npm install
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)
echo.

echo [2/3] Checking .env file...
if not exist .env (
    echo Creating .env file from .env.example...
    copy .env.example .env
    echo.
    echo IMPORTANT: Please edit backend\.env file and add your:
    echo   - MongoDB Atlas connection string
    echo   - Cloudinary credentials
    echo.
    pause
) else (
    echo .env file already exists
)
echo.

echo [3/3] Setup complete!
echo.
echo To start the server, run:
echo   cd backend
echo   npm start
echo.
echo Or for development mode with auto-restart:
echo   npm run dev
echo.
pause
