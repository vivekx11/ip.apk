Write-Host "========================================" -ForegroundColor Green
Write-Host "Firebase OTP Setup for User App" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Step 1: Cleaning previous builds..." -ForegroundColor Yellow
flutter clean
Write-Host ""

Write-Host "Step 2: Getting dependencies..." -ForegroundColor Yellow
flutter pub get
Write-Host ""

Write-Host "Step 3: Generating SHA-1 fingerprint for Firebase..." -ForegroundColor Yellow
Write-Host ""
Write-Host "IMPORTANT: Copy the SHA-1 fingerprint from the output below" -ForegroundColor Red
Write-Host "and add it to your Firebase Console:" -ForegroundColor Red
Write-Host "1. Go to https://console.firebase.google.com/" -ForegroundColor Cyan
Write-Host "2. Select your project: local-marketplace-demo" -ForegroundColor Cyan
Write-Host "3. Go to Project Settings > Your apps > Android app" -ForegroundColor Cyan
Write-Host "4. Scroll to 'SHA certificate fingerprints'" -ForegroundColor Cyan
Write-Host "5. Click 'Add fingerprint' and paste the SHA-1 hash" -ForegroundColor Cyan
Write-Host ""

Set-Location android
./gradlew signingReport
Set-Location ..

Write-Host ""
Write-Host "Step 4: Building the app..." -ForegroundColor Yellow
flutter build apk --debug

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Add the SHA-1 fingerprint to Firebase Console (see above)" -ForegroundColor White
Write-Host "2. Enable Phone Authentication in Firebase Console:" -ForegroundColor White
Write-Host "   - Go to Authentication > Sign-in method" -ForegroundColor White
Write-Host "   - Enable 'Phone' provider" -ForegroundColor White
Write-Host "3. Test the app with a real phone number" -ForegroundColor White
Write-Host ""
Write-Host "If you still have issues, check the console logs for detailed error messages." -ForegroundColor Magenta
Write-Host ""
Read-Host "Press Enter to continue"