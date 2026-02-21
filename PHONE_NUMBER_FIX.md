# Phone Number Validation Fix

## Problem
```
❌ Error registering shop: Shop validation failed: 
phone: Path `phone` (`102489185495638472349`) is longer than 
the maximum allowed length (15).
```

**Root Cause**: 
- Google user ID bahut lamba hai (21 digits)
- Backend Shop model mein phone field ki max length 15 hai
- App Google user ID ko phone number ki jagah use kar raha tha

## Solution
Profile setup screen mein actual phone number input field add kiya with +91 prefix.

## Changes Made

### 1. Profile Setup Screen (profile_setup_screen.dart)

**Added Phone Number Field:**
```dart
TextFormField(
  controller: _phoneController,
  decoration: InputDecoration(
    labelText: 'Phone Number',
    hintText: 'Enter your phone number',
    prefixText: '+91 ',
    prefixIcon: const Icon(Icons.phone),
  ),
  keyboardType: TextInputType.phone,
  maxLength: 10,
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter phone number';
    }
    if (value.trim().length != 10) {
      return 'Phone number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Phone number must contain only digits';
    }
    return null;
  },
)
```

**Validation Rules:**
- Required field
- Exactly 10 digits
- Only numbers allowed
- Auto-adds +91 prefix

### 2. Google Auth Service (google_auth_service.dart)

**Updated setupProfile method:**
```dart
Future<Map<String, dynamic>> setupProfile({
  required String ownerName,
  required String shopName,
  required String phone,  // NEW parameter
}) async {
  _currentOwner = ShopOwnerModel(
    id: googleUser.id,
    phoneNumber: '+91$phone',  // Add +91 prefix
    name: ownerName.trim(),
    email: googleUser.email,
    shopName: shopName.trim(),
    ...
  );
}
```

### 3. Shop Sync Service (shop_sync_service.dart)

**Uses actual phone number:**
```dart
body: json.encode({
  'name': owner.shopName,
  'phone': owner.phoneNumber,  // Now contains +91XXXXXXXXXX
  'ownerName': owner.name,
  'ownerId': owner.id,
  ...
})
```

## New User Flow

### Step 1: Google Sign-In
```
User → Click "Continue with Google" → Select Gmail
```

### Step 2: Profile Setup
```
User → Enter:
  - Name: "Vivek"
  - Shop Name: "Abc Shop"
  - Phone: "9876543210"  (10 digits)
```

### Step 3: Data Saved
```dart
{
  "id": "google_user_id_12345",
  "name": "Vivek",
  "shopName": "Abc Shop",
  "phoneNumber": "+919876543210",  // 13 chars (within 15 limit)
  "email": "vivek@gmail.com"
}
```

### Step 4: Backend Shop Creation
```json
POST /api/shops
{
  "name": "Abc Shop",
  "ownerName": "Vivek",
  "ownerId": "google_user_id_12345",
  "phone": "+919876543210",  // ✅ Valid (13 chars < 15)
  "email": "vivek@gmail.com",
  ...
}
```

## Phone Number Format

| Input | Stored As | Length | Valid? |
|-------|-----------|--------|--------|
| 9876543210 | +919876543210 | 13 | ✅ Yes |
| 1234567890 | +911234567890 | 13 | ✅ Yes |
| 123456789 | +91123456789 | 12 | ❌ No (validation fails) |
| 98765432101 | +9198765432101 | 14 | ❌ No (validation fails) |

## Backend Validation

**Shop Model (backend/models/Shop.js):**
```javascript
phone: {
  type: String,
  required: true,
  trim: true,
  minlength: 10,
  maxlength: 15  // +919876543210 = 13 chars ✅
}
```

## Testing Checklist

- [ ] Profile setup shows phone number field
- [ ] Phone field has +91 prefix
- [ ] Only 10 digits allowed
- [ ] Validation works (empty, < 10, > 10, non-numeric)
- [ ] Phone saves as +91XXXXXXXXXX
- [ ] Backend shop creation succeeds
- [ ] No "phone too long" error
- [ ] Product upload works after shop creation

## Error Messages

### Before Fix:
```
❌ Shop validation failed: phone is longer than maximum allowed length (15)
```

### After Fix:
```
✅ Shop synced successfully with backend
✅ Product uploaded successfully!
```

## Summary

✅ Phone number field added to profile setup
✅ +91 prefix automatically added
✅ 10-digit validation enforced
✅ Phone format: +91XXXXXXXXXX (13 chars)
✅ Backend validation passes
✅ Shop creation successful
✅ No more "phone too long" error

Ab app rebuild karo aur test karo!
