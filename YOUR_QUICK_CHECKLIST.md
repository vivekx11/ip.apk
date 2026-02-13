# ✅ Your Quick Setup Checklist

## Step 1: Update MongoDB Password (2 minutes)

1. Open `backend/.env`
2. Find this line:
   ```
   MONGODB_URI=mongodb+srv://viveksawji06_db_user:<db_password>@cluster0.ryerrti.mongodb.net/marketplace?retryWrites=true&w=majority
   ```
3. Replace `<db_password>` with your actual MongoDB password
4. Save the file

---

## Step 2: Get Cloudinary Credentials (5 minutes)

1. Go to: https://cloudinary.com/users/register/free
2. Sign up (free account)
3. Go to Dashboard: https://cloudinary.com/console
4. Copy these three values:
   - Cloud Name
   - API Key
   - API Secret

---

## Step 3: Update Cloudinary in .env (1 minute)

1. Open `backend/.env`
2. Update these lines with your actual values:
   ```env
   CLOUDINARY_CLOUD_NAME=your_cloud_name_here
   CLOUDINARY_API_KEY=your_api_key_here
   CLOUDINARY_API_SECRET=your_api_secret_here
   ```
3. Save the file

---

## Step 4: Install & Start Backend (3 minutes)

```bash
cd backend
npm install
npm start
```

**Expected output:**
```
✅ MongoDB connected successfully
🚀 Server running on port 3001
```

**Test it:**
Open in browser: http://localhost:3001/api/health

---

## Step 5: Find Your IP Address (1 minute)

**Windows:**
```bash
ipconfig
```

Look for "IPv4 Address" (e.g., 192.168.1.100)

Write it down: ___________________

---

## Step 6: Update Flutter API URLs (3 minutes)

Update these 3 files with YOUR IP address:

### File 1: `shop_owner_app/lib/services/cloudinary_upload_service.dart`
Line 15:
```dart
static const String API_BASE_URL = 'http://YOUR_IP:3001/api';
```

### File 2: `shop_owner_app/lib/services/product_api_service.dart`
Line 10:
```dart
static const String API_BASE_URL = 'http://YOUR_IP:3001/api';
```

### File 3: `user_app/lib/services/product_api_service.dart`
Line 13:
```dart
static const String API_BASE_URL = 'http://YOUR_IP:3001/api';
```

---

## Step 7: Run Flutter Apps (5 minutes)

### Shop Owner App:
```bash
cd shop_owner_app
flutter clean
flutter pub get
flutter run
```

### User App:
```bash
cd user_app
flutter clean
flutter pub get
flutter run
```

---

## Step 8: Test Everything (5 minutes)

1. ✅ Open shop owner app
2. ✅ Navigate to upload product screen
3. ✅ Select an image
4. ✅ Fill in product details
5. ✅ Tap "Upload"
6. ✅ Wait for success message
7. ✅ Open user app
8. ✅ See your product appear!

---

## 🎉 Done!

**Total time:** ~25 minutes

If everything works, you've successfully migrated from Firebase to your custom backend!

---

## 🐛 Quick Troubleshooting

**Backend won't start?**
→ Check MongoDB password in .env

**Flutter can't connect?**
→ Verify API_BASE_URL has your correct IP

**Image won't upload?**
→ Check Cloudinary credentials in .env

**Need more help?**
→ See [YOUR_SETUP_GUIDE.md](YOUR_SETUP_GUIDE.md)

---

**Let's go!** 🚀
