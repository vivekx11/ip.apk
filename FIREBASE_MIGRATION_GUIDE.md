# Firebase Migration Guide - Remove Node.js Backend

## Overview
This guide outlines the complete migration from Node.js backend to Firebase-only architecture, removing all dummy data and implementing proper empty states.

## ✅ Completed Changes

### 1. Firebase Services Created
- ✅ `user_app/lib/services/firebase_service.dart` - Complete Firebase integration for user app
- ✅ `shop_owner_app/lib/services/firebase_service.dart` - Complete Firebase integration for shop owner app

### 2. Model Updates
- ✅ Added `fromFirestore()` and `toFirestore()` methods to:
  - `user_app/lib/models/shop_model.dart`
  - `user_app/lib/models/product_model.dart`
  - `user_app/lib/models/order_model.dart`

### 3. User App - Screens Updated
- ✅ `user_app/lib/screens/home/home_screen.dart` - Removed dummy data, shows real shops from Firebase
- ✅ `user_app/lib/screens/home/cart_screen.dart` - Shows actual cart items with proper functionality
- ✅ `user_app/lib/screens/home/orders_screen.dart` - Shows real order history from Firebase
- ✅ `user_app/lib/screens/home/profile_screen.dart` - Removed reset button, added proper logout
- ✅ `user_app/lib/screens/shops/shops_screen.dart` - Added search query parameter support

### 4. Providers Created
- ✅ `user_app/lib/providers/cart_provider.dart` - Cart management
- ✅ `user_app/lib/providers/order_provider.dart` - Order management

### 5. Shop Owner App - Dashboard
- ✅ `shop_owner_app/lib/screens/home/dashboard_screen_new.dart` - Removed dummy data, shows real stats

## 🔄 Remaining Changes Needed

### User App

#### 1. Update Shop Provider
**File:** `user_app/lib/providers/shop_provider.dart`
```dart
// Replace ShopService with FirebaseService
import '../services/firebase_service.dart';

class ShopProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  // Update all methods to use _firebaseService instead of _shopService
}
```

#### 2. Update Shop Details Screen
**File:** `user_app/lib/screens/shops/shop_details_screen.dart`
- Load products from Firebase using `FirebaseService().getShopProducts(shopId)`
- Add "Add to Cart" functionality using CartProvider
- Show empty state if no products available

#### 3. Update Place Order Screen
**File:** `user_app/lib/screens/orders/place_order_screen.dart`
- Use CartProvider to get cart items
- Use FirebaseService to create order
- Generate pickup code
- Clear cart after successful order

#### 4. Update Main App
**File:** `user_app/lib/main.dart`
- Add CartProvider to MultiProvider
- Add OrderProvider to MultiProvider

### Shop Owner App

#### 1. Update Products Screen
**File:** `shop_owner_app/lib/screens/home/products_screen.dart`
```dart
// Load products from Firebase
// Show empty state if no products
// Add functionality to navigate to AddProductScreen
```

#### 2. Update Product Provider
**File:** `shop_owner_app/lib/providers/product_provider.dart`
```dart
import '../services/firebase_service.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _products = [];
  
  Future<void> loadProducts(String shopId) async {
    _products = await _firebaseService.getShopProducts(shopId);
    notifyListeners();
  }
}
```

#### 3. Update Shop Provider
**File:** `shop_owner_app/lib/providers/shop_provider.dart`
```dart
import '../services/firebase_service.dart';

class ShopProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, dynamic>? _currentShop;
  
  Future<void> loadShopByOwnerId(String ownerId) async {
    _currentShop = await _firebaseService.getShopByOwnerId(ownerId);
    notifyListeners();
  }
}
```

#### 4. Update Order Provider
**File:** `shop_owner_app/lib/providers/order_provider.dart`
```dart
import '../services/firebase_service.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Order> _orders = [];
  
  Future<void> loadShopOrders(String shopId) async {
    _orders = await _firebaseService.getShopOrders(shopId);
    notifyListeners();
  }
  
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firebaseService.updateOrderStatus(orderId, status);
    // Reload orders
  }
}
```

#### 5. Update Add Product Screen
**File:** `shop_owner_app/lib/screens/products/add_product_screen.dart`
- Use FirebaseService to upload product images
- Use FirebaseService to create product
- Add proper validation
- Show success message

