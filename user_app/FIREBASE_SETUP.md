# Firebase Setup Guide for User App

## Quick Setup (For Testing)

The app is already configured with demo Firebase credentials that will work for testing. However, for production use, you should set up your own Firebase project.

## Production Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Name it "local-marketplace" or similar
4. Enable Google Analytics (optional)

### 2. Enable Phone Authentication
1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Enable **Phone** provider
3. Add your phone number for testing (optional)

### 3. Configure Android App
1. In Firebase Console, click **Add app** > **Android**
2. Package name: `com.example.user_app`
3. Download `google-services.json`
4. Place it in `android/app/` folder

### 4. Update Firebase Options (Optional)
If you want to use your own Firebase project:
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Run: `firebase login`
3. Run: `flutterfire configure`
4. Select your project and platforms
5. This will update `lib/firebase_options.dart`

## Current Configuration

The app is currently configured with these demo settings:
- Project ID: `local-marketplace-demo`
- Phone authentication enabled
- Works for testing purposes

## Testing Phone Authentication

1. Use any valid phone number format: `+91XXXXXXXXXX`
2. Firebase will send a real SMS in production
3. For testing, you can add test phone numbers in Firebase Console

## Security Notes

- The current configuration is for demo purposes
- For production, set up proper Firebase security rules
- Consider adding reCAPTCHA for web platforms
- Monitor usage to avoid quota limits