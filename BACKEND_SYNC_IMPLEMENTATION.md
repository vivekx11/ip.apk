# Backend Sync Implementation - Shop Owner App

## Overview
Shop owner app ab local-first approach use karta hai with smart backend sync:
- Login/Profile setup → Local storage (fast, no timeout)
- First product upload → Backend sync (shop creation)
- Subsequent operations → Backend shop ID use kare

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Shop Owner App                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Step 1: Google Login (Local)                           │
│  ├─ Google Sign-In                                      │
│  ├─ Profile Setup (Name + Shop Name)                    │
│  └─ Save to Local Storage                               │
│                                                          │
│  Step 2: First Product Upload (Backend Sync)            │
│  ├─ Check if shop synced                                │
│  ├─ If not synced → Create shop in backend              │
│  ├─ Save backend shop ID                                │
│  └─ Upload product with backend shop ID                 │
│                                                          │
│  Step 3: Subsequent Operations                          │
│  └─ Use saved backend shop ID                           │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## Implementation Details

### 1. ShopSyncService (shop_sync_service.dart)

**Purpose**: Manage backend shop synchronization

**Key Methods:**

```dart
// Sync local shop with backend (creates shop if not exists)
Future<String> syncShopWithBackend() async {
  // Check if already synced
  // If not, create shop in backend
  // Save backend shop ID
  // Return backend shop ID
}

// Load saved backend shop ID
Future<void> loadSavedBackendShopId() async

// Clear sync data on logout
Future<void> clearSyncData() async

// Ensure shop is synced before operations
Future<bool> ensureShopSynced() async
```

**Storage Keys:**
- `backend_shop_id` - Backend shop ID
- `is_shop_synced` - Sync status flag

### 2. Modified Add Product Screen

**Before:**
```dart
// Old approach - direct upload
final response = await _uploadService.uploadProduct(...)
```

**After:**
```dart
// New approach - sync first, then upload
final shopSyncService = ShopSyncService();
final backendShopId = await shopSyncService.syncShopWithBackend();

final response = await _uploadService.uploadProduct(
  shopId: backendShopId, // Use backend shop ID
  ...
)
```

### 3. Backend API (Already Proper)

**POST /api/shops**
- Creates new shop if not exists
- Returns existing shop if ownerId already has one
- Auto-approves shop

**Request:**
```json
{
  "name": "Shop Name",
  "ownerName": "Owner Name",
  "ownerId": "google_user_id",
  "email": "owner@gmail.com",
  "description": "Welcome to Shop Name",
  "category": "Other",
  "address": "Local Area",
  "phone": "google_user_id"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Shop registered successfully",
  "data": {
    "_id": "backend_shop_id",
    "name": "Shop Name",
    "ownerId": "google_user_id",
    ...
  }
}
```

## Flow Diagram

### First Time User Flow

```
1. Open App
   ↓
2. Google Sign-In
   ↓
3. Profile Setup (Name + Shop Name)
   ↓
4. Save Locally
   ↓
5. Main Screen
   ↓
6. Add First Product
   ↓
7. Check Sync Status → Not Synced
   ↓
8. Create Shop in Backend
   ↓
9. Save Backend Shop ID
   ↓
10. Upload Product
    ↓
11. Success!
```

### Returning User Flow

```
1. Open App
   ↓
2. Load Saved Data
   ↓
3. Main Screen
   ↓
4. Add Product
   ↓
5. Check Sync Status → Already Synced
   ↓
6. Use Saved Backend Shop ID
   ↓
7. Upload Product
   ↓
8. Success!
```

## Benefits

### ✅ Fast Login
- No backend calls during login
- No timeout errors
- Instant profile setup

### ✅ Reliable Sync
- Shop created only when needed
- Automatic retry on failure
- Persistent backend shop ID

### ✅ Better UX
- User can complete profile setup offline
- First product upload handles sync automatically
- Clear error messages

### ✅ Efficient
- One-time sync per shop
- Reuses backend shop ID
- Minimal API calls

## Error Handling

### Sync Errors
```dart
try {
  await shopSyncService.syncShopWithBackend();
} catch (e) {
  if (e.toString().contains('timeout')) {
    // Show: "Connection timeout. Please check internet."
  } else if (e.toString().contains('Owner not logged in')) {
    // Show: "Please login again."
  } else {
    // Show: Generic error message
  }
}
```

### Network Errors
- Timeout: 60 seconds (for cold starts)
- Retry: User can retry manually
- Offline: Clear message to check internet

## Testing Checklist

- [ ] First time login works
- [ ] Profile setup saves locally
- [ ] First product upload syncs shop
- [ ] Backend shop ID is saved
- [ ] Subsequent uploads use saved shop ID
- [ ] Logout clears sync data
- [ ] Re-login and upload works
- [ ] Timeout errors handled properly
- [ ] Network errors show clear messages

## Files Modified

1. **shop_owner_app/lib/services/shop_sync_service.dart** (NEW)
   - Backend sync logic
   - Shop creation API call
   - Sync status management

2. **shop_owner_app/lib/screens/products/add_product_screen.dart**
   - Added sync check before upload
   - Uses backend shop ID
   - Better error handling

3. **shop_owner_app/lib/services/google_auth_service.dart**
   - Clear sync data on logout
   - Import ShopSyncService

## Backend Routes (Already Proper)

### POST /api/shops
- ✅ Creates shop if not exists
- ✅ Returns existing shop if ownerId matches
- ✅ Auto-approves shop
- ✅ Validates required fields

### GET /api/shops?ownerId=xxx
- ✅ Returns shops by owner ID
- ✅ Used for checking existing shops

### POST /api/products
- ✅ Accepts shopId
- ✅ Links product to shop
- ✅ Validates shop exists

## Summary

Ab shop owner app mein:
1. **Login** - Fast & local (no backend)
2. **Profile Setup** - Fast & local (no backend)
3. **First Product Upload** - Syncs shop with backend automatically
4. **Subsequent Operations** - Uses saved backend shop ID

Result: Fast login, reliable sync, better UX! 🚀
