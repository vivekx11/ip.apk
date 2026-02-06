@echo off
echo ========================================
echo Firebase OTP Setup for User App
echo ========================================
echo.

echo Step 1: Cleaning previous builds...
call flutter clean
echo.

echo Step 2: Getting dependencies...
call flutter pub get
echo.

echo Step 3: Generating SHA-1 fingerprint for Firebase...
echo.
echo IMPORTANT: Copy the SHA-1 fingerprint from the output below
echo and add it to your Firebase Console:
echo 1. Go to https://console.firebase.google.com/
echo 2. Select your project: local-marketplace-demo
echo 3. Go to Project Settings > Your apps > Android app
echo 4. Scroll to "SHA certificate fingerprints"
echo 5. Click "Add fingerprint" and paste the SHA-1 hash
echo.

cd android
call gradlew signingReport
cd ..

echo.
echo Step 4: Building the app...
call flutter build apk --debug

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Add the SHA-1 fingerprint to Firebase Console (see above)
echo 2. Enable Phone Authentication in Firebase Console:
echo    - Go to Authentication > Sign-in method
echo    - Enable "Phone" provider
echo 3. Test the app with a real phone number
echo.
echo If you still have issues, check the console logs for detailed error messages.
echo.
pause