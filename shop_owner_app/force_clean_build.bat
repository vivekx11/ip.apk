@echo off
echo ========================================
echo Force Clean and Build Shop Owner App
echo ========================================
echo.

echo Stopping any running Gradle daemons...
call gradlew --stop 2>nul
cd android
call gradlew --stop 2>nul
cd ..

echo.
echo Waiting for processes to release files...
timeout /t 3 /nobreak >nul

echo.
echo Deleting build folder...
rmdir /s /q build 2>nul

echo.
echo Running Flutter clean...
call flutter clean

echo.
echo Waiting...
timeout /t 2 /nobreak >nul

echo.
echo Getting dependencies...
call flutter pub get

echo.
echo Building release APK...
call flutter build apk --release

echo.
echo ========================================
echo Done!
echo ========================================
pause
