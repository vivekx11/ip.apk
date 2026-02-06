# User App - Local Marketplace (Pink Theme) 🩷

A customer-focused Flutter app for browsing and purchasing from local shops.

## 🚀 Quick Start

### Option 1: Demo Mode (No Setup Required)
The app is configured to run in demo mode by default - no Firebase setup needed!

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

3. **Login with demo credentials:**
   - Use any phone number (e.g., `9876543210`)
   - Use any 6-digit OTP (e.g., `123456`)

### Option 2: Firebase Authentication
To use real Firebase phone authentication:

1. **Enable Firebase mode:**
   - Open `lib/core/config/app_config.dart`
   - Change `useFirebaseAuth` to `true`

2. **Setup Firebase:**
   - Follow instructions in `FIREBASE_SETUP.md`
   - Add your `google-services.json` file

3. **Run the app:**
   ```bash
   flutter pub get
   flutter run
   ```

## 📱 Features

### ✅ Implemented
- **OTP Authentication** - Phone number verification
- **Pink Theme** - Friendly, modern UI design
- **Home Dashboard** - Categories and featured content
- **Profile Management** - Edit user information
- **Navigation** - Bottom tab navigation
- **Responsive Design** - Works on different screen sizes

### 🔄 In Progress
- Shopping cart functionality
- Product browsing and search
- Order placement and tracking
- Shop discovery

## 🎨 Design System

### Colors
- **Primary Pink**: `#E91E63`
- **Light Pink**: `#F8BBD9`
- **Soft Pink**: `#FCE4EC`
- **White**: `#FFFFFF`

### UI Elements
- Rounded buttons with smooth animations
- Card-based layouts
- Soft shadows and gradients
- Friendly, approachable design

## 🏗️ Architecture

```
lib/
├── core/
│   ├── config/           # App configuration
│   ├── constants/        # App constants
│   └── theme/           # Theme configuration
├── models/              # Data models
├── services/            # Business logic
│   ├── auth_service.dart      # Firebase authentication
│   ├── demo_auth_service.dart # Demo authentication
│   └── api_service.dart       # HTTP client
├── screens/             # UI screens
│   ├── auth/           # Authentication screens
│   └── home/           # Main app screens
└── main.dart           # App entry point
```

## 🔧 Configuration

### App Config (`lib/core/config/app_config.dart`)
```dart
class AppConfig {
  // Set to true for Firebase, false for demo mode
  static const bool useFirebaseAuth = false;
  
  // App information
  static const String appVersion = '1.0.0';
  static const String appName = 'Local Marketplace';
}
```

## 🧪 Testing

### Demo Mode Testing
1. Enter any 10-digit phone number
2. Use any 6-digit OTP code
3. Test profile editing and logout

### Firebase Mode Testing
1. Use a real phone number
2. Receive SMS with OTP
3. Complete authentication flow

## 📦 Build APK

```bash
# Clean build
flutter clean
flutter pub get

# Build release APK
flutter build apk --release

# APK location
build/app/outputs/flutter-apk/app-release.apk
```

## 🔍 Troubleshooting

### Common Issues

1. **Build Errors:**
   - Run `flutter clean && flutter pub get`
   - Check Android NDK version in `android/app/build.gradle.kts`

2. **Firebase Issues:**
   - Ensure `google-services.json` is in `android/app/`
   - Check Firebase project configuration
   - Verify phone authentication is enabled

3. **Demo Mode Issues:**
   - Ensure `useFirebaseAuth = false` in app config
   - Any phone number and OTP should work

## 🚀 Next Steps

1. **Backend Integration** - Connect to marketplace API
2. **Product Catalog** - Browse and search products
3. **Shopping Cart** - Add items and checkout
4. **Order Management** - Track order status
5. **Push Notifications** - Order updates and promotions

## 📄 License

This project is part of the Local Marketplace system demo.