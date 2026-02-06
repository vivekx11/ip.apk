# Quick Start Guide - Marketplace System

## 🚀 Get Started in 5 Minutes

### Step 1: Start Backend (1 min)
```bash
cd backend
npm install
npm start
# Backend running on http://localhost:3001
```

### Step 2: Get Your IP Address (30 sec)
```bash
ipconfig  # Windows
# Note your IPv4 address (e.g., 192.168.1.100)
```

### Step 3: Update API URLs (1 min)

**User App** - `user_app/lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'http://YOUR_IP:3001/api';
```

**Shop Owner App** - `shop_owner_app/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://YOUR_IP:3001/api';
```

### Step 4: Build Apps (2 min)
```bash
# User App
cd user_app && flutter build apk --release

# Shop Owner App  
cd shop_owner_app && flutter build apk --release
```

### Step 5: Install & Test (30 sec)
```bash
adb install user_app/build/app/outputs/flutter-apk/app-release.apk
adb install shop_owner_app/build/app/outputs/flutter-apk/app-release.apk
```

## 📱 Quick Test Flow

### Shop Owner App:
1. Open app → Register shop
2. Add product → Upload image
3. Wait for orders

### User App:
1. Open app → Enter username
2. Browse shops → View products
3. Place order

## ✅ What You Get

### Features:
- ✅ **No Dummy Data** - Everything from real API
- ✅ **Offline Detection** - "You are offline" message in center
- ✅ **Image Upload** - Firebase Storage integration
- ✅ **Order Management** - Complete order flow
- ✅ **Real-time Updates** - Live data from backend

### Shop Owner Can:
- Register shop with details
- Upload products (image, price, quantity, description)
- View and manage orders
- Verify pickup codes
- Track sales and revenue

### Users Can:
- Enter username (simple registration)
- View registered shops only
- Browse uploaded products
- Place orders
- Track order status

## 🎯 Key Points

1. **No Dummy Data**: All shops and products come from backend
2. **Offline Mode**: Shows "You are offline" in center when network is off
3. **Real API**: Everything integrated with backend
4. **Firebase Images**: Product images stored in Firebase Storage
5. **Order Flow**: Complete order management system

## 📞 Need Help?

Check these files:
- `FINAL_IMPLEMENTATION_GUIDE.md` - Complete implementation details
- `COMPLETE_TESTING_GUIDE.md` - Step-by-step testing
- `BUILD_TROUBLESHOOTING.md` - Build issues solutions

## 🎉 You're Ready!

Your marketplace system is complete and production-ready with:
- Professional UI
- Real API integration
- Proper offline handling
- No dummy data
- Complete order flow

Start testing and enjoy your marketplace app! 🚀