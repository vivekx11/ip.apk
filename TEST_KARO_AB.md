# 🧪 Testing Guide - Ab Test Karo!

## 🎯 Quick Testing Steps

### Step 1: Shop Owner App Build Karo

```bash
cd shop_owner_app
flutter clean
flutter pub get
flutter build apk --release
```

APK location: `shop_owner_app/build/app/outputs/flutter-apk/app-release.apk`

---

### Step 2: User App Build Karo

```bash
cd user_app
flutter clean
flutter pub get
flutter build apk --release
```

APK location: `user_app/build/app/outputs/flutter-apk/app-release.apk`

---

## 📱 Testing Checklist

### Shop Owner App Testing

#### ✅ Test 1: First Time Login
1. Install APK
2. Open app
3. Enter:
   - Name: "Rahul"
   - Shop Name: "Rahul's Store"
4. Click "Continue"
5. **Expected:** Dashboard screen dikhna chahiye

**Check Backend:**
```bash
# MongoDB me check karo
db.shops.find({ ownerName: "Rahul" })
```

---

#### ✅ Test 2: Add Product
1. Dashboard → "Add Product" button
2. Fill form:
   - Name: "Test Product"
   - Description: "This is a test product"
   - Price: "100"
   - Stock: "10"
   - Category: "Electronics"
3. Select image (Gallery ya Camera)
4. Click "Save"
5. **Expected:** "Product uploaded successfully!" message

**Check Backend:**
```bash
# MongoDB me check karo
db.products.find({ name: "Test Product" })
# shopId field check karo - ye empty nahi hona chahiye!
```

---

#### ✅ Test 3: Auto-Login
1. Close app completely
2. Reopen app
3. **Expected:** Directly dashboard pe jana chahiye (no login screen)

---

#### ✅ Test 4: View Products
1. Dashboard → "Products" tab
2. **Expected:** Tumhara added product dikhna chahiye

---

### User App Testing

#### ✅ Test 5: View All Products
1. Install User App APK
2. Open app
3. **Expected:** 
   - Products list dikhna chahiye
   - Shop name visible hona chahiye
   - Product images load hone chahiye

---

#### ✅ Test 6: Product Details
1. Kisi product pe click karo
2. **Expected:**
   - Full product details
   - Shop name
   - Price
   - Description
   - "Add to Cart" button

---

#### ✅ Test 7: Add to Cart
1. Product details screen pe "Add to Cart" click karo
2. Cart icon pe click karo
3. **Expected:** Product cart me dikhna chahiye

---

## 🔍 Debug Logs Check Karo

### Shop Owner App Logs
```dart
// Login time
print('🏪 Creating shop for owner: $ownerId');
print('✅ Shop created with ID: $_shopId');

// Product upload time
print('🚀 Starting product upload...');
print('Owner ID: $ownerId');
print('Shop ID: $shopId');
print('✅ Product uploaded successfully');
```

### Backend Logs
```javascript
// Shop creation
console.log('Creating new shop for owner:', ownerId);
console.log('New shop created:', ownerShop._id);

// Product creation
console.log('Product creation request:', { name, shopName, ownerId, price });
console.log('Product created successfully:', product._id);
```

---

## ⚠️ Common Issues & Solutions

### Issue 1: "shopId is required" Error
**Solution:** 
- Check if shop properly created hai
- Check if shopId storage me save hua hai
- Logs check karo: `print('Shop ID: $shopId');`

### Issue 2: Products User App Me Nahi Dikh Rahe
**Solution:**
- Backend URL check karo (both apps me same hona chahiye)
- Internet connection check karo
- Backend logs check karo

### Issue 3: Image Upload Fail
**Solution:**
- Image size check karo (max 10MB)
- Backend upload endpoint check karo
- Network logs check karo

### Issue 4: Auto-Login Nahi Ho Raha
**Solution:**
- SharedPreferences data check karo
- `loadSavedAuth()` function logs check karo

---

## 🎯 Success Criteria

### Shop Owner App
- [x] Login successful
- [x] Shop auto-created
- [x] shopId saved locally
- [x] Product upload successful
- [x] Product me shopId hai
- [x] Auto-login working

### User App
- [x] Products visible
- [x] Shop name displayed
- [x] Product details working
- [x] Cart functionality working

---

## 📊 Backend Verification

### Check Shop Created
```javascript
// MongoDB Query
db.shops.find().pretty()

// Expected Output:
{
  "_id": ObjectId("..."),
  "name": "Rahul's Store",
  "ownerId": "1234567890",
  "ownerName": "Rahul",
  "isApproved": true,
  "isActive": true
}
```

### Check Product Created
```javascript
// MongoDB Query
db.products.find().pretty()

// Expected Output:
{
  "_id": ObjectId("..."),
  "name": "Test Product",
  "price": 100,
  "shopId": ObjectId("..."),  // ✅ Should NOT be empty!
  "shopName": "Rahul's Store",
  "isAvailable": true
}
```

---

## 🚀 Next Steps After Testing

1. ✅ Sab tests pass ho gaye?
2. ✅ Products properly display ho rahe hain?
3. ✅ shopId properly save ho raha hai?

**Agar sab kuch working hai, toh:**
- Production me deploy karo
- Real users ko test karne do
- Feedback collect karo

**Agar koi issue hai, toh:**
- Logs check karo
- Error messages padho
- Mujhe batao, main fix karunga!

---

## 📞 Support

Agar koi problem aaye testing me:
1. Logs screenshot lo
2. Error message copy karo
3. Mujhe dikhao

**Happy Testing! 🎉**
