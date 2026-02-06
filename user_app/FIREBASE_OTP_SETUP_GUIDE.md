# Firebase Phone Authentication Setup Guide

This guide will help you set up Firebase Phone Authentication properly to fix the OTP issue.

## Current Status
- **Issue**: OTP not being sent when entering phone number
- **Temporary Fix**: App is now set to Demo mode (`useFirebaseAuth = false`)
- **Demo Mode**: Any phone number works, any 6-digit OTP will be accepted

## Steps to Enable Firebase Phone Authentication

### 1. Firebase Console Setup

1. **Go to Firebase Console**: https://console.firebase.google.com/
2. **Select your project**: `local-marketplace-demo`
3. **Enable Phone Authentication**:
   - Go to Authentication → Sign-in method
   - Click on "Phone" provider
   - Enable it and save

### 2. Android Configuration (Required for Phone Auth)

#### Add SHA-1 Fingerprint
Phone authentication requires SHA-1 fingerprint for Android:

1. **Get Debug SHA-1**:
   ```bash
   cd user_app/android
   ./gradlew signingReport
   ```
   Or on Windows:
   ```cmd
   cd user_app\android
   gradlew.bat signingReport
   ```

2. **Copy the SHA-1 hash** from the debug variant

3. **Add to Firebase**:
   - Go to Project Settings → Your apps → Android app
   - Scroll down to "SHA certificate fingerprints"
   - Click "Add fingerprint" and paste your SHA-1

4. **Download new google-services.json**:
   - Download the updated config file
   - Replace `user_app/android/app/google-services.json`

### 3. Test Phone Numbers (Optional)

For testing, you can add test phone numbers in Firebase Console:
- Go to Authentication → Sign-in method → Phone
- Scroll down to "Phone numbers for testing"
- Add: `+91 9876543210` with OTP: `123456`

### 4. Enable Firebase Authentication

Once Firebase is properly configured:

1. **Update app config**:
   ```dart
   // In user_app/lib/core/config/app_config.dart
   static const bool useFirebaseAuth = true;
   ```

2. **Test the app**:
   - Enter a real phone number
   - You should receive an actual SMS with OTP
   - Or use the test number you configured

### 5. Troubleshooting

#### Common Issues:

1. **"This app is not authorized to use Firebase Authentication"**
   - Check SHA-1 fingerprint is added correctly
   - Ensure google-services.json is updated

2. **"Invalid phone number format"**
   - Ensure phone number includes country code (+91)
   - Format: +91XXXXXXXXXX

3. **OTP not received**
   - Check phone authentication is enabled in Firebase Console
   - Verify SHA-1 fingerprint
   - Try with a test phone number first

4. **Network errors**
   - Ensure internet connection
   - Check Firebase project is active

#### Debug Steps:

1. **Check logs**:
   ```bash
   flutter logs
   ```

2. **Verify Firebase initialization**:
   - Look for Firebase initialization success message
   - Check for any Firebase-related errors

3. **Test with demo mode first**:
   - Set `useFirebaseAuth = false`
   - Verify app flow works
   - Then switch to Firebase

### 6. Production Setup

For production apps:
1. Add production SHA-1 fingerprint
2. Configure proper Firebase security rules
3. Set up Firebase App Check for additional security
4. Consider rate limiting for OTP requests

## Current Demo Mode Behavior

With `useFirebaseAuth = false`:
- ✅ Any phone number works
- ✅ Any 6-digit OTP is accepted
- ✅ User gets logged in successfully
- ✅ App flow continues normally

This allows you to test the complete app functionality while you set up Firebase properly.

## Need Help?

If you continue having issues:
1. Check the console logs for specific error messages
2. Verify your Firebase project configuration
3. Test with the demo mode first to isolate the issue
4. Consider using Firebase Test Lab for device testing