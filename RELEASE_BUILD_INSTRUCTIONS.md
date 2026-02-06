# Release Build Instructions

This guide explains how to build release versions of both the User App and Shop Owner App.

## Prerequisites

1. **Flutter SDK** - Ensure Flutter is installed and up to date
2. **Android Studio** - For Android builds
3. **Xcode** - For iOS builds (macOS only)
4. **Firebase Project** - Both apps require Firebase configuration
5. **Backend Server** - Ensure your backend is running and accessible

## Pre-Build Setup

### 1. Install Dependencies

For both apps, run:
```bash
cd user_app
flutter pub get

cd ../shop_owner_app
flutter pub get
```

### 2. Firebase Configuration

Ensure both apps have proper Firebase configuration:
- `user_app/android/app/google-services.json`
- `user_app/ios/Runner/GoogleService-Info.plist`
- `shop_owner_app/android/app/google-services.json`
- `shop_owner_app/ios/Runner/GoogleService-Info.plist`

### 3. Update API Endpoints

Update the base URLs in:
- `user_app/lib/core/constants/app_constants.dart`
- `shop_owner_app/lib/services/api_service.dart`

Change from `http://localhost:3001/api` to your production server URL.

### 4. App Signing (Android)

Create signing keys for both apps:

```bash
# For User App
keytool -genkey -v -keystore user_app/android/app/user-app-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias user-app

# For Shop Owner App
keytool -genkey -v -keystore shop_owner_app/android/app/shop-owner-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias shop-owner
```

Create `android/key.properties` files for each app:

**user_app/android/key.properties:**
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=user-app
storeFile=user-app-key.jks
```

**shop_owner_app/android/key.properties:**
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=shop-owner
storeFile=shop-owner-key.jks
```

## Building Release APKs

### User App
```bash
cd user_app
flutter clean
flutter pub get
flutter build apk --release
```

The APK will be generated at: `user_app/build/app/outputs/flutter-apk/app-release.apk`

### Shop Owner App
```bash
cd shop_owner_app
flutter clean
flutter pub get
flutter build apk --release
```

The APK will be generated at: `shop_owner_app/build/app/outputs/flutter-apk/app-release.apk`

## Building App Bundles (for Google Play Store)

### User App
```bash
cd user_app
flutter build appbundle --release
```

### Shop Owner App
```bash
cd shop_owner_app
flutter build appbundle --release
```

## Building for iOS

### User App
```bash
cd user_app
flutter build ios --release
```

### Shop Owner App
```bash
cd shop_owner_app
flutter build ios --release
```

Then open the iOS project in Xcode to archive and distribute.

## Automated Build Scripts

### Windows Batch Scripts

**build_user_app_release.bat:**
```batch
@echo off
echo Building User App Release...
cd user_app
call flutter clean
call flutter pub get
call flutter build apk --release
echo User App APK built successfully!
echo Location: build\app\outputs\flutter-apk\app-release.apk
pause
```

**build_shop_owner_app_release.bat:**
```batch
@echo off
echo Building Shop Owner App Release...
cd shop_owner_app
call flutter clean
call flutter pub get
call flutter build apk --release
echo Shop Owner App APK built successfully!
echo Location: build\app\outputs\flutter-apk\app-release.apk
pause
```

**build_all_release.bat:**
```batch
@echo off
echo Building All Apps for Release...

echo.
echo ========================================
echo Building User App...
echo ========================================
cd user_app
call flutter clean
call flutter pub get
call flutter build apk --release
cd ..

echo.
echo ========================================
echo Building Shop Owner App...
echo ========================================
cd shop_owner_app
call flutter clean
call flutter pub get
call flutter build apk --release
cd ..

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo User App APK: user_app\build\app\outputs\flutter-apk\app-release.apk
echo Shop Owner App APK: shop_owner_app\build\app\outputs\flutter-apk\app-release.apk
pause
```

## Testing Release Builds

1. **Install on Physical Devices:**
   ```bash
   # Install User App
   adb install user_app/build/app/outputs/flutter-apk/app-release.apk
   
   # Install Shop Owner App
   adb install shop_owner_app/build/app/outputs/flutter-apk/app-release.apk
   ```

2. **Test Key Features:**
   - Network connectivity detection
   - Firebase authentication
   - Image upload functionality
   - API communication with backend
   - Offline behavior

## Troubleshooting

### Common Issues:

1. **Build Failures:**
   - Run `flutter doctor` to check for issues
   - Ensure all dependencies are up to date
   - Clear build cache: `flutter clean`

2. **Firebase Issues:**
   - Verify google-services.json files are in correct locations
   - Check Firebase project configuration
   - Ensure SHA-1 fingerprints are added to Firebase console

3. **Network Issues:**
   - Update API base URLs for production
   - Test network connectivity on release builds
   - Verify SSL certificates for HTTPS endpoints

4. **Signing Issues:**
   - Ensure key.properties files are configured correctly
   - Verify keystore files exist and passwords are correct

## Distribution

### Google Play Store:
1. Upload the app bundle (.aab file)
2. Complete store listing
3. Set up app signing
4. Submit for review

### Direct Distribution:
1. Share the APK files directly
2. Users need to enable "Install from unknown sources"
3. Consider using Firebase App Distribution for beta testing

## Version Management

Update version numbers in `pubspec.yaml` before building:

```yaml
version: 1.0.0+1  # version+build_number
```

Increment the build number for each release to Google Play Store.

## Security Considerations

1. **API Keys:** Ensure no sensitive API keys are hardcoded
2. **Obfuscation:** Consider enabling code obfuscation for production
3. **Network Security:** Use HTTPS for all API communications
4. **Data Validation:** Implement proper input validation

## Post-Release

1. **Monitor Crashes:** Use Firebase Crashlytics
2. **Analytics:** Track user behavior with Firebase Analytics
3. **Updates:** Plan for regular updates and bug fixes
4. **Feedback:** Collect user feedback for improvements