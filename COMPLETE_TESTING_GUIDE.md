# Complete Testing Guide - Marketplace System

## 🎯 Overview

This guide will help you verify that both apps work correctly with:
- ✅ No dummy data
- ✅ Real API integration
- ✅ Proper offline handling
- ✅ Complete shop and product management
- ✅ Order flow from user to shop owner

## 📋 Pre-Testing Checklist

### 1. Backend Setup
```bash
cd backend
npm install
# Create .env file with MongoDB connection
npm start
# Backend should be running on http://localhost:3001
```

### 2. Get Your Computer's IP Address

**Windows:**
```bash
ipconfig
# Look for IPv4 Address (e.g., 192.168.1.100)
```

**Mac/Linux:**
```bash
ifconfig
# Look for inet address
```

### 3. Update API URLs

**User App** - Edit `user_app/lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'http://192.168.1.100:3001/api';
// Replace with YOUR IP address
```

**Shop Owner App** - Edit `shop_owner_app/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://192.168.1.100:3001/api';
// Replace with YOUR IP address
```

### 4. Build Both Apps
```bash
# User App
cd user_app
flutter clean
flutter pub get
flutter build apk --release

# Shop Owner App
cd shop_owner_app
flutter clean
flutter pub get
flutter build apk --release
```

### 5. Install on Device
```bash
adb install user_app/build/app/outputs/flutter-apk/app-release.apk
adb install shop_owner_app/build/app/outputs/flutter-apk/app-release.apk
```

## 🧪 Testing Workflow

### Phase 1: Shop Owner App Testing

#### Test 1.1: Shop Registration
1. Open Shop Owner App
2. Should see splash screen → Login/Registration
3. Complete phone verification (if using Firebase Auth)
4. Enter shop details:
   - Shop Name: "Fresh Mart"
   - Description: "Fresh groceries and vegetables"
   - Category: "Grocery"
   - Address: "123 Main Street"
   - Phone: "+1234567890"
5. Click "Register Shop"
6. **Expected**: Shop registered successfully, navigate to dashboard

**Verify in Backend:**
```bash
# Check MongoDB
db.shops.find()
# Should see your shop
```

#### Test 1.2: Product Upload
1. From dashboard, click "Add Product"
2. Click "Gallery" or "Camera" to select image
3. **Expected**: Image picker opens
4. Select an image
5. **Expected**: Image preview shows, upload progress displays
6. Fill product details:
   - Name: "Fresh Apples"
   - Description: "Crisp and sweet red apples"
   - Price: 150
   - Stock: 50
   - Category: "Fruits"
7. Click "Save Product"
8. **Expected**: Product saved, image uploaded to Firebase, navigate back

**Verify in Backend:**
```bash
db.products.find()
# Should see your product with Firebase image URL
```

#### Test 1.3: View Products
1. Go to "Products" tab
2. **Expected**: See "Fresh Apples" with image, price, stock
3. **Verify**: No dummy products appear

#### Test 1.4: Offline Mode
1. Turn off WiFi and Mobile Data
2. Try to add a product
3. **Expected**: "You are offline" message in center of screen
4. **Expected**: Cannot upload image or save product
5. Turn on network
6. **Expected**: Can add products again

### Phase 2: User App Testing

#### Test 2.1: User Registration
1. Open User App
2. Should see splash screen → Username setup
3. Enter username: "John Doe"
4. Click "Continue"
5. **Expected**: Navigate to home screen

#### Test 2.2: View Shops
1. On home screen, go to "Shops" tab
2. **Expected**: See "Fresh Mart" (the shop you registered)
3. **Verify**: No dummy shops appear
4. **Verify**: Only shows shops registered via Shop Owner App

#### Test 2.3: View Products
1. Click on "Fresh Mart"
2. **Expected**: See shop details and products
3. **Expected**: See "Fresh Apples" with image, price ₹150
4. **Verify**: No dummy products appear
5. **Verify**: Shows products uploaded by shop owner

#### Test 2.4: Place Order
1. Select "Fresh Apples"
2. Click "Place Order"
3. Enter delivery notes (optional)
4. Confirm order
5. **Expected**: Order placed successfully
6. **Expected**: Receive pickup code (6-digit)

**Verify in Backend:**
```bash
db.orders.find()
# Should see your order with pickup code
```

#### Test 2.5: Offline Mode
1. Turn off WiFi and Mobile Data
2. Try to view shops
3. **Expected**: "You are offline" message in center of screen
4. **Expected**: Shows previously loaded data (if any)
5. Pull to refresh
6. **Expected**: Error message about no connection
7. Turn on network
8. Pull to refresh
9. **Expected**: Data loads successfully

### Phase 3: Order Management Testing

#### Test 3.1: Shop Owner Receives Order
1. Open Shop Owner App
2. Go to "Orders" tab
3. **Expected**: See new order in "Pending" tab
4. **Expected**: Shows customer name, items, total amount
5. **Expected**: Shows 6-digit pickup code

