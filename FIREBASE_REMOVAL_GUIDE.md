# 🔥 Firebase Removal & Custom Backend Migration Guide

## Overview
This guide will help you migrate from Firebase (Firestore, Storage, Auth) to a custom backend using:
- **Node.js + Express** for the backend API
- **MongoDB Atlas** for database
- **Cloudinary** for image storage
- **HTTP requests** from Flutter apps

---

## 📋 Prerequisites

### 1. Sign up for MongoDB Atlas (Free)
1. Go to https://www.mongodb.com/cloud/atlas/register
2. Create a free account
3. Create a new cluster (M0 Free tier)
4. Create a database user with password
5. Whitelist your IP address (or use 0.0.0.0/0 for development)
6. Get your connection string (looks like: `mongodb+srv://username:password@cluster.mongodb.net/`)

### 2. Sign up for Cloudinary (Free)
1. Go to https://cloudinary.com/users/register/free
2. Create a free account
3. From your dashboard, note down:
   - Cloud Name
   - API Key
   - API Secret

### 3. Install Node.js
- Download from https://nodejs.org/ (LTS version recommended)
- Verify installation: `node --version` and `npm --version`

---

## 🗑️ STEP 1: Remove Firebase from Flutter Apps

### A. Remove Firebase Dependencies

**Files to modify:**
- `shop_owner_app/pubspec.yaml`
- `user_app/pubspec.yaml`

**Remove these lines:**
```yaml
# Remove these Firebase packages
firebase_core: ^2.24.2
firebase_storage: ^11.6.0
firebase_auth: ^4.15.3
cloud_firestore: ^4.13.6
```

### B. Remove Firebase Configuration Files

**Delete these files:**
- `shop_owner_app/lib/firebase_options.dart`
- `user_app/lib/firebase_options.dart`
- `shop_owner_app/android/app/google-services.json`
- `user_app/android/app/google-services.json`

### C. Remove Firebase Initialization from main.dart

**Before:**
```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

**After:**
```dart
// Remove Firebase initialization completely
```

### D. Delete Firebase Service Files

**Delete these files:**
- `shop_owner_app/lib/services/firebase_service.dart`
- `user_app/lib/services/firebase_service.dart`
- `shop_owner_app/lib/services/photo_upload_service.dart` (we'll replace this)

### E. Run Flutter Clean

```bash
cd shop_owner_app
flutter clean
flutter pub get

cd ../user_app
flutter clean
flutter pub get
```

---

## 🔧 STEP 2: Setup Node.js Backend

See the backend code files created in the `backend/` directory.

---

## 📱 STEP 3: Update Flutter Apps

See the Flutter service files created in both apps.

---

## ✅ Testing Checklist

- [ ] MongoDB Atlas cluster is running
- [ ] Cloudinary account is set up
- [ ] Backend server starts without errors
- [ ] Shop owner app can upload products with images
- [ ] User app can fetch and display products
- [ ] Images load correctly from Cloudinary

---

## 🐛 Troubleshooting

### Backend won't start
- Check if MongoDB connection string is correct in `.env`
- Ensure port 3000 is not already in use
- Run `npm install` to ensure all dependencies are installed

### Images won't upload
- Verify Cloudinary credentials in `.env`
- Check file size (max 10MB by default)
- Ensure image_picker permissions are set in Flutter

### Flutter can't connect to backend
- Update API_BASE_URL in Flutter config
- If testing on physical device, use your computer's IP address instead of localhost
- Ensure backend server is running

---

## 🎉 Migration Complete!

You've successfully migrated from Firebase to a custom backend. Your app now uses:
- ✅ MongoDB for data storage
- ✅ Cloudinary for image hosting
- ✅ Custom Node.js API
- ✅ No Firebase dependencies
