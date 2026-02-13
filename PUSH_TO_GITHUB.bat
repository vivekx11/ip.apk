@echo off
echo ========================================
echo   GitHub Pe Backend Push Karo
echo ========================================
echo.

cd backend

echo [1/7] Git initialize kar rahe hain...
git init
echo.

echo [2/7] Files add kar rahe hain...
git add .
echo.

echo [3/7] Commit kar rahe hain...
git commit -m "Initial backend setup with MongoDB and Cloudinary"
echo.

echo [4/7] GitHub repository add kar rahe hain...
git remote add origin https://github.com/vivekx11/marketplace-backend.git
echo.

echo [5/7] Branch set kar rahe hain...
git branch -M main
echo.

echo [6/7] GitHub pe push kar rahe hain...
echo.
echo IMPORTANT: GitHub credentials maangega
echo Username: vivekx11
echo Password: Personal Access Token (https://github.com/settings/tokens)
echo.
git push -u origin main
echo.

echo [7/7] Done!
echo.
echo ========================================
echo   GitHub Push Complete!
echo ========================================
echo.
echo Check karo: https://github.com/vivekx11/marketplace-backend
echo.
pause