#### Test 3.2: Accept Order
1. Click "Accept" on the order
2. **Expected**: Order moves to "Accepted" tab
3. **Expected**: Status changes to "Preparing"

#### Test 3.3: Mark Ready
1. In "Accepted" tab, click "Mark Ready"
2. **Expected**: Order status changes to "Ready for Pickup"

#### Test 3.4: Verify Pickup Code
1. Click QR scanner icon
2. Enter the 6-digit pickup code
3. **Expected**: Order details display
4. Click "Complete Order"
5. **Expected**: Order moves to "Completed" tab

#### Test 3.5: User Sees Order Status
1. Open User App
2. Go to "Orders" tab
3. **Expected**: See order with current status
4. **Expected**: Status updates (Pending → Preparing → Ready → Completed)

### Phase 4: Edge Cases Testing

#### Test 4.1: Empty States
1. **User App**: Fresh install, no shops registered
   - **Expected**: "No shops found" message
   - **Verify**: No dummy shops

2. **Shop Owner App**: No orders yet
   - **Expected**: "No pending orders" message
   - **Verify**: No dummy orders

3. **Shop Details**: Shop with no products
   - **Expected**: "No products available" message
   - **Verify**: No dummy products

#### Test 4.2: Network Errors
1. Turn off backend server
2. Try to load data
3. **Expected**: Error message "Failed to load"
4. **Expected**: Retry button appears
5. Start backend server
6. Click retry
7. **Expected**: Data loads successfully

#### Test 4.3: Image Upload Errors
1. Turn off network
2. Try to upload product image
3. **Expected**: "No internet connection" error
4. **Expected**: Upload fails gracefully
5. Turn on network
6. Try again
7. **Expected**: Upload succeeds

#### Test 4.4: Invalid Data
1. Try to register shop with empty fields
2. **Expected**: Validation errors
3. Try to add product with negative price
4. **Expected**: Validation error
5. Try to add product with empty name
6. **Expected**: Validation error

## ✅ Success Criteria

### Shop Owner App:
- [ ] Can register shop successfully
- [ ] Shop data saved to backend (no dummy data)
- [ ] Can upload product images to Firebase
- [ ] Can add products with all details
- [ ] Products appear in product list
- [ ] Can view orders from users
- [ ] Can accept/reject orders
- [ ] Can verify pickup codes
- [ ] Shows "You are offline" when network is off
- [ ] No dummy data anywhere

### User App:
- [ ] Can enter username
- [ ] Shows only registered shops (no dummy shops)
- [ ] Shows products uploaded by shop owners (no dummy products)
- [ ] Can place orders
- [ ] Receives pickup code
- [ ] Can track order status
- [ ] Shows "You are offline" when network is off
- [ ] Pull to refresh works
- [ ] No dummy data anywhere

### Both Apps:
- [ ] Offline detection works
- [ ] Offline message shows in center
- [ ] API integration works
- [ ] Error handling is proper
- [ ] UI is clean and professional
- [ ] No crashes or bugs

## 🐛 Common Issues & Solutions

### Issue 1: "No shops found" in User App
**Cause**: No shops registered yet
**Solution**: Register a shop using Shop Owner App first

### Issue 2: "No products available"
**Cause**: Shop has no products
**Solution**: Upload products using Shop Owner App

### Issue 3: "Network error"
**Cause**: Backend not running or wrong API URL
**Solution**: 
- Check backend is running: `npm start`
- Verify API URL matches your IP address
- Check firewall settings

### Issue 4: Images not uploading
**Cause**: Firebase not configured
**Solution**: 
- Check `google-services.json` files
- Verify Firebase Storage is enabled
- Check Firebase rules

### Issue 5: Orders not appearing
**Cause**: API endpoint issue
**Solution**:
- Check backend logs
- Verify order creation endpoint works
- Test with Postman

## 📊 Test Results Template

```
Date: ___________
Tester: ___________

Shop Owner App:
[ ] Shop Registration: PASS / FAIL
[ ] Product Upload: PASS / FAIL
[ ] Image Upload: PASS / FAIL
[ ] Order Management: PASS / FAIL
[ ] Offline Detection: PASS / FAIL
[ ] No Dummy Data: PASS / FAIL

User App:
[ ] Username Setup: PASS / FAIL
[ ] Shop Listing: PASS / FAIL
[ ] Product Viewing: PASS / FAIL
[ ] Order Placement: PASS / FAIL
[ ] Offline Detection: PASS / FAIL
[ ] No Dummy Data: PASS / FAIL

Overall Status: PASS / FAIL
Notes: ___________
```

## 🎯 Final Verification

After all tests pass:
1. ✅ No dummy data in either app
2. ✅ All data comes from backend API
3. ✅ Offline detection works properly
4. ✅ Images upload to Firebase
5. ✅ Orders flow correctly
6. ✅ UI is clean and professional
7. ✅ Error handling is robust

**Your marketplace system is production-ready!** 🚀