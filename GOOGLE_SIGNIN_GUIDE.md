# Google Sign-In Authentication Guide

## Overview
Dono apps (User App aur Shop Owner App) mein Google Sign-In authentication implement kiya gaya hai. Email-based unique user identification use hota hai.

## How It Works

### User App Flow

#### First Time Login:
1. User app open karta hai
2. "Continue with Google" button dabata hai
3. Google account select karta hai
4. App ko milta hai:
   - Email
   - Name  
   - Google ID
5. Ye data backend ko jata hai
6. Backend:
   - Email check karta hai
   - Agar naya user hai toh create karta hai
   - Agar existing user hai toh uska data return karta hai
7. User home screen pe chala jata hai

#### Logout ke Baad:
1. User logout karta hai
2. Dobara app open karta hai
3. "Continue with Google" dabata hai
4. Same Gmail select karta hai
5. Backend check karta hai:
   - Email already exist hai
   - Existing user data return karta hai
6. Same account open ho jata hai
7. User ka pura data wapas mil jata hai (orders, etc.)

### Shop Owner App Flow

#### First Time Login:
1. Shop owner app open karta hai
2. "Continue with Google" button dabata hai
3. Google account select karta hai
4. Owner name aur shop name enter karta hai
5. App ko milta hai:
   - Email
   - Name
   - Google ID
6. Backend:
   - Email check karta hai
   - Agar naya owner hai toh shop create karta hai
   - Agar existing owner hai toh uski shop return karta hai
7. Owner dashboard pe chala jata hai

#### Logout ke Baad:
1. Owner logout karta hai
2. Dobara app open karta hai
3. "Continue with Google" dabata hai
4. Same Gmail select karta hai
5. Backend check karta hai:
   - Email already exist hai
   - Existing shop data return karta hai
6. Same shop open ho jata hai
7. Owner ka pura data wapas mil jata hai (products, orders, etc.)

## Backend Implementation

### User Model (backend/models/User.js)
```javascript
{
  userId: String (unique, indexed),
  name: String,
  email: String (indexed, sparse),
  phone: String,
  totalOrders: Number,
  totalSpent: Number,
  isActive: Boolean
}
```

### Shop Model (backend/models/Shop.js)
```javascript
{
  name: String,
  ownerName: String,
  ownerId: String (indexed),
  email: String (indexed, sparse),
  description: String,
  category: String,
  address: String,
  phone: String,
  isActive: Boolean,
  isApproved: Boolean
}
```

### Login Logic (backend/routes/users.js)
```javascript
// User login/registration
const existingUser = await User.findOne({ 
  $or: [{ userId }, { email }] 
});

if (existingUser) {
  // Update user info if changed
  return existingUser;
} else {
  // Create new user
  const newUser = new User({
    userId: googleId,
    name,
    email
  });
  await newUser.save();
  return newUser;
}
```

### Shop Logic (backend/routes/shops.js)
```javascript
// Shop creation/retrieval
const existingShop = await Shop.findOne({ 
  $or: [{ ownerId }, { email }] 
});

if (existingShop) {
  // Return existing shop
  return existingShop;
} else {
  // Create new shop
  const newShop = new Shop({
    name,
    ownerName,
    ownerId: googleId,
    email
  });
  await newShop.save();
  return newShop;
}
```

## Frontend Implementation

### User App

**Google Auth Service** (`user_app/lib/services/google_auth_service.dart`):
- Google Sign-In integration
- Email-based user identification
- Local storage for auto-login
- Backend API integration

**Login Screen** (`user_app/lib/screens/auth/google_login_screen.dart`):
- Simple "Continue with Google" button
- Automatic user creation/retrieval
- Error handling

### Shop Owner App

**Google Auth Service** (`shop_owner_app/lib/services/google_auth_service.dart`):
- Google Sign-In integration
- Email-based shop identification
- Shop name input after Google sign-in
- Local storage for auto-login

**Login Screen** (`shop_owner_app/lib/screens/auth/google_login_screen.dart`):
- "Continue with Google" button
- Shop name input form
- Automatic shop creation/retrieval
- Error handling

## Setup Requirements

### Firebase Console Setup:

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project or use existing

2. **Add Android Apps**
   - Add User App: `com.example.user_app`
   - Add Shop Owner App: `com.example.shop_owner_app`

3. **Get SHA-1 Fingerprint**
   ```bash
   cd user_app/android
   gradlew signingReport
   
   cd shop_owner_app/android
   gradlew signingReport
   ```

4. **Add SHA-1 to Firebase**
   - Project Settings > Your apps
   - Add SHA-1 fingerprint for each app
   - Download new `google-services.json`

5. **Download Configuration Files**
   - Place in `user_app/android/app/google-services.json`
   - Place in `shop_owner_app/android/app/google-services.json`

### Dependencies (Already Added):
```yaml
dependencies:
  google_sign_in: ^6.1.5
  shared_preferences: ^2.2.2
  http: ^1.1.0
  provider: ^6.1.1
```

## Testing

### User App:
```bash
cd user_app
flutter clean
flutter pub get
flutter run
```

1. Click "Continue with Google"
2. Select Google account
3. Automatically logged in
4. Check backend logs for user creation

### Shop Owner App:
```bash
cd shop_owner_app
flutter clean
flutter pub get
flutter run
```

1. Click "Continue with Google"
2. Select Google account
3. Enter shop name
4. Click "Create Shop"
5. Automatically logged in with shop access

## Key Features

### Email-Based Identification
- Email is unique identifier
- Same email = same account
- Works across devices
- No phone number needed

### Automatic Data Persistence
- User data saved locally
- Auto-login on app restart
- No need to sign in again
- Logout clears local data

### Backend Smart Logic
- Checks email first
- Creates user/shop if new
- Returns existing data if found
- Updates info if changed

### Error Handling
- Network errors handled
- Invalid data validation
- User-friendly error messages
- Automatic retry logic

## Benefits

1. **User-Friendly** - One-click Google login
2. **Secure** - Google OAuth authentication
3. **Persistent** - Auto-login after first time
4. **Smart** - Email-based unique identification
5. **Reliable** - Backend handles duplicates
6. **Fast** - Instant login/registration

## Troubleshooting

### Error: sign_in_failed (Error 10)
- SHA-1 fingerprint missing in Firebase
- Follow setup steps above

### Error: User not created
- Check backend logs
- Verify API endpoint
- Check network connection

### Error: Shop not found
- Ensure shop was created
- Check backend logs
- Verify shopId saved locally

## Production Considerations

For production deployment:

1. **Add Release SHA-1**
   - Generate release keystore
   - Add release SHA-1 to Firebase

2. **Enable Google Sign-In**
   - Firebase Console > Authentication
   - Enable Google Sign-In provider

3. **Backend Security**
   - Add JWT tokens
   - Validate Google tokens
   - Rate limiting

4. **Error Monitoring**
   - Add Sentry/Crashlytics
   - Log authentication errors
   - Monitor failed logins
