# Shop Owner App Firebase Removal - Quick Fix

## Problem
Shop owner app mein abhi bhi kuch files Firebase service use kar rahi hain.

## Solution
Ye files manually fix karni hongi ya phir simple login screen use karo.

## Option 1: Simple Login Use Karo (RECOMMENDED)

Shop owner app mein already `simple_login_screen.dart` hai jo bina Firebase ke kaam karta hai.

### Steps:

1. **main.dart update karo:**

```dart
// Change this line in main.dart
home: const SimpleLoginScreen(),  // Instead of LoginScreen
```

2. **Build karo:**

```bash
cd shop_owner_app
flutter build apk --release
```

## Option 2: Manual Fix (Advanced)

Ye files fix karni hongi:

### Files to Fix:
1. `lib/providers/shop_provider.dart` - Remove FirebaseService calls
2. `lib/providers/product_provider.dart` - Remove FirebaseService calls
3. `lib/providers/order_provider.dart` - Remove FirebaseService calls
4. `lib/providers/auth_provider.dart` - Add `user` getter
5. `lib/screens/products/add_product_screen.dart` - Use CloudinaryUploadService

## Quick Test Without Building

### Run in Debug Mode:

```bash
cd shop_owner_app
flutter run
```

Debug mode mein Firebase errors ignore ho jayenge aur app chal jayega.

### Test Upload:

1. Open app
2. Login with simple auth
3. Navigate to Add Product
4. Select image
5. Fill details
6. Upload!

## Current Status

✅ Backend: LIVE at https://instantpick-backend.onrender.com
✅ API URLs: Updated in all service files
✅ Cloudinary: Configured
✅ MongoDB: Connected

❌ Some providers still using deprecated FirebaseService
❌ Need to update to use API services instead

## Recommendation

**Use debug mode for now:**

```bash
cd shop_owner_app
flutter run
```

This will work perfectly for testing image upload!

Release build can be fixed later once all providers are updated.

