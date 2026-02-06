# 🔥 Update Firebase Configuration

After creating your own Firebase project, you'll need to update the Firebase configuration in your app.

## Files to Update:

### 1. Replace google-services.json
- Download from your Firebase project
- Replace: `user_app/android/app/google-services.json`

### 2. Update firebase_options.dart
Replace the content in `user_app/lib/firebase_options.dart` with the configuration from your Firebase project:

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to **Your apps** section
3. Click on your Android app
4. Click **"SDK setup and configuration"**
5. Select **"Config"** tab
6. Copy the configuration values

### 3. Update Project ID References
Update these values in your configuration:
- `projectId`: Your new project ID
- `messagingSenderId`: Your sender ID
- `appId`: Your app ID
- `apiKey`: Your API key

## Quick Setup Script:

```bash
# 1. Clean and rebuild
flutter clean
flutter pub get

# 2. Build release APK
flutter build apk --release

# 3. Test with your phone number
# Install APK and test OTP functionality
```

## Testing:
1. Install the new APK on your device
2. Enter your real phone number
3. You should receive SMS with OTP
4. Complete the login process

Your app will now use your own Firebase project with proper OTP functionality!