#### 6. Update Profile Screen
**File:** `shop_owner_app/lib/screens/home/profile_screen.dart`
- Show shop information (name, address, phone, category)
- Add edit shop details functionality
- Remove any dummy data
- Add proper logout

#### 7. Replace Dashboard
**File:** `shop_owner_app/lib/screens/home/dashboard_screen.dart`
- Replace with the new dashboard_screen_new.dart content

### Common Updates

#### 1. Offline Handling
Both apps should show centered offline message:
```dart
if (!_isOnline) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No Internet Connection'),
          Text('Please check your network'),
          ElevatedButton(
            onPressed: _checkConnectivity,
            child: Text('Retry'),
          ),
        ],
      ),
    ),
  );
}
```

#### 2. Remove Node.js Backend References
- Delete or comment out `backend/` folder
- Remove API service calls to Node.js
- Update all API calls to use Firebase directly

## 📋 Firebase Firestore Structure

### Collections

#### shops
```json
{
  "ownerId": "string",
  "name": "string",
  "description": "string",
  "category": "string",
  "address": "string",
  "phone": "string",
  "imageUrl": "string",
  "isActive": boolean,
  "rating": number,
  "createdAt": timestamp
}
```

#### products
```json
{
  "shopId": "string",
  "shopName": "string",
  "name": "string",
  "description": "string",
  "price": number,
  "category": "string",
  "imageUrl": "string",
  "isAvailable": boolean,
  "createdAt": timestamp
}
```

#### orders
```json
{
  "userId": "string",
  "shopId": "string",
  "shopName": "string",
  "shopAddress": "string",
  "products": array,
  "totalAmount": number,
  "pickupCode": "string",
  "status": "string", // placed, accepted, ready, completed, cancelled
  "notes": "string",
  "createdAt": timestamp,
  "expiresAt": timestamp
}
```

## 🔐 Firebase Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Shops - owners can create/update their own
    match /shops/{shopId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
                      resource.data.ownerId == request.auth.uid;
    }
    
    // Products - shop owners can manage their products
    match /products/{productId} {
      allow read: if true;
      allow create, update, delete: if request.auth != null;
    }
    
    // Orders - users can create, shops can update
    match /orders/{orderId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
    }
  }
}
```

## 🚀 Deployment Steps

1. **Update Firebase Configuration**
   - Ensure both apps have correct `google-services.json` (Android)
   - Ensure both apps have correct `GoogleService-Info.plist` (iOS)

2. **Update Dependencies**
   ```yaml
   dependencies:
     cloud_firestore: ^4.13.0
     firebase_storage: ^11.5.0
     firebase_auth: ^4.15.0
   ```

3. **Initialize Firebase in Main**
   ```dart
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

4. **Test Thoroughly**
   - Test shop registration
   - Test product upload
   - Test order placement
   - Test order management
   - Test offline scenarios

5. **Remove Backend**
   - Archive `backend/` folder
   - Update documentation
   - Remove backend deployment scripts

## 📝 Testing Checklist

### User App
- [ ] Home screen shows real shops or empty state
- [ ] Search works properly
- [ ] Shop details show real products
- [ ] Add to cart works
- [ ] Cart shows added items
- [ ] Place order creates Firebase order
- [ ] Orders screen shows order history
- [ ] Profile shows user info
- [ ] Logout works properly
- [ ] Offline message shows when no internet

### Shop Owner App
- [ ] Dashboard shows real stats
- [ ] Products screen shows shop products
- [ ] Add product uploads to Firebase
- [ ] Orders screen shows real orders
- [ ] Order status updates work
- [ ] Pickup code verification works
- [ ] Profile shows shop info
- [ ] Offline message shows when no internet

## 🎯 Key Benefits

1. **No Backend Maintenance** - Firebase handles all backend infrastructure
2. **Real-time Updates** - Firestore provides real-time data sync
3. **Scalability** - Firebase scales automatically
4. **Cost Effective** - Pay only for what you use
5. **Offline Support** - Firebase has built-in offline capabilities
6. **Security** - Firebase Security Rules protect data

## 📞 Support

If you encounter issues during migration:
1. Check Firebase console for errors
2. Verify security rules are correct
3. Ensure all Firebase services are enabled
4. Check network connectivity
5. Review Firebase logs

---

**Status:** Migration in progress
**Last Updated:** February 8, 2026
