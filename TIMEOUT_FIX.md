# Timeout & Shop Not Found - Fix

## Issues Fixed

### 1. Connection Timeout Error
**Problem**: "Connection timeout. Please check your internet and try again"

**Root Cause**: App constants mein localhost URL tha instead of production URL

**Fix**:
```dart
// Before (WRONG)
static const String baseUrl = 'http://10.0.2.2:5000/api';

// After (CORRECT)
static const String baseUrl = 'https://instantpick-backend.onrender.com/api';
```

**File**: `shop_owner_app/lib/core/constants/app_constants.dart`

### 2. Shop Not Found Error
**Problem**: Products screen "No Shop Registered" dikha raha tha

**Root Cause**: Products screen `shopProvider.currentShop` check kar raha tha jo null tha kyunki ab local-first approach use kar rahe hain

**Fix**:
```dart
// Before
if (shopProvider.currentShop == null) {
  return "No Shop Registered";
}

// After
// Load products using backend shop ID from sync service
final shopSyncService = ShopSyncService();
await shopSyncService.loadSavedBackendShopId();
shopId = shopSyncService.backendShopId;
```

**File**: `shop_owner_app/lib/screens/home/products_screen.dart`

## How It Works Now

### First Time User:
1. Login with Google ✅
2. Setup Profile (Name + Shop) ✅
3. Main Screen opens ✅
4. Products screen shows "No products yet" (normal)
5. Add first product → Shop syncs with backend automatically ✅
6. Product uploads successfully ✅
7. Products list refreshes and shows product ✅

### Returning User:
1. App opens ✅
2. Loads saved data ✅
3. Main Screen opens ✅
4. Products screen loads products using saved backend shop ID ✅

## Testing Steps

1. **Clean Install**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **First Login**:
   - Sign in with Google
   - Enter name and shop name
   - Should reach main screen without errors

3. **Add Product**:
   - Click "Add Product"
   - Fill details and select image
   - Click "Save"
   - Should see "Checking shop sync status..."
   - Should see "Shop synced with backend"
   - Should see "Product uploaded successfully!"

4. **View Products**:
   - Go to Products tab
   - Should see uploaded product
   - No "Shop not found" error

5. **Logout & Re-login**:
   - Logout
   - Login again
   - Products should load automatically

## Important Notes

### Backend URL
- **Production**: `https://instantpick-backend.onrender.com/api`
- **Local Dev**: `http://10.0.2.2:5000/api` (Android Emulator)

### Timeout Settings
- Shop sync: 60 seconds (for Render.com cold starts)
- Product upload: 60 seconds
- API calls: 60 seconds

### Error Messages
- "Connection timeout" → Check internet connection
- "Owner not logged in" → Login again
- "Shop not found" → Should not appear anymore!

## Files Modified

1. `shop_owner_app/lib/core/constants/app_constants.dart`
   - Changed baseUrl to production URL

2. `shop_owner_app/lib/screens/home/products_screen.dart`
   - Load products using ShopSyncService
   - Removed "No Shop Registered" check
   - Added ShopSyncService import

## Summary

✅ Timeout error fixed - Using correct production URL
✅ Shop not found fixed - Using backend shop ID from sync service
✅ Products load properly after first upload
✅ Clean error messages
✅ Better user experience

Ab app rebuild karo aur test karo!
