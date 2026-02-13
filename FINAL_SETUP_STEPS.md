# 🎯 FINAL SETUP STEPS - You're Almost Done!

## ✅ What's Already Configured

I've added your credentials to `backend/.env`:

### MongoDB Atlas ✅
```
Cluster: cluster0.ryerrti.mongodb.net
Username: viveksawji06_db_user
Database: marketplace
Status: ✅ Connection string added
```

### Cloudinary ✅ (Partially)
```
Cloud Name: dlyehrepq ✅
API Secret: 313367428372376i5WiI2XkJ6qOZd4rNwIzsHqxF3E ✅
API Key: ⚠️ NEEDS YOUR INPUT
```

---

## ⚠️ YOU NEED TO DO (5 minutes)

### Step 1: Get Your Cloudinary API Key (2 minutes)

Your Cloudinary URL shows `<your_api_key>` which means you need to get the actual API key.

**How to get it:**

1. Go to: https://cloudinary.com/console
2. Log in to your account
3. On the dashboard, you'll see:
   ```
   Cloud name: dlyehrepq
   API Key: [A NUMBER LIKE 123456789012345]  ← Copy this!
   API Secret: 313367428372376i5WiI2XkJ6qOZd4rNwIzsHqxF3E
   ```
4. Copy the API Key (it's a long number)

### Step 2: Update backend/.env (1 minute)

1. Open `backend/.env`
2. Find this line:
   ```env
   CLOUDINARY_API_KEY=<your_api_key>
   ```
3. Replace `<your_api_key>` with the actual number you copied
4. Example:
   ```env
   CLOUDINARY_API_KEY=123456789012345
   ```
5. Save the file

### Step 3: Add Your MongoDB Password (1 minute)

1. In the same `backend/.env` file
2. Find this line:
   ```env
   MONGODB_URI=mongodb+srv://viveksawji06_db_user:<db_password>@cluster0.ryerrti.mongodb.net/marketplace?retryWrites=true&w=majority
   ```
3. Replace `<db_password>` with your actual MongoDB password
4. Example:
   ```env
   MONGODB_URI=mongodb+srv://viveksawji06_db_user:MyPassword123@cluster0.ryerrti.mongodb.net/marketplace?retryWrites=true&w=majority
   ```
5. Save the file

---

## 🚀 Start Your Backend (1 minute)

Open terminal in your project root:

```bash
cd backend
npm install
npm start
```

**Expected output:**
```
✅ MongoDB connected successfully
🚀 Server running on port 3001
📱 API Base URL: http://localhost:3001/api
🏥 Health Check: http://localhost:3001/api/health
```

**Test it:**
Open in browser: http://localhost:3001/api/health

Should return:
```json
{"status":"OK","message":"Marketplace API is running"}
```

---

## 📱 Update Flutter Apps

### Find Your IP Address

**Windows:**
```bash
ipconfig
```

Look for "IPv4 Address" (e.g., `192.168.1.100`)

**Write it here:** ___________________

### Update These 3 Files

Replace `YOUR_IP` with your actual IP address:

#### File 1: Shop Owner - Upload Service
**Path:** `shop_owner_app/lib/services/cloudinary_upload_service.dart`

**Line 15:** Change from:
```dart
static const String API_BASE_URL = 'http://localhost:3000/api';
```

To:
```dart
static const String API_BASE_URL = 'http://YOUR_IP:3001/api';
```

Example:
```dart
static const String API_BASE_URL = 'http://192.168.1.100:3001/api';
```

#### File 2: Shop Owner - Product Service
**Path:** `shop_owner_app/lib/services/product_api_service.dart`

**Line 10:** Change to:
```dart
static const String API_BASE_URL = 'http://YOUR_IP:3001/api';
```

#### File 3: User App - Product Service
**Path:** `user_app/lib/services/product_api_service.dart`

**Line 13:** Change to:
```dart
static const String API_BASE_URL = 'http://YOUR_IP:3001/api';
```

---

## 🏃 Run Flutter Apps

### Shop Owner App

```bash
cd shop_owner_app
flutter clean
flutter pub get
flutter run
```

### User App

```bash
cd user_app
flutter clean
flutter pub get
flutter run
```

---

## 🧪 Test Everything

### 1. Test Backend
✅ Open: http://localhost:3001/api/health
✅ Should return: `{"status":"OK"}`

### 2. Test Upload (Shop Owner App)
1. ✅ Open shop owner app
2. ✅ Navigate to upload product screen
3. ✅ Select an image
4. ✅ Fill in:
   - Name: Test Product
   - Description: This is a test
   - Price: 29.99
   - Category: General
   - Stock: 10
5. ✅ Tap "Upload"
6. ✅ Wait for success message

### 3. Verify in Cloudinary
1. ✅ Go to: https://cloudinary.com/console/media_library
2. ✅ Check folder: marketplace/products
3. ✅ Your image should be there!

### 4. Test Display (User App)
1. ✅ Open user app
2. ✅ Navigate to products list
3. ✅ Your product should appear
4. ✅ Image should load
5. ✅ Tap product to see details

---

## ✅ Final Checklist

- [ ] Got Cloudinary API Key from dashboard
- [ ] Updated `CLOUDINARY_API_KEY` in `backend/.env`
- [ ] Updated MongoDB password in `backend/.env`
- [ ] Ran `npm install` in backend
- [ ] Started backend with `npm start`
- [ ] Backend health check works
- [ ] Found my IP address with `ipconfig`
- [ ] Updated API_BASE_URL in `cloudinary_upload_service.dart`
- [ ] Updated API_BASE_URL in `product_api_service.dart` (shop owner)
- [ ] Updated API_BASE_URL in `product_api_service.dart` (user app)
- [ ] Ran `flutter clean && flutter pub get` in shop_owner_app
- [ ] Ran `flutter clean && flutter pub get` in user_app
- [ ] Shop owner app runs without errors
- [ ] User app runs without errors
- [ ] Uploaded a test product
- [ ] Image appears in Cloudinary
- [ ] Product appears in user app
- [ ] Image loads correctly

---

## 🎉 Success!

When all checkboxes are checked, you've successfully migrated from Firebase to your custom backend!

---

## 🐛 Troubleshooting

### "MongoServerError: bad auth"
→ Your MongoDB password is incorrect. Check it in `.env`

### "Cloudinary configuration error"
→ Make sure you replaced `<your_api_key>` with the actual number

### "Connection refused" from Flutter
→ Make sure:
1. Backend is running (`npm start`)
2. API_BASE_URL has your correct IP
3. Phone and computer on same WiFi

### "Image upload failed"
→ Check all three Cloudinary values in `.env` are correct

---

## 📞 Your Configuration Summary

### Backend (.env file)
```env
PORT=3001
MONGODB_URI=mongodb+srv://viveksawji06_db_user:YOUR_PASSWORD@cluster0.ryerrti.mongodb.net/marketplace
CLOUDINARY_CLOUD_NAME=dlyehrepq
CLOUDINARY_API_KEY=YOUR_API_KEY_NUMBER
CLOUDINARY_API_SECRET=313367428372376i5WiI2XkJ6qOZd4rNwIzsHqxF3E
```

### Flutter Apps
```dart
API_BASE_URL = 'http://YOUR_IP:3001/api'
```

---

## 🚀 Quick Commands Reference

```bash
# Start backend
cd backend && npm start

# Run shop owner app
cd shop_owner_app && flutter run

# Run user app
cd user_app && flutter run

# Test backend
curl http://localhost:3001/api/health

# Find IP
ipconfig
```

---

## 🎯 Next Steps After Success

1. ✅ Test thoroughly on physical devices
2. ✅ Build release APKs when ready
3. ✅ Consider deploying backend to cloud (Heroku, Railway, etc.)
4. ✅ Add more features!

---

**You're just 2 values away from success!**

1. Get Cloudinary API Key
2. Add MongoDB password

Then run everything and test! 🚀
